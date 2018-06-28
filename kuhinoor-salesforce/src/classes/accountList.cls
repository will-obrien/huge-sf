Public class accountList{
Public List<account> accList{get;set;}
 Public accountList(){
  accList = new List<account>([select name,id,description,accountnumber,annualrevenue from account limit 5]);
 }
}