Public Class bulkAcccountInsertWithContact{
    Public List<model> mdlList{get;set;}
    Public List<model> mdconList{get;set;}
    Public Integer rowIndex{get;set;}
    
    //---------constractor--------------
    Public bulkAcccountInsertWithContact(){
       mdlList= new List<model>();      
       model md = new Model();
       mdlList.add(md);
             
       
    }
    Public void addModelRow(){
        
         model md = new Model();
         mdlList.add(md);
    }
    Public void addconrow(){
        System.debug('****************'+rowIndex);
         model m = mdlList[rowIndex];
         m.conList.add(new contact());
    }
   public void extra(){
   }
   Public void save(){
       
       List<Account> acclist = new List<Account>();
       List<Contact> conlist= new List<Contact>();
       acclist.clear();
       conlist.clear(); 
       for(model mObj : mdlList){                 
           acclist.add(mObj.acc); 
       }
       insert acclist;
       for(model md : mdlList){
      
           for(Contact c : md.conlist){
               c.accountid=md.acc.id;
               conlist.add(c);
           
           
       }
           
       }
       insert conlist;
   }
   //--------wrapper class----------
   Public Class model{
       Public Account acc{get;set;}
       Public list<Contact> conList{get;set;}
       public model(){
           acc = new account();
           conList= new list<Contact>();
           conlist.add(new Contact());
       }
       
   }
}