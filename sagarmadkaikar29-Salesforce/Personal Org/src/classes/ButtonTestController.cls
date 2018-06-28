public class ButtonTestController
{
    public Boolean status{get; set;}
    
    public void buttonOperation()
    {
        Test__c testC = Test__c.getInstance('Button Status');
        
        if(testC.Status__c=='Active')
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Clicked 1st time'));
            testC.Status__c = 'Deactive';
            update testC;
            status = true;

        }
        else
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Clicked 2st time...not allowed'));

        }
       
    }
}