public with sharing class addContactsController {

    public addContactsController(ApexPages.StandardController controller) {

    }

//instance of the flow
public Flow.Interview.Adding_Contacts_from_Lead addingContactsFlow {get; set;}

public ID getAccountID(){
String accountID;
accountID = (String) addingContactsFlow.getVariableValue('AccountID');
return accountID;
}
public ID getAccountName(){
String accountName;
accountName = (String) addingContactsFlow.getVariableValue('AccountName');
return accountName;
}
public String getLeadID(){
if(addingContactsFlow==null) return'';
else return addingContactsFlow.LeadID;
}

public PageReference getFinishPage(){
PageReference p = new PageReference('/' + getLeadID());
p.setRedirect(true);
return p;
}
}