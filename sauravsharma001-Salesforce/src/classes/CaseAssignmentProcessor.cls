/* This Class is used by Trigger on Case Object to update 
 * the Case Owner according to the Case Assignment Rule.
 * Updated the code for Support ticket #00005373
 */

public class CaseAssignmentProcessor {
     
     public static void processCases(Set<Id> id) {
          List<Case> casesToUpdate = new List<Case>();
          
            for(Case tempObj : [Select id,CaseNumber from Case where id IN :id])    {                
                
                System.debug('Assignment Rule called');
                //Assignment Rule
                Database.DMLOptions dmo = new Database.DMLOptions();
                dmo.assignmentRuleHeader.useDefaultRule= true; 
                tempObj.setOptions(dmo);
                casesToUpdate.add(tempObj);     
                System.debug('Case details after Assignment Rule: ' +   tempObj.CaseNumber);               
           }
          try    {
              CaseFieldUpdate.inFutureContext = true;
              Database.upsert(casesToUpdate);
          }
          catch (DMLException ex)    {
              System.debug('Error Occured: ' + ex.getMessage());
          }    
     } 
 
}