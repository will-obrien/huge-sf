/* Application: Drag and Drop Functionality
 * Client: Cognizant
 * Developed by : Subrat Poudyal
*/
public class DragAndDropTaskAssgnController {
 
    public List<Contact> con{get;set;}
    public List<Contact> unassigncon{get;set;}
    
    public  List<Task> tas{get;set;}
    Map<ID,ID> mTask = new Map<ID,ID>();
    public DragAndDropTaskAssgnController(){
        
      tas= [select id,whoid from task where who.type ='contact'];   
        for(task t:tas){   mTask.put(t.whoid, t.id);
                       }
   con = [select name from contact where id=:mTask.keySet()];   
   unassigncon= [select id,name from contact where id!=:mTask.keySet()];  
       
    }

    @Remoteaction    
    public static String updateContact (String contents){     
    String sText =contents.trim();
        system.debug('--sText>'+sText);
        List<task> tas=[select id  from task  where who.name =:sText];
         system.debug('[task'+tas);
        try{
       Database.DeleteResult[] results = Database.delete(tas,true);
    if(!results.isEmpty()){
        for (Database.DeleteResult result : results) {
            if (!result.isSuccess()) {
                Database.Error[] errs = result.getErrors();
                for(Database.Error err : errs){
                     System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                       return err.getMessage();
                }
                   
            }
           
                
            }
        }
    
        }catch(Exception e){
             System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
             return e.getMessage();
        }
        
      
        return 'Task has been unassigned from '+contents;
    }
    
    @Remoteaction    
    public static String  AddTask (String contents){
    String sText =contents.trim();
        system.debug('--sText>'+sText);
       List<contact> contacList=[select id  from contact  where name =:sText ];
        List<Task> tlist = new List<task>();
        for(contact contac:contacList) {
          Task T = new Task();
         T.Type = 'Email';
            T.Subject='task assigned from Drag and Drop ';
         T.Description = 'task created from drag and drop'; //string
        T.WhoId = contac.id; //user id
            tlist.add(T);
        }
        try {
    Database.SaveResult[] results = Database.insert(tlist,true);
    if(!results.isEmpty()){
        for (Database.SaveResult result : results) {
            if (!result.isSuccess()) {
                Database.Error[] errs = result.getErrors();
                for(Database.Error err : errs){
                     System.debug(err.getStatusCode() + ' - ' + err.getMessage());
                       return err.getMessage();
                }
                   
            }
           
                
            }
        }
    

} catch (Exception e) {
    System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
return e.getMessage();
}
    return 'Task Assigned to'+ contents;
    }
    
   
    }