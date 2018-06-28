@isTest
private class SpreadsheetTestClass{

    static testMethod void testSpreadsheetController(){
        SpreadsheetController controller = new SpreadsheetController();
        createTestData();
        
        controller.getFiscalYear();
        controller.chosenFiscalYear='2013';
        
        controller.getProductType();
        controller.chosenProductType='Sheet';
                
        List<DemandPlanning__c> dpList = SpreadsheetController.queryDemandPlan(controller.chosenFiscalYear, controller.chosenProductType);
        System.assertEquals(1, dpList.size());
        
        List<Account> accList = SpreadsheetController.queryAccountList();
        System.assertEquals(1, accList.size());

        Account acc = accList.get(0);
        
        dpList.add(new DemandPlanning__c(
            DPAccountName__c = acc.Id,
            FiscalYear__c = '2013',
            ProductType__c = 'Sheet'
        ));
        SpreadsheetController.saveRecords(dpList);
        dpList = SpreadsheetController.queryDemandPlan(controller.chosenFiscalYear, controller.chosenProductType);
        System.assertEquals(2, dpList.size());

        List<DemandPlanning__c> dpDeleteList = dpList.clone();
        dpDeleteList.remove(0);
        SpreadsheetController.deleteRecords(dpDeleteList);
        
        dpList = SpreadsheetController.queryDemandPlan(controller.chosenFiscalYear, controller.chosenProductType);
        System.assertEquals(1, dpList.size());

    }
    
    private static void createTestData(){
        Account acc = new Account(
            Name ='test account'
        );
        upsert acc;
    
        DemandPlanning__c plan = new DemandPlanning__c(
            DPAccountName__c = acc.Id,
            FiscalYear__c = '2013',
            ProductType__c = 'Sheet'
        );
        upsert plan;
    }


}