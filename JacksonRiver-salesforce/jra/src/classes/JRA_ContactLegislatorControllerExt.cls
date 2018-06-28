public with sharing class JRA_ContactLegislatorControllerExt {
/*
PNC June 2015
To enable update of single contact via a button on Contact record
Client will need to add button to Contact object that invokes the VF page using this controller
*/
private final Contact contact;

public JRA_ContactLegislatorControllerExt (ApexPages.StandardController stdController) {
    contact = (Contact)stdController.getRecord();
}

public PageReference UpdateLegislators() {
JRA_ContactUpdateService JRACUS = new JRA_ContactUpdateService();
JRACUS.executecallout(new List<Id> {contact.Id});
if (JRACUS.executeupdate() == TRUE) {
    return new PageReference('/' + contact.Id);
}

else {
    return null;
}

}
}