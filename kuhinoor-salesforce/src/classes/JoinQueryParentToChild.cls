Public class JoinQueryParentToChild{
    Public list<Account> record{get;set;}
    public JoinQueryParentToChild(){
        record = [ Select Name,Id,(Select lastname,email from contacts) from Account];
    }
}