@istest
public class cardcntrlextTest {

public static testmethod void testCardCntrlExt() {

        PageReference pageRef = Page.MYOBCard;
        Test.setCurrentPage(pageRef);
//      Create test card record
        Card__c card = new Card__c(Name='Test Pty Ltd',CompanyName__c='Test Pty Ltd',IsIndividual__c=false,UID__c='MYOB unique GUID',DisplayID__c='Test',
                                  IsActive__c=true,CurrentBalance__c=0.0);
        Insert card;
        Card__c stdcontrec = [Select Id, Name, CompanyName__c, IsIndividual__c, UID__c,DisplayID__c, IsActive__c, CurrentBalance__c From Card__c Limit 1];
        ApexPages.StandardController sController = new ApexPages.StandardController(stdcontrec);

 //The ControllerExtension, initialised with the standard controller
        cardcntrlext context = new cardcntrlext(sController);
        context.option = '1';
        Address__c testaddr = context.getaddress();
        Card__c testcard = context.getcard();
        PageReference debug = context.debug();
        PageReference cancelEdit = context.cancelEdit();
        PageReference deletepage = context.deleteCard();
        PageReference savepage = context.ok();

    }
}
