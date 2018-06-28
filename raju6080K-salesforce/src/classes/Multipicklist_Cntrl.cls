public class Multipicklist_Cntrl {
 public List<Account> leftlistitem{get;set;}
 public set<Account> leftsetitem{get;set;}
 public List<Account> rightlistitem{get;set;}
 public set<Account> rightsetitem{get;set;}
 
        public Multipicklist_Cntrl(){
            leftlistitem = new List<Account>();
            leftsetitem = new Set<Account>();
            rightlistitem = new List<Account>();
            rightsetitem = new set<Account>();
            
            leftlistitem =[select id,name from Account];
            leftsetitem.addall(leftlistitem);
            leftlistitem.sort();rightlistitem.sort();
        }
        public void getSelectedAccounts(){
            id recid1 =  ApexPages.CurrentPage().getParameters().get('selected');
            List<Account> templist = new List<Account>();
            
            for( Account a : leftlistitem ){
                if( a.id == recid1 )
                    templist.add(a);         
            }
            leftsetitem.removeall(templist);
            rightsetitem.addall(templist);
            leftlistitem.clear();leftlistitem.addall(leftsetitem);
         rightlistitem.clear();
           rightlistitem.addall(rightsetitem);
            leftlistitem.sort();rightlistitem.sort();
        }
        public void getRemovedAccounts(){
            id recid =  ApexPages.CurrentPage().getParameters().get('removeselected');
            List<Account> templist = new List<Account>();
               
            for(Account a:rightlistitem){
                if(a.id == recid )
                    templist.add(a);
            }
            rightsetitem.removeall(templist);
            leftsetitem.addall(templist);
            leftlistitem.clear();
           leftlistitem.addall(leftsetitem);
            rightlistitem.clear();rightlistitem.addall(rightsetitem);
            leftlistitem.sort();rightlistitem.sort();
        }
}