public class SendEmail {
    Case cases;
    Service__c service;
    Booking__c booking;
    Contact conAgencyCode;
    Account account;
    List <Contact> contacts;
    public SendEmail(ApexPages.StandardController controller) {
        
        
    }
    
    public PageReference btnSendEmail(){
    
    cases = [Select Service_Number__c, Agency_Name__c, Agent_Name__c from Case WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
            System.Debug(cases);
        //for the service above get the booking
        service = [Select booking__c from Service__c where Id = : cases.Service_Number__c];
            System.Debug(service);
        booking = [Select Agent__c from booking__c where Id =: service.booking__c];
        contacts = [Select Email from contact where Id =: booking.Agent__c];
        
        
            String cc = 'p4';
            PageReference redirectURL;
            if(contacts.size() >1){
                redirectURL = new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid={!cases.Id}');
            }
            else
                redirectURL = new PageReference('/_ui/core/email/author/EmailAuthor?p2_lkid={!cases.Id}&'+cc+'='+contacts[0].Email);
            redirectURL.setRedirect(true);
            return redirectURL;
    }

}