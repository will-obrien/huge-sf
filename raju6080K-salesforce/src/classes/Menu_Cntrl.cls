public class Menu_Cntrl {

    public PageReference FetchMenu() {
        return null;
    }

    public List<WrapMenu> wrpmnu{get;set;}
    public String SelectedVal { get; set; }
    public Map<Id,Menu__c> AllMenuMap { get; set; }
    public Map<Id,Menu__c> SelMenuMap { get; set; }
    public Map<Id,Menu__c> AddMenuMap { get; set; }
    public Map<Id,Menu__c> SubMenuMap { get; set; }
    public List<Wrapmenu> WrapClassList { get; set; }
  
    public Menu_Cntrl (){
        wrpmnu = new List<WrapMenu>();
        AllMenuMap = new Map<Id,Menu__c>();
        SelMenuMap = new Map<Id,Menu__c>();
        AddMenuMap = new Map<Id,Menu__c>();
        SubMenuMap = new Map<Id,Menu__c>();
         
        for(Menu__c m : [ select id, Name,Item_Category__c,Item_Grade__c ,Price__c from Menu__c ]){
            if(!AllMenuMap.containsKey(m.Id))
                AllMenuMap.put(m.Id,m);
                  system.debug('-----------Test1-------------:'+AllMenuMap);
        }
    }
    public void getSelMenu(){
        SelMenuMap.clear();
        for(Id m : AllMenuMap.keyset() ){
            if(SelectedVal == 'VegItems'){
                if( AllMenuMap.get(m).Item_Grade__c == 'Veg')
                SelMenuMap.put(m,AllMenuMap.get(m));
                system.debug('-----------Test-------------:'+m);
            }
            if(SelectedVal == 'NonVegItems'){
                if( AllMenuMap.get(m).Item_Grade__c == 'Non Veg')
                SelMenuMap.put(m,AllMenuMap.get(m));
            }
            if(SelectedVal == 'Others'){
                if( AllMenuMap.get(m).Item_Grade__c == 'Others')
                SelMenuMap.put(m,AllMenuMap.get(m));
            }
            if(SelectedVal == 'All'){
                SelMenuMap.put(m,AllMenuMap.get(m));
            }
            
        }
    }
    public void AddSelMenu(){
        Id SelId = ApexPages.CurrentPage().getParameters().get('add');
        if(!AddMenuMap.containsKey(SelId)){
           // AddMenuMap.put(SelId,new Menu__c());
            AddMenuMap.put(SelId,AllMenuMap.get(SelId));
            SelMenuMap.remove(SelId);
        }
    } 
    public void SubSelMenu(){
        Id RemId = ApexPages.CurrentPage().getParameters().get('sub');
        AddMenuMap.remove(RemId);
        SelMenuMap.put(RemId,AllMenuMap.get(RemId));
    } 
      public class Wrapmenu{
        public integer quantity{get;set;}
        public Menu__c menu{get;set;}
        public Wrapmenu(){
          menu = new Menu__c();
         }
   }
  }