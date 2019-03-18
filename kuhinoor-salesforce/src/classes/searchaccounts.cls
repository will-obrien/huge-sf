public class searchaccounts {
Public List<account> accList{get;set;}
Public string searchString{get;set;}
public searchaccounts(ApexPages.StandardController controller) {
}
Public void searchAcc(){
accList = new List<account>();
accList = [select id,name,accountnumber,annualrevenue,Industry,AccountSource from account where name =: searchString limit 5];
}
}