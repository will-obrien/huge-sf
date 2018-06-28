public class NewCaseListController {
    public list<Case> getNewCases(){
        list<Case>newcases=Database.query('SELECT Id,CaseNumber  FROM CASE');
        return newcases;
    }
}