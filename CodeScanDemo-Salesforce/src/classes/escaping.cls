public class escaping {
    public void test(){
        string y;
        string z;
        object x;
        
        
        string zzzzzz;
        
//        y = '\_';
        x = [SELECT id FROM OpportunityLineItem WHERE Name LIKE '\_%'];
        
        y = '\"';
        x = [SELECT id FROM OpportunityLineItem WHERE Name LIKE '\"%'];
        
        y = '\'';
        x = [SELECT id FROM OpportunityLineItem WHERE Name LIKE '\'%'];
        
        //y = '\%';
        x = [SELECT id FROM OpportunityLineItem WHERE Name LIKE '\%%'];
    }
}