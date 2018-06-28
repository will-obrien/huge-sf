/**This class create schedule job that
 * Change old name of the acccount Kaalbay Transport to new Primetransport ltd
 * in contacts
 * 
 * @author Julia Pulova
 * */
public class ScheduleNameCheck implements Schedulable{
    
    //Class runs every day at 11 PM.
    public static String CRON_EXP = '0 0 22 * * ?';

    public void execute (SchedulableContext ctx){
    
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                         From CronTrigger
                         WHERE id = :ctx.getTriggerId()];
        
        List<Contact> contacts = new List<Contact>([SELECT id, name, Account.name
                                                   From Contact
                                                   WHERE Account.name = 'Kaalbay Transport']);
        
        
        for (Contact cont : contacts)
        {
            cont.account.name = 'Primetransport ltd';
        }
        update contacts;
    }    
}