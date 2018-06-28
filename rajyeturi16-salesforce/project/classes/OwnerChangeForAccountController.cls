public class OwnerChangeForAccountController {
public List<User> getUserList(){
List<User> userList = new List<User>();
userList = [select id,name,Username from user];
return userList ;
}
public List<account> getAccountList(){
List<account> accountList = new List<account>();
accountList = [select id,name,Owner.FirstName from account];
return accountList;
}

public OwnerChangeForAccountController (){
//userList = [select id,name from user];
}

                              
}