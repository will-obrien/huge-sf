@isTest
public class testClassDemoController{
@istest
    public static void check(){
        Contact con=new Contact();
       
        con.lastname='kuhu';
       
        insert con;
        
        apexpages.currentpage().getparameters().put('id',con.id);
      
        upsercontactController obj=new upsercontactController();
        obj.save();
    }

}