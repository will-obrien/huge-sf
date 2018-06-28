public class NewCaseListController {
    
    List<Case> newcase = new List<Case>();
    
    public List<Case> getNewCases(){
        
        newcase = [Select Id,CaseNumber from case where status='New'];

        return newcase;
        
    }

}