@RestResource(urlMapping='/OpportunityIntegrationService')
global with sharing class DaikinToolsOpptyUpdateService
{
    public static final Set<String> ACCEPTED_ADDRESS_TYPES = new Set<String>{ 'ALT', 'BA', 'DES', 'END', 'GC', 'JOB', 'LEN', 'OWN', 'SHP', 'SLD', 'TSC' };
    public static final String DAIKIN_TOOLS_SOURCE = 'Daikin Tools';
    public static final String OPS_SOURCE = 'OPS';
    public static final String ERROR_DIRECTION = 'Inbound Post';
    public static final string ACCEPTED = 'Accepted';
    
    public static Id DEFAULT_PRICEBOOK_ID
    {
        get
        {
            if( DEFAULT_PRICEBOOK_ID == NULL )
            {
                DEFAULT_PRICEBOOK_ID = [ SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE LIMIT 1 ].Id;
            }
            return DEFAULT_PRICEBOOK_ID;
        }
        private set;
    }
    
    @testVisible
    public static List<String> fieldsToDeleteFromOppty {
    	get
    	{
    		if(fieldsToDeleteFromOppty == null){
    			fieldsToDeleteFromOppty = new List<String>();
    			for(Schema.FieldSetMember aField : Schema.SObjectType.Opportunity.FieldSets.DST_Fields_for_Delete.getFields()){
    				fieldsToDeleteFromOppty.add( aField.getFieldPath() );
    			}
    		}
    		return fieldsToDeleteFromOppty;
    	}
    	set;
    }

    @HttpPost
    global static void doPost()
    {
        OpportunityUpdateRequest theRequest = (OpportunityUpdateRequest)JSON.deserializeStrict(RestContext.request.requestBody.toString(), OpportunityUpdateRequest.class);
        system.debug(logginglevel.error, theRequest);

        OpportunityUpdateResponse theResponse = new OpportunityUpdateResponse();
        
        // gather external ids and key values from request
        Set<String> opportunitySFDCIDs = new Set<String>();
        Set<String> oliGUIDs = new Set<String>();
        Set<String> productCodes = new Set<String>();
        
        //We need to add Accessories to our Opportunity as line items, but cannot modify a collection while it is being iterated, so we need to use the Opp List Index.
        Map<Integer, List<Request_OpportunityItem>> opportunityListIndexToAccessoryLineItem = new Map<Integer, List<Request_OpportunityItem>> ();
        Set<String> allDSTIds = new Set<String>();
        
        for( integer i = 0; i < theRequest.Opportunities.size();  i++  )
        {
            List<Request_OpportunityItem> accessories = new List<Request_OpportunityItem>();
            Request_Opportunity aRequestOpportunity = theRequest.Opportunities[i];
            if(aRequestOpportunity.Items != null) {
                for( Request_OpportunityItem aRequestOLI : aRequestOpportunity.Items )
                {
                    if(aRequestOli.accessories != null){
                        for(Request_OpportunityAccessory accessory : aRequestOli.accessories ){
                            Request_OpportunityItem accessoryOli = mapAccessoryToOpportunityLineItem(accessory,  aRequestOLI);
                            accessories.add(accessoryOli);
                            allDSTIds.add(accessoryOli.GUID);
                        }
                    }
                    allDSTIds.add(aRequestOLI.GUID);
                }
            }
            opportunityListIndexToAccessoryLineItem.put(i, accessories);
        }
        for(Integer key : opportunityListIndexToAccessoryLineItem.keyset()){
            theRequest.Opportunities[key].items.addAll(opportunityListIndexToAccessoryLineItem.get(key));
        }
        
        
        
        for( Request_Opportunity aRequestOpportunity : theRequest.Opportunities )
        {
            opportunitySFDCIDs.add( aRequestOpportunity.SFDCID );
            if( aRequestOpportunity.Items != NULL )
            {
                for( Request_OpportunityItem aRequestOLI : aRequestOpportunity.Items )
                {
                    oliGUIDs.add( aRequestOLI.Guid );
                    productCodes.add( aRequestOLI.ModelNumber );
                }
            }
        }
         
        // retrieve and group sfdc records for external ids from request
        Map<String, Opportunity> foundOpportunitiesBySFDCId = new Map<String, Opportunity>();
        Map<String, OpportunityLineItem> foundOLIsByGUID = new Map<String, OpportunityLineItem>();
        Map<Id, OpportunityLineItem> foundOLIsBySFDCID = new Map<Id, OpportunityLineItem>();
        Set<String> oldProductCodes = new Set<String>(); 
        
        // find any existing opportunities by external id and retrieve all related olis
        for( Opportunity anOpportunity : [ SELECT Id, DST_ID__c, Pricebook2Id, StageName, (SELECT Id, DST_ID__c, ProductCode, DT_Item_Status__c, OpportunityId, PricebookEntryId, Name FROM OpportunityLineItems) FROM Opportunity
                                            WHERE Id IN :opportunitySFDCIDs ] )
        {
            foundOpportunitiesBySFDCId.put( anOpportunity.Id, anOpportunity );

            for( OpportunityLineItem anOLI : anOpportunity.OpportunityLineItems )
            {
                if( String.IsNotBlank( anOLI.DST_ID__c ) ){
                	// foundOLIsByGUID holds OLIS found in db uses the DST (Model Number) as map key
                    foundOLIsByGUID.put( anOLI.DST_ID__c, anOLI );
                }
                if(String.isNotBlank( anOLI.productCode)){
                    oldProductCodes.add(anOli.ProductCode);
                }
                foundOLIsBySFDCID.put(anOLI.Id, anOli);
            }
        }
        Map<Id, PricebookEntry> pricebookEntryMap = new Map<Id, PricebookEntry>(); 
        Map<String, Map<Id, PricebookEntry>> foundProductsByProductCode = new Map<String, Map<Id, PricebookEntry>>();
        for( PricebookEntry aPricebookEntry : [ SELECT Id, Product2.ProductCode, Pricebook2Id FROM PricebookEntry 
                                                WHERE Pricebook2Id = :DEFAULT_PRICEBOOK_ID
                                                AND (Product2.ProductCode IN :productCodes OR Product2.ProductCode IN :oldProductCodes) ] )
        {
            if( !foundProductsByProductCode.containsKey( aPricebookEntry.Product2.ProductCode ) ){
                foundProductsByProductCode.put( aPricebookEntry.Product2.ProductCode, new Map<Id, PricebookEntry>() );
            }
            
            foundProductsByProductCode.get( aPricebookEntry.Product2.ProductCode ).put( aPricebookEntry.Pricebook2Id, aPricebookEntry );
            pricebookEntryMap.put(aPricebookEntry.Id, aPricebookEntry);
        }
        
        Map<String, List<OpportunityLineItem>> allOliMap = GroupBy.strings('DST_ID__c', [Select id, OpportunityID, DST_ID__c, Name from OpportunityLineItem where DST_ID__c IN: allDSTIds]);
        
        // start to reconcile request with response
        Map<String, Product2> productsToCreate = new Map<String, Product2>();
        List<PricebookEntry> pricebookEntriesToCreate = new List<PricebookEntry>();
        
        Map<String, Response_Opportunity> responseOpportunityByGUID = new Map<String, Response_Opportunity>();
        Map<String, Response_Opportunity> responseOpportunityBySFDCID = new Map<String, Response_Opportunity>();
        List<OpportunityLineItem> lineItemsToDelete = new List<OpportunityLineItem>();
        
        // PROCCESS OPPORTUNITIES
        for( Request_Opportunity aRequestOpportunity : theRequest.Opportunities )
        {
            Response_Opportunity responseOpportunity = new Response_Opportunity( aRequestOpportunity.JobGuid, aRequestOpportunity.SFDCID );
	        /*if(aRequestOpportunity.Items != null ){	
	        	for( Request_OpportunityItem aRequestOLI : aRequestOpportunity.Items )
	            {
	                responseOpportunity.addItem( aRequestOLI.Guid, aRequestOpportunity.SFDCID );
	            }
	        }	*/
            responseOpportunityByGUID.put( aRequestOpportunity.JobGuid, responseOpportunity );
            responseOpportunityBySFDCID.put( aRequestOpportunity.SFDCID, responseOpportunity );
            theResponse.Opportunities.add( responseOpportunity );

            if( !foundOpportunitiesBySFDCId.containsKey( aRequestOpportunity.SFDCID ) )
            {
                responseOpportunity.addError( 'OPPORTUNITY_NOT_FOUND', 'An Opportunity with SFDC Id ' + aRequestOpportunity.SFDCID + ' was not found' );
            }
            else
            {
                // the sfdcOpportunity is the "matched" opportunity found using the SF ID in the DB
                Opportunity sfdcOpportunity = foundOpportunitiesBySFDCId.get( aRequestOpportunity.SFDCID );
                if( sfdcOpportunity.DST_ID__c != NULL && sfdcOpportunity.DST_ID__c != aRequestOpportunity.JobGuid )
                {
                    // the SF IDs match but the Job GUID do not
                    responseOpportunity.addError( 'INCORRECT_ID', 'The Job Guid on ' + aRequestOpportunity.SFDCID + ' does not match' );
                    continue;
                }
                
                // map all the Opportunity fields 
                mapOpportunityValues(sfdcOpportunity, aRequestOpportunity, responseOpportunity, theRequest.source);
                
                // PROCCESS PRODUCT ITEMS (OLIs)
                if( aRequestOpportunity.Items == NULL ) continue; 
                Set<Id> matchingOliId = new Set<Id>();
                
                
                for( Request_OpportunityItem anItem : aRequestOpportunity.Items )
                {
                    OpportunityLineItem theOLI;
                    // CHANGE MODEL NUMBER OF OLI
                    if( theRequest.Source == DAIKIN_TOOLS_SOURCE && foundOLIsByGUID.containsKey( anItem.Guid ) )
                    {
                        theOLI = foundOLIsByGUID.get( anItem.Guid );
                        matchingOliId.add( theOLI.Id );
                        String oldModelNumber = getOpportunityLineItemProductCode(pricebookEntryMap, theOLI);
                        // Daikin only, OPS will not change the model number
                        
                        if(oldModelNumber != anItem.modelNumber){
                           
                            OpportunityLineItem newOli = theOLI.clone(false, true);
                            createOpportunityLineItemProducts(foundProductsByProductCode, sfdcOpportunity, newOli,  anItem, 
                                                              productsToCreate, pricebookEntriesToCreate);
                            foundOLIsByGUID.put( anItem.Guid, newOli);
                            if(theOLI.DST_ID__c != null)
                                lineItemsToDelete.add(theOLI);
                            
                            theOLI = newOli;
                        }
                        
                        mapOpportunityLineItemValues(theOLI, anItem, theRequest);
                    }
                    else if( theRequest.Source == OPS_SOURCE && foundOLIsBySFDCID.containsKey( anItem.SFDCID )){
                        theOLI = foundOLIsBySFDCID.get( anItem.SFDCID );
                        matchingOliId.add( theOLI.Id );
                        
                        mapOpportunityLineItemValues(theOLI, anItem, theRequest);
                    }
                    else
                    {
                    	// The requested OLI does not exist so lets create it
                        theOLI = new OpportunityLineItem();
                        theOLI.DST_ID__c = anItem.Guid;
                        theOLI.OpportunityId = sfdcOpportunity.Id;
                        theOLI.IsAlternate__c = anItem.BaseBidOrAlternate == 1 ? TRUE : FALSE;
                        theOLI.DT_Parent_ID__c = anItem.ParentGUID;
                        
                        mapOpportunityLineItemValues(theOLI, anItem, theRequest);
                        createOpportunityLineItemProducts(foundProductsByProductCode, sfdcOpportunity, theOLI,  anItem, 
                                                         productsToCreate, pricebookEntriesToCreate);
                        foundOLIsByGUID.put( anItem.Guid, theOLI );
                        
                        //If the Opportunity Line Item exists on different Opportunity, we need to delete that OLI.
                        if(theRequest.Source == DAIKIN_TOOLS_SOURCE && anItem.guid != null && allOliMap.containsKey(anItem.guid) ){
                            lineItemsToDelete.addAll(allOliMap.get(anItem.guid));
                        }
                        
                    }
                    
                    // PROCCESS CODE ITEM INFORMATION
                    List<String> codeItemStrings = new List<String>();
                    if( anItem.CodeItems != NULL )
                    {
                        for( Request_OpportunityCodeItem aCodeItem : anItem.CodeItems )
                        {
                            List<String> codeItemInfo = new List<String>();
                            codeItemInfo.add( 'Item Number: ' + aCodeItem.Item );
                            codeItemInfo.add( 'Value: ' + aCodeItem.Value );
                            codeItemInfo.add( 'ValueDescription: ' + aCodeItem.ValueDescription );
                            codeItemInfo.add( 'Description: ' + aCodeItem.Description );
                            codeItemInfo.add( 'List Price: ' + aCodeItem.ListPrice );
                            codeItemInfo.add( 'Special: ' + aCodeItem.IsSpecial );
                            codeItemInfo.add( 'Special Description: ' + aCodeItem.SpecialText );
                            codeItemStrings.add( String.join( codeItemInfo, '\n' ) );
                        }
                    }
                    theOLI.DT_Code_Item__c = String.join( codeItemStrings, '\n\n' );

                    // PROCCESS INPUTS AND OUTPUTS
                    List<String> inputsAndOutputsStrings = new List<String>();
                    if( anItem.Properties != NULL )
                    {
                        List<String> propertyItemStrings = new List<String>();
                        for( Request_OpportunityProperty aProperty : anItem.Properties )
                        {
                            String propertyLine = String.format( '\t{0} ({1}): {2}', new List<String>{ aProperty.Name, aProperty.Value, aProperty.Description } );
        
                            propertyItemStrings.add( propertyLine );
                        }
                        if( !propertyItemStrings.isEmpty() )
                        {
                            propertyItemStrings.add( 0, 'Properties' );
                            inputsAndOutputsStrings.add( String.join( propertyItemStrings, '\n' ) );
                        }
                    }
                    if( anItem.Components != NULL )
                    {
                        List<String> componentItemStrings = new List<String>();
                        for( Request_OpportunityComponent aComponent : anItem.Components )
                        {
                            componentItemStrings.add( String.format( '{0} ({1})', new List<String>{ String.valueOf( aComponent.Id ), String.valueOf( aComponent.Type ) } ) );
                            if( !aComponent.Properties.isEmpty() )
                            {
                                componentItemStrings.add( '\tProperties' );
                            }
                            for( Request_OpportunityComponentProperty aCompProperty : aComponent.Properties )
                            {
                                componentItemStrings.add( String.format( '\t\t{0} ({1}): {2}', new List<String>{ aCompProperty.Name, aCompProperty.Value, aCompProperty.Description } ) );
                            }
                        }
                        if( !componentItemStrings.isEmpty() )
                        {
                            inputsAndOutputsStrings.add( String.join( componentItemStrings, '\n' ) );
                        }
                    }
                    theOLI.DT_InputsAndOutputs__c = String.join( inputsAndOutputsStrings, '\n' );
                }
                
                //find the olis that need to be deleted for this opportunity
                if( theRequest.Source == DAIKIN_TOOLS_SOURCE )
                {
                    for( OpportunityLineItem opOlis : sfdcOpportunity.OpportunityLineItems )
                    {
                        // only delete OLIs without a DST ID 
                        if( opOlis.DST_ID__c !=null && !matchingOliId.contains( opOlis.Id ))
                            lineItemsToDelete.add( opOlis );
                    }
                }
            }
        }
        
        
        // start doing DMLs
        List<Integration_Error__c> errors = new List<Integration_Error__c>();

        if( !lineItemsToDelete.isEmpty() )
        {
            try
            {
                delete lineItemsToDelete;
            }
            catch( System.DmlException ex )
            {
                for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
                {
                    theResponse.addError( 'CANNOT_DELETE_ITEM', lineItemsToDelete[errorIndex].Name + ': ' + ex.getDmlMessage(errorIndex) );
                    errors.add(createErrorLog( 'Opportunity Line Item Delete Error ['+ex.getDmlMessage(errorIndex)+']', 'OpportunityLineItem', theRequest ));
                }
            }
        }
        
        List<Product2> productsList = productsToCreate.values();
        
       
        try
        {
            insert productsList;
            createPriceItems(productsList, theResponse, theRequest, errors);    
            
        }
        catch( System.DmlException ex )
        {
            for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
            {
                theResponse.addError( 'CANNOT_CREATE_PRODUCT', productsList[errorIndex].Name + ': ' + ex.getDmlMessage(errorIndex) );
                errors.add(createErrorLog( 'Product Creation Error ['+ex.getDmlMessage(errorIndex)+']', 'Product2', theRequest ));
            }
        }	
        
        

        for( PricebookEntry anEntry : pricebookEntriesToCreate )
        {
            anEntry.Product2Id = anEntry.Product2.Id;
        }
        try
        {
            insert pricebookEntriesToCreate;
        }
        catch( System.DmlException ex )
        {
            for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
            {
                theResponse.addError( 'CANNOT_CREATE_PRICEBOOKENTRY', pricebookEntriesToCreate[errorIndex].Product2.Name + ': ' + ex.getDmlMessage(errorIndex) );
                errors.add(createErrorLog( 'PricebookEntry Creation Error ['+ex.getDmlMessage(errorIndex)+']', 'Pricebookentry', theRequest ));
            }
        }
        
        List<Opportunity> opportunitiesToUpdate = foundOpportunitiesBySFDCId.values();
        try
        {
            update opportunitiesToUpdate;
        }
        catch( System.DmlException ex )
        {
            for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
            {
                
                String errorGUID = opportunitiesToUpdate[ex.getDmlIndex(errorIndex)].DST_ID__c;
                responseOpportunityByGUID.get( errorGUID ).addError( 'CANNOT_UPDATE_OPPORTUNITY', errorGUID + ': ' + ex.getDmlMessage(errorIndex) );
                errors.add(createErrorLog( 'Opportunity Update Error ['+ex.getDmlMessage(errorIndex)+']', 'Opportunity', theRequest ));
            }
        }

        List<OpportunityLineItem> olisToUpsert = new List<OpportunityLineItem>();
        
        Map<Id, OpportunityLineItem> deletedMap = new Map<Id, OpportunityLineItem> (lineItemsToDelete);
        for( OpportunityLineItem anOLI : foundOLIsByGUID.values() )
        {
        	// if its a new OLI lets assign it a PricebookEntryId
            if(anOli.Id == null){
            	
            	anOLI.PricebookEntryId = anOLI.PricebookEntry.Id;
            	
        	} 
        	if(!deletedMap.containsKey(anoli.id)){
        	    olisToUpsert.add(anOli);
        	}

        }
        try
        {
			System.debug('--> INSERTING OLIs:'+ olisToUpsert); 
			
            upsert olisToUpsert OpportunityLineItem.DST_ID__c;
            for(OpportunityLineItem anOLI : olisToUpsert){
            	if(responseOpportunityBySFDCID.containsKey(anOLI.OpportunityId) ){
            		responseOpportunityBySFDCID.get( anOLI.OpportunityId).addItem(anOLI.DST_ID__c, anOLI.Id);
            	}
            }
        }
        catch( System.DmlException ex )
        {
            
            Map<Id, Opportunity> opportunitiesMap = new Map<Id, Opportunity>(opportunitiesToUpdate);
            for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
            {
                Response_Opportunity errorOpportunity = responseOpportunityByGUID.get( opportunitiesMap.get( olisToUpsert[errorIndex].OpportunityId ).DST_ID__c );
                if(errorOpportunity != null) {
                    errorOpportunity.addError( 'CANNOT_UPDATE_ITEM', olisToUpsert[errorIndex].DST_ID__c + ': ' + ex.getDmlMessage(errorIndex) );
                }
                errors.add(createErrorLog( 'Opportunity Line Item Upsert Error ['+ex.getDmlMessage(errorIndex)+']', 'OpportunityLineItem', theRequest ));
            }
        }
         
        
        
        if( !errors.isEmpty() )
        {
            try{    
                insert errors;
            }
            catch( System.DmlException ex )
            {
                for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
                {
                    theResponse.addError( 'CANNOT_CREATE_ERROR_RECORD', errors[errorIndex].Name + ': ' + ex.getDmlMessage(errorIndex) );
                }
            }
        }
        
        RestContext.response.responseBody = Blob.valueOf( JSON.serialize(theResponse) );
        RestContext.response.addHeader( 'Content-Type', 'application/json' );
    }

    private static Integration_Error__c createErrorLog( String description, String intObject, OpportunityUpdateRequest req  )
    {
        Integration_Error__c errorLog = new Integration_Error__c();
        errorLog.Direction__c = ERROR_DIRECTION;
        errorLog.Error_Description__c = description;
        errorLog.Integration_Object__c = intObject;
        errorLog.Integration_Point__c = req.Source;
        //errorLog.Request_Data__c = JSON.serialize(req);
        
        return errorLog;
    }
    @HttpDelete
    global static void doDelete()
    {
        OpportunityUpdateRequest theRequest = (OpportunityUpdateRequest)JSON.deserializeStrict(RestContext.request.requestBody.toString(), OpportunityUpdateRequest.class);
        system.debug(logginglevel.error, theRequest);

        OpportunityUpdateResponse theResponse = new OpportunityUpdateResponse();
        
        // gather external ids and key values from request
        Set<String> opportunityGUIDs = new Set<String>();
        Set<String> oliGUIDs = new Set<String>();
        for( Request_Opportunity aRequestOpportunity : theRequest.Opportunities )
        {
            opportunityGUIDs.add( aRequestOpportunity.JobGuid );
            if( aRequestOpportunity.Items != NULL )
            {
                for( Request_OpportunityItem aRequestOLI : aRequestOpportunity.Items )
                {
                    oliGUIDs.add( aRequestOLI.Guid );
                }
            }
        }

        Map<String, Opportunity> foundOpportunitiesBySFDCId = new Map<String, Opportunity>();
        Map<String, OpportunityLineItem> foundOLIsByGUID = new Map<String, OpportunityLineItem>();
        
        for( Opportunity anOpportunity : [ SELECT Id, DST_ID__c, Synced_Quote_Proposal__c, Synced_Quote_Proposal__r.Apttus_Proposal__Approval_Stage__c, (SELECT Id, DST_ID__c, OpportunityId, Name FROM OpportunityLineItems) FROM Opportunity
                                            WHERE DST_ID__c IN :opportunityGUIDs AND DST_ID__c != NULL ] )
        {
            foundOpportunitiesBySFDCId.put( anOpportunity.Id, anOpportunity );

            for( OpportunityLineItem anOLI : anOpportunity.OpportunityLineItems )
            {
                foundOLIsByGUID.put( anOLI.DST_ID__c, anOLI );
            }
        }
        Map<Id, Response_Opportunity> responseOpportunityBySFDCId = new Map<Id, Response_Opportunity>();
        for( Request_Opportunity aRequestOpportunity : theRequest.Opportunities )
        {
            Response_Opportunity responseOpportunity = new Response_Opportunity( aRequestOpportunity.JobGuid, aRequestOpportunity.SFDCID );
            theResponse.Opportunities.add( responseOpportunity );

            if( !foundOpportunitiesBySFDCId.containsKey( aRequestOpportunity.SFDCID ) )
            {
                responseOpportunity.addError( 'OPPORTUNITY_NOT_FOUND', 'An Opportunity with Job GUID ' + aRequestOpportunity.JobGuid + ' was not found' );
            }
            else
            {
                Opportunity sfdcOpportunity = foundOpportunitiesBySFDCId.get( aRequestOpportunity.SFDCID );
                if(sfdcOpportunity.Synced_Quote_Proposal__c != NULL && sfdcOpportunity.Synced_Quote_Proposal__r.Apttus_Proposal__Approval_Stage__c ==  ACCEPTED){
                    
                    foundOpportunitiesBySFDCId.remove( aRequestOpportunity.SFDCID );
                    if( aRequestOpportunity.Items != NULL )
                    {
                        for( Request_OpportunityItem aRequestOLI : aRequestOpportunity.Items )
                        {
                            if(foundOLIsByGUID.containsKey( aRequestOLI.Guid )){
                                foundOLIsByGUID.remove(aRequestOLI.Guid  );
                            }
                        }
                    }
                    responseOpportunity.addError( 'INVALID_OPPORTUNITY', 'The Primary Quote has already been accepted by the customer and cannot be changed for ' +aRequestOpportunity.SFDCID );
                    continue; //if there is a quote attached, don't perform a delete on this opp.
                }
                responseOpportunityBySFDCId.put( sfdcOpportunity.Id, responseOpportunity );
                for( String  aFieldPath : fieldsToDeleteFromOppty )
                {
                    sfdcOpportunity.put( aFieldPath, null );
                }
                if( aRequestOpportunity.Items != NULL )
                {
                    for( Request_OpportunityItem aRequestOLI : aRequestOpportunity.Items )
                    {
                        if( !foundOLIsByGUID.containsKey( aRequestOLI.Guid ) )
                        {
                            responseOpportunity.addError( 'ITEM_NOT_FOUND', 'An Opportunity Line Item with GUID ' + aRequestOLI.Guid + ' was not found' );
                            //System.assert(false, 'An Opportunity Line Item with GUID ' + aRequestOLI.Guid + ' was not found');
                        }
                        else
                        {
                            OpportunityLineItem sfdcOLI = foundOLIsByGUID.get( aRequestOLI.Guid );
                            for( Schema.FieldSetMember aField : Schema.SObjectType.OpportunityLineItem.FieldSets.DST_Fields_for_Delete.getFields() )
                            {
                                sfdcOLI.put( aField.getFieldPath(), null );
                            }
                        }
                    }
                }
            }
        }

        System.Savepoint sp = Database.setSavepoint();
        try
        {
            update foundOpportunitiesBySFDCId.values();
        }
        catch( System.DmlException ex )
        {
            for( Integer index = 0; index < ex.getNumDml(); index++ )
            {
                Response_Opportunity responseOppty = responseOpportunityBySFDCId.get( foundOpportunitiesBySFDCId.values()[ex.getDmlIndex(index)].Id );
                responseOppty.addError( 'CANNOT_UPDATE_OPPORTUNITY', ex.getDmlMessage(index) );
            }
        }

        try
        {
            update foundOLIsByGUID.values();
        }
        catch( System.DmlException ex )
        {
            Database.rollback(sp);
            for( Integer index = 0; index < ex.getNumDml(); index++ )
            {
                Response_Opportunity responseOppty = responseOpportunityBySFDCId.get( foundOLIsByGUID.values()[ex.getDmlIndex(index)].OpportunityId );
                responseOppty.addError( 'CANNOT_UPDATE_OPPORTUNITY_ITEM', ex.getDmlMessage(index) );
                
            }
        }
        RestContext.response.responseBody = Blob.valueOf( JSON.serialize(theResponse) );
        RestContext.response.addHeader( 'Content-Type', 'application/json' );
    }
    
    
    public static void createPriceItems(List<Product2> products, OpportunityUpdateResponse theResponse, OpportunityUpdateRequest theRequest, List<Integration_Error__c> errors)
    {
        
        List<Apttus_Config2__PriceList__c>  priceList = [SELECT Id FROM Apttus_Config2__PriceList__c];
        List<Apttus_Config2__PriceListItem__c> priceListItems = new List<Apttus_Config2__PriceListItem__c>();
        
        for(Apttus_Config2__PriceList__c aPriceList: priceList)
        {
            for(Product2 aProduct: products)
            {
                Apttus_Config2__PriceListItem__c aPriceListItem = new Apttus_Config2__PriceListItem__c();
                aPriceListItem.Apttus_Config2__ProductId__c = aProduct.id;
                aPriceListItem.Apttus_Config2__PriceListId__c = aPriceList.id;
                aPriceListItem.Apttus_Config2__ListPrice__c = 0; 
                aPriceListItem.Apttus_Config2__Active__c = TRUE; 
                priceListItems.add(aPriceListItem);
            }
        }
        
        try
        {
        	insert priceListItems;	
        }
        catch(System.DmlException ex)
        {
        	for( Integer errorIndex = 0; errorIndex < ex.getNumDml(); errorIndex++ )
            {
                theResponse.addError( 'CANNOT_CREATE_PRICE_LIST_ITEM_FOR_THIS_PRODUCT', products[errorIndex].Name + ': ' + ex.getDmlMessage(errorIndex) );
                errors.add(createErrorLog( 'Price List Item Creation Error ['+ex.getDmlMessage(errorIndex)+']', 'Price List Item', theRequest ));
            }
        }
    }
    
    
    
    public static void createOpportunityLineItemProducts(Map<String, Map<Id, PricebookEntry>> foundProductsByProductCode,
                                                         Opportunity sfdcOpportunity, OpportunityLineItem theOLI, Request_OpportunityItem anItem, 
                                                         Map<String, Product2> productsToCreate, List<PricebookEntry> pricebookEntriesToCreate){
         
        
        // see if the product already exists
        if( !foundProductsByProductCode.containsKey( anItem.ModelNumber ) )
        {
            Product2 newProduct = new Product2();
            newProduct.Name = anItem.ModelNumber;
            newProduct.ProductCode = anItem.ModelNumber;
            newProduct.Description = anItem.ModelDescription;
            newProduct.IsActive = TRUE;
            productsToCreate.put( anItem.ModelNumber, newProduct );
            foundProductsByProductCode.put( anItem.ModelNumber, new Map<Id, PricebookEntry>() );
        }
        
        Map<Id, PricebookEntry> pricebookEntriesForProduct = foundProductsByProductCode.get( anItem.ModelNumber );
        
        if( !pricebookEntriesForProduct.containsKey( sfdcOpportunity.Pricebook2Id ) )
        {
            PricebookEntry newEntry = new PricebookEntry();
            newEntry.Product2 = productsToCreate.get( anItem.ModelNumber );
            newEntry.Pricebook2Id = sfdcOpportunity.Pricebook2Id;
            newEntry.UnitPrice = 0; 
            newEntry.IsActive = TRUE; 
            pricebookEntriesToCreate.add( newEntry );
            pricebookEntriesForProduct.put( sfdcOpportunity.Pricebook2Id, newEntry );

            if( sfdcOpportunity.Pricebook2Id != DEFAULT_PRICEBOOK_ID )
            {
                PricebookEntry defaultEntry = newEntry.clone( false, true );
                defaultEntry.Pricebook2Id = DEFAULT_PRICEBOOK_ID;
                pricebookEntriesToCreate.add( defaultEntry );
                pricebookEntriesForProduct.put( DEFAULT_PRICEBOOK_ID, defaultEntry );
                
                foundProductsByProductCode.get( anItem.ModelNumber).put(sfdcOpportunity.Pricebook2Id, defaultEntry);
            }
            foundProductsByProductCode.get( anItem.ModelNumber).put(sfdcOpportunity.Pricebook2Id, newEntry);
        }
        
        theOLI.PricebookEntry = foundProductsByProductCode.get( anItem.ModelNumber ).get( sfdcOpportunity.Pricebook2Id );
        
    }
    
    public static void mapOpportunityValues(Opportunity sfdcOpportunity, Request_Opportunity aRequestOpportunity, Response_Opportunity responseOpportunity, string source)
    {
        
        sfdcOpportunity.DT_Source__c = source;
        sfdcOpportunity.DT_Order_Status__c = aRequestOpportunity.OrderStatus;
        sfdcOpportunity.CustomerPurchaseOrderNumber__c = aRequestOpportunity.CustomerPurchaseOrderNumber;
        sfdcOpportunity.Customer_PO_Number__c  = aRequestOpportunity.CustomerPurchaseOrderNumber;
        
        if( !String.isBlank(aRequestOpportunity.PARNumber) && aRequestOpportunity.PARNumber.isNumeric() ){
            sfdcOpportunity.PAR_Number__c = Decimal.valueOf(aRequestOpportunity.PARNumber);
        }else {
            sfdcOpportunity.PAR_Number__c = null;
        }
        
        sfdcOpportunity.Is_Orderable__c = sfdcOpportunity.stageName == 'Order-Won-Crdt Release, Submittal signed';
        
        sfdcOpportunity.DST_ID__c = aRequestOpportunity.JobGuid;
        sfdcOpportunity.SO_Number__c = aRequestOpportunity.SalesOrderNumber;
        if( String.isBlank( sfdcOpportunity.Pricebook2Id ) )
        {
            sfdcOpportunity.Pricebook2Id = DEFAULT_PRICEBOOK_ID;
        }

        if( aRequestOpportunity.Addresses != NULL )
        {
            // processing address information
            for( Request_OpportunityAddress anAddress : aRequestOpportunity.Addresses )
            {
                if( ACCEPTED_ADDRESS_TYPES.contains( anAddress.AddressType ) && !String.isBlank( anAddress.Name ) )
                {
                    
                    try
                    {
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Contact__c', anAddress.Contact );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_ID__c', anAddress.AddressId );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Line_1__c', anAddress.AddressLine1 );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Line_2__c', anAddress.AddressLine2 );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Line_3__c', anAddress.AddressLine3 );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Line_4__c', anAddress.AddressLine4 );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Name__c', anAddress.Name );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Phone__c', anAddress.Phone );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Special_Delivery_Comments__c', anAddress.SpecialDeliveryComments );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Address_Validated__c', anAddress.Validated );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_City__c', anAddress.City );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Contact_Email_Address__c', anAddress.EmailAddress );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Country__c', anAddress.Country );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_County__c', anAddress.County );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Fax__c', anAddress.Fax );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Hours_Before__c', anAddress.HoursBefore );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_Postal_Code__c', anAddress.PostalCode );
                        sfdcOpportunity.put( 'DT_' + anAddress.AddressType + '_State__c', anAddress.State );
                    }
                    catch( System.SObjectException ex )
                    {
                        responseOpportunity.addError( 'INVALID_ADDRESS_FIELD', 'There was an error populating an Address. Please contact your administrator. (' + ex.getMessage() + ')' );
                    }
                } /*else {
                    // not a valid address type 
                    responseOpportunity.addError( 'INVALID_ADDRESS_FIELD', ' The address type:'+anAddress.AddressType+' is not valid, expected values: '+ACCEPTED_ADDRESS_TYPES );
                }*/
            }
        }

        if( aRequestOpportunity.SalesPeople != NULL )
        {
            for( Request_OpportunitySalesPerson aSalesPerson : aRequestOpportunity.SalesPeople )
            {
                if( aSalesPerson.Type == 'Inside' )
                {
                    sfdcOpportunity.DT_IS_First_Name__c = aSalesPerson.FirstName;
                    sfdcOpportunity.DT_IS_Last_Name__c = aSalesPerson.LastName;
                    sfdcOpportunity.DT_IS_ID__c = aSalesPerson.Id;
                }
                else if( aSalesPerson.Type == 'Outside' )
                {
                    sfdcOpportunity.DT_OSP_First_Name__c = aSalesPerson.FirstName;
                    sfdcOpportunity.DT_OSP_Last_Name__c = aSalesPerson.LastName;
                    sfdcOpportunity.DT_OSP_ID__c = aSalesPerson.Id;
                }
            }
        }
    }
    
    public static void mapOpportunityLineItemValues (OpportunityLineItem theOLI, Request_OpportunityItem anItem, OpportunityUpdateRequest theRequest){
        // both sources mapped here but lets handle the differences
        if( theOLI.DT_Item_Status__c != anItem.ItemStatus && anItem.ItemStatus == 'Shipped' ){
            // status just changed to ship
            theOLI.Actual_Ship_Date__c = Date.today();
        }
       
        if( theRequest.Source == OPS_SOURCE && (anItem.ItemStatus == 'Shipped' || anItem.ItemStatus == 'Cancelled' )){
            theOLI.DT_Item_Status__c = anItem.ItemStatus;
            if(anItem.ItemStatus ==  'Cancelled')
                theOLI.Is_Cancelled__c = true;
           // dont change any fields the oli has been marked shipped or cancelled
           return;
       }
       
        theOLI.DT_App_Key__c = anItem.AppKey;
        theOLI.DT_Format_Number__c = anItem.FormatNumber;
        theOLI.Item_Number__c = anItem.ItemNumber;
        theOLI.DT_PCL__c = anItem.PCL;
        theOLI.Multiplier_PAR__c = anItem.ActualMultiplier;
        theOLI.IsAlternate__c = anItem.BaseBidOrAlternate == 1 ? TRUE : FALSE;
        theOLI.Is_Priced__c = anItem.IsPriced;
        theOLI.Is_Stock__c = anItem.IsStock;
        theOLI.Is_Quick_Ship__c = anItem.IsQuickShip;
        theOLI.Is_Not_Found__c = anItem.IsNotFoundItem;
        theOLI.Is_Outside_Vendor__c = anItem.IsOutsideVendorItem;
        
        if(anItem.RequestedShipDate != null){
            Date requestedShipDate = convertStringToDate(anItem.RequestedShipDate);
            theOLI.Requested_Ship_Date__c = requestedShipDate;
        }else {
            theOLI.Requested_Ship_Date__c = null;
        }

        theOLI.Quantity = anItem.Quantity;
        theOLI.TAG__c = anItem.BaseTag;
        theOLI.DT_Item_Status__c = anItem.ItemStatus;
        theOLI.Custom_Description__c = anItem.ModelDescription;
        theOLI.Discount__c = anItem.QuantityDiscountFactor;
        theOLI.NetPrice__c = anItem.NetPrice;
        theOLI.List_Price__c = anItem.ListPrice; 
        theOLI.UnitPrice = theOLI.List_Price__c * theOLI.Multiplier_PAR__c; 
    }
    
    public static Date convertStringToDate(String dateString){
        // date format recieved 7/30/2015 12:00:00 AM
        date returnDate;
        if(dateString != null){
            dateString = dateString.trim();
            List<String> dateAndTime = dateString.split(' ', 2);
            //drop time to convert the date time string to a date format of mm/dd/yyyy
            if(dateAndTime != null)
                returnDate = date.parse(dateAndTime[0]);
        }
        return returnDate; 
    }
    
    public static string getOpportunityLineItemProductCode(Map<Id, PricebookEntry> pricebookEntryMap, OpportunityLineItem theOLI ){
        String oldModelNumber = '';
        if(pricebookEntryMap.containsKey(theOLI.pricebookentryid)){
            PricebookEntry pbe = pricebookEntryMap.get(theOLI.pricebookentryid);
            if(pbe != null && pbe.product2 != null){
                oldModelNumber = pbe.product2.ProductCode;
            }
        }
        return oldModelNumber;
    }
    
    public static Request_OpportunityItem mapAccessoryToOpportunityLineItem(Request_OpportunityAccessory accessory, Request_OpportunityItem parentOli){
        Request_OpportunityItem oli = new Request_OpportunityItem();
        oli.ParentGuid= parentOli.parentGuid;
        oli.guid = accessory.guid;
        oli.modelNumber = accessory.partNumber;
        oli.IsNotFoundItem = false;
        oli.itemNumber = accessory.itemNumber;
        oli.modelDescription = accessory.description;
        oli.Quantity = accessory.Quantity;
        oli.ListPrice = 0.00;//accessory.ListPrice;
        oli.ActualMultiplier = parentOli.ActualMultiplier;
        oli.IsOutsideVendorItem = false;
        oli.IsPriced =  parentOli.isPriced;
        oli.IsStock = parentOli.IsStock;
        oli.IsQuickShip = parentOli.IsQuickShip;
        
        
        return oli;
    }
    
    /* Request schemas */
    public class OpportunityUpdateRequest
    {
        public List<Request_Opportunity> Opportunities;
        public String Source;
    }

    public class Request_Opportunity
    {
        public List<Request_OpportunityAddress> Addresses;
        public List<Request_OpportunityItem> Items;
        public String CustomerPurchaseOrderNumber;
        public String JobGuid;
        public String JobName;
        public String OpportunityNumber;
        public String OrderDate;
        public String OrderStatus;
        public String OriginalJobGuid;
        public String PARNumber;
        public String RepOfficeName;
        public String RepOfficeNumber;
        public Integer SalesOrderNumber;
        public List<Request_OpportunitySalesPerson> SalesPeople;
        public String SFDCID;
    }

    public class Request_OpportunityAddress
    {
        public String AddressType;
        public Integer AddressId;
        public String AddressLine1;
        public String AddressLine2;
        public String AddressLine3;
        public String AddressLine4;
        public String City;
        public String Contact;
        public String Country;
        public String CountryISO;
        public String County;
        public String Fax;
        public String Name;
        public String EmailAddress;
        public String Phone;
        public String PostalCode;
        public String State;
        public String StateProvinceISO;
        public Boolean Validated;
        public Integer HoursBefore;
        public String SpecialDeliveryComments;
        public String SalesForceAddressId;
    }

    public class Request_OpportunityItem
    {
        public String SFDCID;
        public String Guid;
        public String ParentGuid;
        public String AppKey;
        public String FormatNumber;
        public String ItemNumber;
        public String BaseTag;
        public String ModelNumber;
        public String ModelDescription;
        public String PCL;
        public Double ListPrice;
        public Integer Quantity;
        public Double ActualMultiplier;
        public Double QuantityDiscountFactor;
        public Double NetPrice;
        public Integer BaseBidOrAlternate;
        public Boolean IsPriced;
        public Boolean IsStock;
        public Boolean IsQuickShip;
        public Boolean IsNotFoundItem;
        public Boolean IsOutsideVendorItem;
        public Boolean IsAlternate;
        public String RequestedShipDate;
        public String ItemStatus;
        public List<Request_OpportunityCodeItem> CodeItems;
        public List<Request_OpportunityAccessory> Accessories;
        public List<Request_OpportunityProperty> Properties;
        public List<Request_OpportunityComponent> Components;
    }

    public class Request_OpportunityCodeItem
    {
        public Integer Item;
        public String Description;
        public String Value;
        public String ValueDescription;
        public Double ListPrice;
        public Boolean IsSpecial;
        public String SpecialText;
    }

    public class Request_OpportunityAccessory
    {
        public String Guid;
        public String SFDCID;
        public String ItemNumber;
        public Boolean IsCancelled;
        public String Description;
        public String Extend;
        public Double ListPrice;
        public String PartNumber;
        public Integer Quantity;
    }

    public class Request_OpportunityProperty
    {
        public String Name;
        public String Value;
        public String Description;
    }

    public class Request_OpportunityComponent
    {
        public Integer Id;
        public Integer Type;
        public List<Request_OpportunityComponentProperty> Properties;
    }

    public class Request_OpportunityComponentProperty
    {
        public String Name;
        public String Value;
        public String Description;
    }

    public class Request_OpportunitySalesPerson
    {
        public String FirstName;
        public String LastName;
        public String Id;
        public String Type;
    }

    /* Response schemas */
    global class OpportunityUpdateResponse
    {
        public List<Response_Opportunity> Opportunities;
        public List<Response_Error> Errors;

        public OpportunityUpdateResponse()
        {
            this.Opportunities = new List<Response_Opportunity>();
            this.Errors = new List<Response_Error>();
        }

        public void addError( String errorCode, String errorMessage )
        {
            Response_Error newError = new Response_Error();
            newError.ErrorCode = errorCode;
            newError.ErrorMessage = errorMessage;
            this.Errors.add( newError );
        }
    }

    public class Response_Opportunity
    {
        public String JobGuid;
        public String SFDCID;
        public List<Response_Error> Errors;
        public List<Response_Item> Items;

        public Response_Opportunity( String jobGUID, String SFDCID )
        {
            this.JobGuid = jobGUID;
            this.SFDCID = SFDCID;
            this.Errors = new List<Response_Error>();
            this.Items = new List<Response_Item>();
            
        }
        
        public void addItem(String guid, String sfid)
        {
        	Response_Item newItem = new Response_Item();
        	newItem.Guid = guid;
        	newItem.SFDCID = sfid;
        	this.Items.add(newItem);
        }

        public void addError( String errorCode, String errorMessage )
        {
            Response_Error newError = new Response_Error();
            newError.ErrorCode = errorCode;
            newError.ErrorMessage = errorMessage;
            this.Errors.add( newError );
        }
    }
    
    public class Response_Item
    {
    	public String Guid;
    	public String SFDCID;
    }

    public class Response_Error
    {
        public String ErrorMessage;
        public String ErrorCode;
    }
}