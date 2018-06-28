public class Menu2_Cntrl {


    public String SelectedVal { get; set; }
    public List<Menu__c> Allitem { get; set; }
       
    public List<Menu__c> LeftListitem { get; set; }
    public List<Menu__c> RightListitem { get; set; }
    public Set<Menu__c> LeftSetitem { get; set; }
    public Set<Menu__c> RightSetitem { get; set; }
      public Set<Menu__c> AddLeftSetitem { get; set; }
    //public integer quantity{get;set;}
    //public List<Menu__c> removeselecteditem{get;set;}
    //public  List<Menu__c>  selecteditems { get; set; }
    
    public List<WrapMenu2> WrapClassList { get; set; }
  
    public Menu2_Cntrl (){
        WrapClassList = new List<WrapMenu2 >();
        Allitem = new List<Menu__c>();
        LeftListitem = new List<Menu__c>();
        RightListitem = new List<Menu__c>();
        LeftSetitem = new Set<Menu__c>();
        RightSetitem = new Set<Menu__c>();
       
       
       AddLeftSetitem = new Set<Menu__c>(); 
        //selecteditems = new List<Menu__c>();
    }  
   

    public void FetchMenu(){        
           leftlistitem.clear();
            if(SelectedVal == 'All'){
                Allitem = [select id, Name,Item_Category__c,Item_Grade__c ,Price__c from Menu__c where Item_Grade__c <> 'Others'];   
            }
            if(SelectedVal == 'VegItems'){
                Allitem = [select id, Name,Item_Category__c,Item_Grade__c ,Price__c from Menu__c where Item_Grade__c =: 'Veg'];
            }    
            if(SelectedVal == 'NonVegItems'){
                Allitem = [select id,Name,Item_Category__c,Item_Grade__c ,Price__c from Menu__c where Item_Grade__c =: 'Non Veg'];
            }   

            LeftListitem.addall(Allitem);
            LeftSetitem.addall(Allitem);
    }
    
    public void getSelectedRecords(){
     
        id recid1 =  ApexPages.CurrentPage().getParameters().get('selected');
            List<Menu__c> templist = new List<Menu__c>();
            
            for( Menu__c a : leftlistitem ){
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
        
    
   public void removeSelectedRecords(){
       id recid =  ApexPages.CurrentPage().getParameters().get('removeselected');
            List<Menu__c> templist = new List<Menu__c>();
               
            for(Menu__c a:rightlistitem){
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
        
        
       //AddLeftSetitem.addall(RightListitem);       
       //LeftListitem.addall(AddLeftSetitem);
               
   
  
  public class WrapMenu2 {
        public Menu__c mnu { get; set;}
        public integer quantity{get; set;}
        public decimal price{get;set;}
        public  WrapMenu2 () {
            //mnu = m;
        
        }
    } 
  }