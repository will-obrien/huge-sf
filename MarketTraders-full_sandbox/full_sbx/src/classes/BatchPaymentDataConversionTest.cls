@IsTest(SeeAllData=true)
private class BatchPaymentDataConversionTest{

    static testMethod void myTestMethod() {
       //generateTestData();
       Test.startTest();
       BatchPaymentDataConversion  batchObj = new BatchPaymentDataConversion ();
       List<Opportunity> opp1 = [SELECT ID from Opportunity where id = '0066000001ktoOs' LIMIT 1];
       List<Opportunity> opp2 = [SELECT ID from Opportunity where id = '0066000001ktoOs' LIMIT 1];
       Set<Id> records = new Set<Id>();
       //records.add(opp1[0].id); 
       if(opp1 != null){
           if(opp1.size() > 4){
               records.add(opp1[4].id);
           }
           if(opp1.size() > 3){
               records.add(opp1[3].id);
           }
    
           if(opp1.size() > 2){
               records.add(opp1[2].id);
           }
           
           if(opp1.size() > 1){
               records.add(opp1[1].id);
           }
    
           if(opp1.size() > 0){
               records.add(opp1[0].id);
           }
        }
       if(opp2 != null){    
           
           if(opp2.size() > 4){
               records.add(opp2[4].id);
           }
           if(opp2.size() > 3){
               records.add(opp2[3].id);
           }
    
           if(opp2.size() > 2){
               records.add(opp2[2].id);
           }
           
           if(opp2.size() > 1){
               records.add(opp2[1].id);
           }
    
           if(opp2.size() > 0){
               records.add(opp2[0].id);
           }
        }    
    
       
     batchObj.query = 'Select Id, CloseDate, Sub_Stage__c, Sale_Down_Payment_1_of_4_Date__c,' +
      'Sale_Invoice_Qty_Payments_After_Down__c, Amount from Opportunity '+
      //' where Id = \'0067A000002C9nZQAS\' '; 
      //'where Sale_Invoice_Qty_Payments_After_Down__c <> null LIMIT 10';
      'where id in :records';
    // TODO: Update query to filter out closed won opps after the date 
       Database.executeBatch(new BatchPaymentDataConversion() );
       //batchObj.execute();
       Test.stopTest();
    }    
}