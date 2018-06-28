global class Datacompletionbatch8 implements Database.Batchable<SObject>
{
    //global boolean bIsTestCall = false;
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(!Test.isRunningTest())
            return Database.getQueryLocator('select id,Password__c,isactive from User where  isactive=true and contactid !=null and Password__c != null ');
        else 
            return Database.getQueryLocator('select id,Password__c from User');

     }
    
    
    global void execute(Database.BatchableContext BC, List<User> scope){
        
        List<User> lstUser = new List<User>();
        for(User obj : Scope)
        {

            try
            {
                if(obj.Password__c != null)
                    system.setPassword(obj.Id,obj.Password__c);
            }
            catch(Exception ex)
            {

                obj.Password_Issues__c = true;
                lstUser.add(obj);

            }
        }

        if(! lstUser.isEmpty())
            update lstUser;

    }
        

    global void finish(Database.BatchableContext BC){

       
    }

}