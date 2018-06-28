public class L3CheckBoxAccountController {
    
    public list<wrap> wrapList{get; set;}
    public String myResults {get; set;}
    
    public L3CheckBoxAccountController(){
        
        wrapList = new list<wrap>();
      
        for (Account item: [SELECT id, Name FROM Account] ) {
            wrap tempWrap = new wrap();
            tempWrap.isSelected = false;
            tempWrap.myAccount = item;
            wrapList.add(tempWrap);
        }      
            
            
    }
    
    public void processWraps(){
        myResults = 'Next Wraps were selected: ';
        
        for (wrap item : wrapList)
        {
            if (item.isSelected)
            {
                myResults += item.myAccount.name + ', ';
            }
        }
    }
    
    private class wrap{
        public boolean isSelected {get;set;}
        public Account myAccount{get; set;}
    }

}