public class UpdateAccountTriggerUtils
{
    public static boolean bPKIDRecusrive = false;
    public static boolean bExpirationRecusrive = false;

    public static void UpdatePKID(Map<Id,Contact> mapContacts )
    {

        bPKIDRecusrive = true;
        List<Account> lstAccounts = new List<Account>();
        for(Account acc : [select id,PK_PID__c,GARP_ID__c,Member_Email__c,Membership_Expiration_date__c,Member_Last_Name__c,Member_First_Name__c,Member_Wiley__c,Member_Type__c  from Account where id in: mapContacts.keySet()])
        {
            Contact cn = mapContacts.get(acc.Id);
            Boolean AddToList=false;
            if(cn != null && cn.GARP_Member_ID__c != null && (acc.GARP_ID__c != cn.GARP_Member_ID__c))
            {
                system.debug('UpdatePKID:' + cn.GARP_Member_ID__c);
                acc.GARP_ID__c = cn.GARP_Member_ID__c;
                AddToList = True;
            }            
            if(cn != null && cn.Email != null && (acc.Member_Email__c != cn.Email))
            {
                system.debug('Update Email:' + cn.Email);
                acc.Member_Email__c = cn.Email;
                AddToList = True;
            }            
            if(cn != null && cn.FirstName != null && (acc.Member_First_Name__c != cn.FirstName))
            {
                system.debug('Update FirstName:' + cn.FirstName);
                acc.Member_First_Name__c = cn.FirstName;
                AddToList = True;
            }            
            if(cn != null && cn.LastName != null && (acc.Member_Last_Name__c != cn.LastName))
            {
                system.debug('Update LastName:' + cn.LastName);
                acc.Member_Last_Name__c = cn.LastName;
                AddToList = True;
            }            
            if(cn != null && cn.KPI_J_Wiley__c != null && (acc.Member_Wiley__c != cn.KPI_J_Wiley__c))
            {
                system.debug('Update Member_Wiley__c:' + cn.KPI_J_Wiley__c);
                acc.Member_Wiley__c = cn.KPI_J_Wiley__c;
                AddToList = True;
            }            
            if(cn != null && cn.Membership_Type__c != null && (acc.Member_Type__c != cn.Membership_Type__c))
            {
                system.debug('Update Membership_Type__c:' + cn.Membership_Type__c);
                acc.Member_Type__c = cn.Membership_Type__c;
                AddToList = True;
            }            
            
            
            if(AddToList==True)
                lstAccounts.add(acc);
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
            Contact cn = mapexpirationdate.get(acc.Id);
            if(cn != null)
            {
                system.debug('UpdateExpirationDate:' + cn.KPI_Membership_Expiration_Date__c);
                acc.Membership_Expiration_date__c= cn.KPI_Membership_Expiration_Date__c;
                lstAccounts.add(acc);
            }
        }
        
        if(!lstAccounts.isEmpty())
            update lstAccounts;
    }

}