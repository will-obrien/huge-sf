public class NewCaseListController {

   public List<Case> getNewCases() {
 
        List<Case> cases = [Select id,casenumber from Case where status ='New'];
        return cases;
    }

}