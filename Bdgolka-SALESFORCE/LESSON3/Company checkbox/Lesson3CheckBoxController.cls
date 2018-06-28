public class Lesson3CheckBoxController {

    public list<wrap> wrapList{get; set;}
    public String myResults {get; set;}
    
    public Lesson3CheckBoxController(){
        
        wrapList = new list<wrap>();
        
        wrap w1 = new wrap();
        w1.Name = 'Apple';
        w1.isSelected = false;
        wrapList.add(w1);
        
        wrap w2 = new wrap();
        w2.Name = 'Microsoft';
        w2.isSelected = true;
        wrapList.add(w2);
        
        wrap w3 = new wrap();
        w3.Name = 'Cisco';
        w3.isSelected = false;
        wrapList.add(w3);

    }
    
    public void processWraps(){
        myResults = 'Next Wraps were selected: ';
        
        for (wrap item : wrapList)
        {
            if (item.isSelected)
            {
                myResults += item.Name + ', ';
            }
        }
    }
    
    private class wrap{
        public string Name {get;set;}
        public boolean isSelected {get;set;}
    }
}