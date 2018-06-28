public class NewCaseListController {

  
public List<Case> getNewCases(){    
    
    List<Case> results =[SELECT CaseNumber FROM case WHERE status='New'];
    
    return results;
    }
}