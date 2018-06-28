public class UpdateAccountTriggerUtils
{
    public static boolean bPKIDRecusrive = false;
    public static boolean bExpirationRecusrive = false;

    public static void UpdatePKID(Map<Id,Contact> mapContacts )
    {

        bPKIDRecusrive = true;
        List<Account> lstAccounts = new List<Account>();
        for(Account acc : [select id,PK_PID__c,GARP_ID__c,Member_Email__c,Membership_Expiration_date__c from Account where id in: mapContacts.keySet()])
        {
            Contact cn = mapContacts.get(acc.Id);
            if(cn != null && acc.GARP_ID__c == null)
            {
                acc.GARP_ID__c = mapContacts.get(acc.Id).GARP_Member_ID__c;
                lstAccounts.add(acc);
            }            
        }
        
        if(!lstAccounts.isEmpty())
            update lstAccounts;


    }

    public static void UpdateExpirationDate(Map<Id,Contact> mapexpirationdate)
    {

        bExpirationRecusrive = true;
        List<Account> lstAccounts = new List<Account>();
        for(Account acc : [select id,Membership_Expiration_date__c from Account where id in: mapexpirationdate.keySet() ])
        {
            if(mapexpirationdate .containsKey(acc.Id))
            {
                acc.Membership_Expiration_date__c= mapexpirationdate.get(acc.Id).KPI_Membership_Expiration_Date__c;
                lstAccounts.add(acc);
            }
        }
        
        if(!lstAccounts.isEmpty())
            update lstAccounts;
    }

}