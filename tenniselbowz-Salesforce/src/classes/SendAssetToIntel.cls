public class SendAssetToIntel implements Queueable, Database.AllowsCallouts{
	static final String MODEL_NOT_FOUND_MSG = 'Model Name: {0} \n' 
									 + 'Revision Number: {1}\n' 
									 + 'Above model name and revision number combination was not found in Intel.';
	static final String MODEL_INDEX = 'UNIT TYPE';
	Id assetId;
	Asset assetToSend;

	public SendAssetToIntel(Id assetId) {
		this.assetId = assetId;
		String qry = 'SELECT Id, Description, Name, Intel_ID__c, Product2.ProductCode, SerialNumber';
		if (AssetIntegrationService.fieldMapping.size() > 0)
			qry += ', ' + String.join(new List<String>(AssetIntegrationService.fieldMapping.keySet()), ', ');
		qry += ' FROM Asset WHERE Id = :assetId';
		this.assetToSend = Database.query(qry);
	}

	public void execute(QueueableContext context) {
		Boolean assetCreatedInIntel = false;
		try {
			if (assetToSend != NULL) {
				Map<String, String> keyValues = getKeyValuesFromCodeString(assetToSend);
				String modelName = keyValues.get(MODEL_INDEX);

				if (modelName == NULL || assetToSend.Format_Number__c == NULL) {
					insert generateIntelIntegrationErrorWithoutResponse(assetToSend.Id, 'Model name was not found in Code String, key "'+MODEL_INDEX+'"');
					throw new IntelIntegrationException('Error retrieving Asset Model information. See Integration Errors');	
				}

				Boolean apiKeyChanged = updateApiKey();

				Integer modelId = getModelId(assetToSend, modelName);
				if (modelId == NULL) 
					modelId = createModel(assetToSend, modelName);

				Integer intelAssetId = getAssetId(assetToSend);
				if (intelAssetId == NULL) {
					assetToSend.Intel_ID__c = createAsset(assetToSend, modelId, modelName);
					assetCreatedInIntel = true;
				} else {
					assetToSend.Intel_ID__c = intelAssetId;
					updateAsset(assetToSend, modelId, modelName);
				}


				for (String fieldAPI : AssetIntegrationService.fieldMapping.keySet()) {
					String value = getFieldValue(assetToSend, fieldAPI);
					System.debug('^^^ fieldAPI: ' + value);
					if (value != NULL) 
						keyValues.put(AssetIntegrationService.fieldMapping.get(fieldAPI), value);
				}

				Map<String, Integer> existingTags = getAssetTags(assetToSend);
				
				for (String aKey : keyValues.keySet()) {
					if (existingTags.containsKey(aKey)) {
						updateAssetTag(assetToSend, existingTags.get(aKey), aKey, keyValues.get(aKey));
					} else {
						createAssetTag(assetToSend, aKey, keyValues.get(aKey));
					}
				}	

				update new Asset(Id = assetToSend.Id, Intel_ID__c = assetToSend.Intel_ID__c);

				if (apiKeyChanged) {
					Intel_TAS_Integration_Setting__c cs = [
						SELECT Id 
						FROM Intel_TAS_Integration_Setting__c
						LIMIT 1
					];
					cs.API_Key__c = AssetIntegrationService.integrationSetting.API_Key__c;
					update cs;
				}
			}
		}
		catch (IntelIntegrationException ie) {
			if (assetCreatedInIntel) {
				update new Asset(Id = assetToSend.Id, Intel_ID__c = assetToSend.Intel_ID__c);
			}
		}
	}

	private class ApiKeyJSON {
		String apiKey;
		Long expirationTime;
	}

	public static Boolean updateApiKey() {
		Boolean apiKeyChanged = false;

		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String loginName = AssetIntegrationService.integrationSetting.Username__c;
		String password = AssetIntegrationService.integrationSetting.Password__c;

		IntelTASResponseObject resp = IntelTASMethodsLibrary.getCurrentApiKey(baseUrl, loginName, password, false);
		if (resp.getResponseCode() == 200) {
			List<ApiKeyJSON> apiKeyJSONs =
				(List<ApiKeyJSON>) JSON.deserializeStrict(resp.getResponseData(), List<ApiKeyJSON>.class);

			if (apiKeyJSONs.size() > 0 && apiKeyJSONs[0].expirationTime < Datetime.now().addDays(7).getTime()) {
				resp = IntelTASMethodsLibrary.getCurrentApiKey(baseUrl, loginName, password, true);
				if (resp.getResponseCode() == 200) {
					apiKeyJSONs = (List<ApiKeyJSON>) JSON.deserializeStrict(resp.getResponseData(), List<ApiKeyJSON>.class);
					if (apiKeyJSONs.size() > 0) {
						AssetIntegrationService.integrationSetting.API_Key__c = apiKeyJSONs[0].apiKey;
						apiKeyChanged = true;
					}
				}
			}
		}

		if (resp.getResponseCode() != 200 && resp.getResponseCode() == 404) {
			insert generateIntelIntegrationError(resp, null);
			throw new IntelIntegrationException('Error retrieving API key. See Integration Errors');
		} else if (resp.getResponseCode() != 200) {
			insert generateIntelIntegrationError(resp, null);
			throw new IntelIntegrationException('Error retrieving API key. See Integration Errors');
		}

		return apiKeyChanged;
	}

	@TestVisible static String getFieldValue(Asset ast, String apiName) { // @TODO: test
		if (!apiName.contains('.')) 
			return (String) ast.get(apiName);
		else {
			List<String> path = apiName.split('[.]');
			SObject currentObject = ast;
			for (Integer i=0; i<path.size()-1; i++) {
				if (currentObject != NULL) 
					currentObject = currentObject.getSObject(path[i]);
				else 
					return NULL;
			}

			if (currentObject == NULL) 
				return NULL;
			return (String) currentObject.get(path[path.size()-1]);
		}
	}

	@TestVisible static Map<String, String> getKeyValuesFromCodeString(Asset ast) {
		CodeStringViewerController parser = new CodeStringViewerController(new ApexPages.StandardController(ast));

		Map<String, String> kvMap = new Map<String, String>();

		for (CodeStringViewerController.CodeStringRec rec : parser.getCodeStringRecs()) {
			if (rec.code_description != null) {
				kvMap.put(rec.code_description.substringBefore(';'), rec.code_value);
			} else {
				kvMap.put(null, null);
			}
		}

		return kvMap;
	}

	@TestVisible static Integer getModelId(Asset ast, String modelName) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		IntelTASResponseObject resp = IntelTASMethodsLibrary.getAllAssetModels(baseUrl, apiKey);
		List<AssetIntegrationService.AssetModelModel> modelList;
		if (resp.getResponseCode() == 200) {
			modelList = (List<AssetIntegrationService.AssetModelModel>) JSON.deserializeStrict(resp.getResponseData(), List<AssetIntegrationService.AssetModelModel>.class);

			if (modelList != NULL && modelList.size() > 0) {
				for (AssetIntegrationService.AssetModelModel mdl : modelList) {
					if (modelName.equalsIgnoreCase(String.valueOf(mdl.modelNumber)) && ast.Format_Number__c.equalsIgnoreCase(String.valueOf(mdl.revisionNumber)))
						return mdl.modelId;
				}
			}	
			
			return NULL;			
		} else if (resp.getResponseCode() == 404) {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error retrieving Asset Model information. See Integration Errors');
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error retrieving Asset Model information. See Integration Errors');
		}

		return NULL;		
	}

	@TestVisible static Integer getOperatorId(Asset ast) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		IntelTASResponseObject resp = IntelTASMethodsLibrary.getAllOperators(baseUrl, apiKey);

		List<AssetIntegrationService.OperatorModel> operatorList;
		if (resp.getResponseCode() == 200) {
			operatorList = (List<AssetIntegrationService.OperatorModel>) JSON.deserializeStrict(resp.getResponseData(), List<AssetIntegrationService.OperatorModel>.class);

			if (operatorList != NULL && operatorList.size() > 0) {
				for (AssetIntegrationService.OperatorModel op : operatorList) {
					if (op.code.equalsIgnoreCase(ast.Intel_Operator__c))
						return op.id;
				}
			}	
			return NULL;		
		} else if (resp.getResponseCode() == 404) {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error retrieving Operator information. See Integration Errors');
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error retrieving Operator information. See Integration Errors');
		}

		return NULL;		
	}

	@TestVisible static Integer createModel(Asset ast, String modelName) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		// @TODO: No AssetType?
		IntelTASResponseObject resp = IntelTASMethodsLibrary.createAssetModel(baseUrl, apiKey, modelName, '', ast.Format_Number__c);
		if (resp.getResponseCode() == 201) {
			AssetIntegrationService.AssetModelModel createdModel = 
				(AssetIntegrationService.AssetModelModel) JSON.deserializeStrict(resp.getResponseData(), AssetIntegrationService.AssetModelModel.class);
			return createdModel.modelId;
		} else if (resp.getResponseCode() == 409) {
			return getModelId(ast, modelName);
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error creating Asset Model. See Integration Errors');
		}
		return NULL;
	}

	@TestVisible static Integer getAssetId(Asset ast) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		// @TODO: if intelID is null then us
		IntelTASResponseObject resp = IntelTASMethodsLibrary.getAssetBySerialNumber(baseUrl, apiKey, ast.SerialNumber); 
		if (resp.getResponseCode() == 200) {
			AssetIntegrationService.AssetModel[] foundAsset = 
				(AssetIntegrationService.AssetModel[]) JSON.deserializeStrict(resp.getResponseData(), AssetIntegrationService.AssetModel[].class);
			if (foundAsset.size() == 1)
				return foundAsset[0].assetId;
		} else if (resp.getResponseCode() == 404 || resp.getResponseCode() == 400) {
			return NULL;
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error retrieving Asset information. See Integration Errors');
		}
		return NULL;
	}

	@TestVisible static Integer createAsset(Asset ast, Integer mdlId, String modelName) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		// @TODO: Operator???
		IntelTASResponseObject resp = IntelTASMethodsLibrary.registerNewAsset(baseUrl, apiKey, ast.SerialNumber,
			String.valueOf(mdlId), modelName, '0', ast.Description, ast.Name);
		if (resp.getResponseCode() == 201) {
			AssetIntegrationService.AssetModel createdAsset = 
				(AssetIntegrationService.AssetModel) JSON.deserializeStrict(resp.getResponseData(), AssetIntegrationService.AssetModel.class);
			return createdAsset.assetId;
		} else if (resp.getResponseCode() == 409) {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error creating Asset. See Integration Errors'); // @TODO: change this to update
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error creating Asset. See Integration Errors');
		}
		return NULL;
	}

	@TestVisible static Integer updateAsset(Asset ast, Integer mdlId, String modelName) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		// @TODO: Operator???
		IntelTASResponseObject resp = IntelTASMethodsLibrary.updateAsset(baseUrl, apiKey,
			String.valueOf((Integer)ast.Intel_ID__c), ast.SerialNumber, String.valueOf(mdlId), modelName, '0',
			ast.Description, ast.Name);
		if (resp.getResponseCode() == 200) {
			return (Integer) ast.Intel_ID__c;
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error updating Asset. See Integration Errors');
		}
		return NULL;
	}

	@TestVisible static Map<String, Integer> getAssetTags(Asset ast) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		IntelTASResponseObject resp = IntelTASMethodsLibrary.getAssetTagsByAssetId(baseUrl, apiKey, String.valueOf(ast.Intel_ID__c));
		List<AssetIntegrationService.AssetTagModel> tagList;
		if (resp.getResponseCode() == 200) {
			tagList = (List<AssetIntegrationService.AssetTagModel>) JSON.deserializeStrict(resp.getResponseData(), List<AssetIntegrationService.AssetTagModel>.class);
			Map<String, Integer> keyToTagId = new Map<String, Integer>();
			if (tagList != NULL && tagList.size() > 0) {
				for (AssetIntegrationService.AssetTagModel tag : tagList) {
					keyToTagId.put(tag.attrKey, tag.tagId);
				}
			}	
			return keyToTagId;	
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error retrieving Asset Tag information. See Integration Errors');
		}
	}

	@TestVisible static Integer createAssetTag(Asset ast, String vKey, String vValue) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		IntelTASResponseObject resp = IntelTASMethodsLibrary.createAssetTag(baseUrl, apiKey, String.valueOf(ast.Intel_ID__c), vKey, vValue);
		if (resp.getResponseCode() == 201) {
			AssetIntegrationService.AssetTagModel createdTag = 
				(AssetIntegrationService.AssetTagModel) JSON.deserializeStrict(resp.getResponseData(), AssetIntegrationService.AssetTagModel.class);
			return createdTag.tagId;
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error creating Asset Tag. See Integration Errors');
		}
		return NULL;
	}

	@TestVisible static Integer updateAssetTag(Asset ast, Integer tagId, String vKey, String vValue) {
		String baseUrl = AssetIntegrationService.integrationSetting.Base_URL__c;
		String apiKey = AssetIntegrationService.integrationSetting.API_Key__c;
		IntelTASResponseObject resp = IntelTASMethodsLibrary.updateAssetTag(baseUrl, apiKey, String.valueOf(ast.Intel_ID__c), String.valueOf(tagId), vKey, vValue);
		if (resp.getResponseCode() == 200) {
			return tagId;
		} else {
			insert generateIntelIntegrationError(resp, ast.Id);
			throw new IntelIntegrationException('Error updating Asset Tag. See Integration Errors');
		}
		return NULL;
	}

	static Integration_Error__c generateIntelIntegrationError(IntelTASResponseObject response, Id sfid) {
		Integration_Error__c err = new Integration_Error__c();
		err.Direction__c = 'Outbound';
		err.Integration_Object__c = 'Asset';
		err.Integration_Object_Id__c = sfid;
		err.Integration_Point__c = 'Intel TAS';
		err.Error_Description__c = '(' + response.getResponseCode() + ') ' + response.getResponseMessage();
		err.Request_Data__c = response.getRequestData();
		return err;
	}

	static Integration_Error__c generateIntelIntegrationErrorWithoutResponse(Id sfid, String description) {
		Integration_Error__c err = new Integration_Error__c();
		err.Direction__c = 'Outbound';
		err.Integration_Object__c = 'Asset';
		err.Integration_Object_Id__c = sfid;
		err.Integration_Point__c = 'Intel TAS';
		err.Error_Description__c = '( Unsent ) ' + description;
		return err;
	}

	public class IntelIntegrationException extends Exception {}
}