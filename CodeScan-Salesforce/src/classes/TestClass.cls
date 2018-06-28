public class TestClass
{
    final List<Contact> rma = new List<Contact>();
    private static Account rma;
        transient integer x1 = 0;
    
    public TestClass(){
    }
    public void x(){
        Opportunity Opty = (Opportunity)[SELECT ID, AccountID FROM Opportunity LIMIT 1];
        List<Contact> x = rma;
        
        transient integer x2 = 0;
        for ( Contact volatile : x ){
        }
        
        transient integer x3 = 0;
        
        boolean xx1 = 1 > = 3;
        //TODO: x3 > > = 3;
        
        List<List<SObject>> searchList = [ FIND 'asdf' in all fields returning Opportunity (Name) ];

    }
}