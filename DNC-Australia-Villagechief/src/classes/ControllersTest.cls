@IsTest
public class ControllersTest{
    public static testmethod void testSettings(){
        SettingsController s = new SettingsController();
        s.init();
        s.cancel();
        system.assert(s.getObjects() != null);
        s.objectApiName = 'Lead';
        system.assert(s.getFields() != null);
        system.assert(s.getSchedules() != null);
        s.washNow();
        s.schedule();
        s.getIsBatchRunning();
        s.getBatchStatus();
    }
    
    public static testmethod void testRecheck(){
        Lead l = new Lead();
        l.LastName = 'l';
        l.Company = 'c';
        insert l;
        ApexPages.currentPage().getParameters().put('objectApiName', 'Lead');
        ApexPages.currentPage().getParameters().put('fieldApiName', 'Phone');
        ApexPages.currentPage().getParameters().put('recordId', l.id);
        RecheckController c = new RecheckController();
        c.init();
        system.assert(c.check() != null);
    }
    
    public void forEachTest(String[] listo){
      
      for (String a : listo){
      	String b = 'nah';
      }

    }
    
}