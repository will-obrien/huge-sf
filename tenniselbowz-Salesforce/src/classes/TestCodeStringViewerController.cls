/*********************************************************************************
 Author       :   Nathan Shinn
 Created Date :   February 13, 2014
 Description  :   Test class for CodeStringViewerController
*********************************************************************************/
@isTest
private class TestCodeStringViewerController {
	
	static testmethod void runTest()
	{	
	    
	    Account a = new Account(Name = 'Test');
		insert a;
		
		Asset asset = new Asset(Name = 'test',
                           AccountId = a.Id,
                           SerialNumber='123Test',
                           Code_String_Breakdown__c = '[{"code_sequence":"1","code_value":"W","code_description":"Product Category; WATER SOURCE HEAT PUMP"},{"code_sequence":"2","code_value":"CCH","code_description":"Unit Type; CEILING MTD./STANDARD RANGE"},{"code_sequence":"3","code_value":"2","code_description":"Design series; 2ND DESIGN"},{"code_sequence":"4","code_value":"030","code_description":"Unit Size; 30,000 BTUH NOMINAL COOLING"},{"code_sequence":"5","code_value":"E","code_description":"Controls; DDC LESS BOARD"},{"code_sequence":"6","code_value":"K","code_description":"Voltage; 460/60/3"},{"code_sequence":"7","code_value":"Y","code_description":"Cabinet Height; NONE"},{"code_sequence":"8","code_value":"R","code_description":"Return Air; RIGHT HAND RETURN AIR"},{"code_sequence":"9","code_value":"S","code_description":"Discharge Air; STRAIGHT DISCHARGE"},{"code_sequence":"10","code_value":"01","code_description":"Blower Motor; STANDARD"},{"code_sequence":"11","code_value":"YY","code_description":"Disch. Grille/Cab. Type; NONE"},{"code_sequence":"12","code_value":"A","code_description":"Construction Type; STANDARD"},{"code_sequence":"13","code_value":"C","code_description":"Water-Refrig Ht Exch Constr; Copper Inner/Steel Outer Tubes"},{"code_sequence":"14","code_value":"Y","code_description":"Heating Options; NONE"},{"code_sequence":"15","code_value":"YY","code_description":"Dehumidification; NONE"},{"code_sequence":"16","code_value":"Y","code_description":"Piping Hand; NONE"},{"code_sequence":"17","code_value":"YYY","code_description":"Thermostat Control; NONE"},{"code_sequence":"18","code_value":"YYY","code_description":"Night Control; NONE"},{"code_sequence":"19","code_value":"YYY","code_description":"Desuperheater; NONE"},{"code_sequence":"20","code_value":"A","code_description":"Refrigerant; 410A"},{"code_sequence":"21","code_value":"Y","code_description":"Power Connection; NONE"},{"code_sequence":"22","code_value":"YYY","code_description":"Cabinet Electrical; NONE"},{"code_sequence":"23","code_value":"Y","code_description":"Water Flow Control; NONE"},{"code_sequence":"24","code_value":"Y","code_description":"Color; NONE"},{"code_sequence":"25","code_value":"Y","code_description":"Outside Air; NONE"},{"code_sequence":"26","code_value":"C","code_description":"Agency Listing; ETL, CETL, ARI, MEA"},{"code_sequence":"27","code_value":"1","code_description":"Packaging; STANDARD"},{"code_sequence":"28","code_value":"Y","code_description":"Ext. Warranty; NONE"},{"code_sequence":"29","code_value":"2","code_description":"Product Style; Style 2"}]'
                           );
   		insert asset;
   		
   		ApexPages.Standardcontroller ctlr = new ApexPages.Standardcontroller(asset);
   		CodeStringViewerController ctl = new CodeStringViewerController(ctlr);
   		
   		list<CodeStringViewerController.CodeStringRec> recs = ctl.getCodeStringRecs();
   		
   		System.assert(recs.size() > 0);
   		
   		CodeStringViewerController.CodeStringRec rec = new CodeStringViewerController.CodeStringRec();
   		rec.code_sequence = 'z';
        rec.code_value = 'l';
        rec.code_description = 'k';
        
        asset.Code_String_Breakdown__c = '7654&^%$';
        update asset;
        
        ctl.ast = asset;
        
        recs = ctl.getCodeStringRecs();
   		
   		
   		
	}

}