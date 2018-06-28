/*
UpdateUserEmail

Created by: Mark Maslow
Created on: May, 2015

This class is called by trigger ContactAfterUpdateHandler.

For each User record, it updates the Email field on the User record to be the same as the Contact record.
It also attempts to change the Username field to match the Email field.
Since Username *must* be unique across all SFDC instances, there is logic to append a digit to force uniqueness, 
if necessary.

After User record is updated, an email is sent to notify the User of the update.

7/29/2015 Maslow - Use OrgWideEmailAddress Id to get reply-to correct
*/
public with sharing class UpdateUserEmail implements Queueable {
    static OrgWideEmailAddress owe;
    static EmailTemplate template;
    static {
        template = [Select Id, Subject, Body from EmailTemplate where DeveloperName = 'Changed_User_Name'];
		owe = [select Id from OrgWideEmailAddress where Address='membership.services@sierraclub.org' LIMIT 1];
    }
    private List<User> usersToUpdate;

    public UpdateUserEmail(List<User> userList) {
        this.usersToUpdate = userList;
    }
    public void execute(QueueableContext context) {
        List<User> retryList = new List<User>();
        List<Id> usersToNotify = new List<Id>();
        
        while(usersToUpdate.size() > 0) { 
            Integer resultsPos = 0;
            Database.SaveResult[] results;
            
            if(Test.isRunningTest()) {
                User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
                System.runAs ( thisUser ) {
                    results = Database.update(usersToUpdate, false);
                }
            }
            else {
                results = Database.update(usersToUpdate, false);
            }
            for(Database.SaveResult rslt : results) {
                if(rslt.isSuccess()) {
                    User usr = usersToUpdate.get(resultsPos);
                    if(usr != null) {
                        usersToNotify.add(usr.Id);
                    }
                }
                else {
                    for(Database.Error err : rslt.getErrors()) {
                        if(err.getStatusCode() == StatusCode.DUPLICATE_USERNAME) {
                            User usr = usersToUpdate.get(resultsPos);
                            usr.Username = changeUserName(usr.Username);
                            retryList.add(usr);
                        }
                        else {
                            System.debug('Error in UpdateUserEmail.execute:' + err.getMessage());
                        }
                    }
                }
                resultsPos ++;
            }
            if(retryList.size() > 0) {
                usersToUpdate.clear();
                usersToUpdate.addAll(retryList);
                retryList.clear();
            }
            else {
                usersToUpdate.clear();
            }
        }
        NotifyUsers(usersToNotify);
    }
    private String changeUserName(String name) {
        Integer pos = name.indexOf('@');
        String nameBeg = name.substring(0, pos);
        String nameEnd = name.substring(pos + 1);
        String lastChar = nameBeg.substring(nameBeg.length() - 1, nameBeg.length());
        Integer num = 1;
        if(lastChar.isNumeric()) {
            num = Integer.valueOf(lastChar) + 1;
            if(num > 9) {
                num = 0;
            }
            nameBeg = nameBeg.substring(0, nameBeg.length() - 1) + String.valueOf(num);
        }
        else {
            nameBeg = nameBeg + String.valueOf(num);
        }
        return nameBeg + '@' + nameEnd;
    }
    private void notifyUsers(List<Id> userIdList) {
        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        List<User> userList = new List<User>([
            select Id, Email, ContactId, Username, FirstName, LastName from User where Id in :userIdList
        ]);
        for(User usr : userList) {  
            String body = template.Body;
            body = body.replace('{!User.Email}', usr.Email);
            body = body.replace('{!User.FirstName}', usr.FirstName);
            body = body.replace('{!User.LastName}', usr.LastName);
            body = body.replace('{!LoginMessage}', createLoginMessage(usr));
            Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
            m.setSaveAsActivity(false);
            m.setToaddresses(new String[] {usr.Email});
            m.setSubject(template.Subject);
            m.setPlainTextBody(body);
            m.setReplyTo('membership.services@sierraclub.org');
            m.setOrgWideEmailAddressId(owe.Id);
            //m.setSenderDisplayName('Sierra Club Member Services');
            msgList.add(m);
        }

        Messaging.sendEmail(msgList);
    }
    private String createLoginMessage(User usr) {
        if(usr.Email.toLowerCase() == usr.Username.toLowerCase()) {
            return 'Please use that email address to log into AddUP.';
        }
        else {
            return 'Because someone else has registered that email address, ' +
                'please use the following to log into AddUP:  ' + usr.Username;
        }
    }
}