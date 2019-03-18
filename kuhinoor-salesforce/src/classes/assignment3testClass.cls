@isTest
public class assignment3testClass{
@isTest
    public static void check(){
       
       
        contact c = new contact();
        c.lastname= 'kuhi';
        insert c;
       // apexpages.currentpage().getParameters().put('id',c.id);
        assignmentThiredController obj = new assignmentThiredController();
       obj.lastname='hbfj';
       obj.att.body=Blob.valueOf('test');
       obj.att.parentid = c.id;
       obj.att.name='jack';
       
       obj.save();
        
    }
}