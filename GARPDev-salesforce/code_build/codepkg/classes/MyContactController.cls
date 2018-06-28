public class MyContactController {
    public Contact contact {get; private set;}

    public MyContactController() {
        User user = [select ContactId from User where id = :UserInfo.getUserId()];
        Id id = user.ContactId;
        contact = (id == null) ? new Contact() :
        [SELECT id,email,title,firstname,lastname,donotcall,phone,Membership_Type__c FROM contact WHERE id = :id];
    }
}