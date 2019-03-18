public Class NewCaseListController{
    public NewCaseListController(){
    
    }
    Public list<case> getNewCases(){
         List<case> Caselist = [SELECT Id, CaseNumber FROM Case where status='new'];
        return Caselist;
    }
}