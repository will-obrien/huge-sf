global with sharing class SpreadsheetController{

    public SpreadsheetController(){

    }
    

    public String chosenFiscalYear{get; set;}
    public List<SelectOption> getFiscalYear(){
        List<SelectOption> options = new List<SelectOption>();    
        Schema.DescribeFieldResult fieldResult = DemandPlanning__c.FiscalYear__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        chosenFiscalYear = ple[0].getValue();
        return options;
    }
    
    public String chosenProductType{get; set;}
    public List<SelectOption> getProductType(){
        List<SelectOption> options = new List<SelectOption>();    
        Schema.DescribeFieldResult fieldResult = DemandPlanning__c.ProductType__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }

    @RemoteAction
    global static void saveRecords(DemandPlanning__c[] demandPlanList){
        upsert demandPlanList;
    }
    
    @RemoteAction
    global static void deleteRecords(DemandPlanning__c[] demandPlanList){
        delete demandPlanList;
    }    
    
    @RemoteAction
    global static List<DemandPlanning__c> queryDemandPlan(String year, String pt){
        return [select Id, Name, Plan10__c, Diff10__c, Result10__c, Plan11__c, Diff11__c, Result11__c,
            Plan12__c, Diff12__c, Result12__c, Plan1__c, Diff1__c, Result1__c, Plan2__c, Diff2__c, Result2__c,
            Plan3__c, Diff3__c, Result3__c, Plan4__c, Diff4__c, Result4__c, Plan5__c, Diff5__c, Result5__c,
            Plan6__c, Diff6__c, Result6__c, Plan7__c, Diff7__c, Result7__c, Plan8__c, Diff8__c, Result8__c,
            Plan9__c, Diff9__c, Result9__c, DPAccountName__c, DPAccountName__r.Name, FiscalYear__c,
            ProductType__c        
            from DemandPlanning__c where
            FiscalYear__c = :year and ProductType__c = :pt order by DPAccountName__c];
    }    

    @RemoteAction
    global static List<Account> queryAccountList(){
        return [select Id, Name from Account order by Name];
    }    


}