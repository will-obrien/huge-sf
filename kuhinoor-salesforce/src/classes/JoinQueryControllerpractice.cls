Public class JoinQueryControllerpractice{
     public List<contact> record{get;set;}
    Public JoinQueryControllerpractice(){
        record = [ select firstname,lastname,account.name from contact];
    }
}