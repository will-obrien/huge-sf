@isTest
public class assignmentOneTestClass{
@istest
public static void check(){
    contact con = new contact();
    con.lastname='kuhi';
    insert con;
    apexpages.currentpage().getParameters().put('id',con.id);
    assinmentOneController obj =new assinmentOneController();
    obj.save();
    obj.del();
    obj.addrow();
}

}