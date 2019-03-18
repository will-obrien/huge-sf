Public Class examControllerpiechartCtlr{
Public Integer pass;
Public Integer fail;
    public examControllerpiechartCtlr(){  
            pass=Integer.valueOf(apexPages.currentpage().getParameters().get('pass'));
            fail=Integer.valueOf(apexPages.currentpage().getParameters().get('fail'));
    }
    Public  List<picModelClass> getPieData(){
           List<picModelClass> data = new   List<picModelClass>();
           data.add(new picModelClass('',pass));
           data.add(new picModelClass('',fail));
           return data;
       }
        Public class picModelClass{
        Public String name{get;set;}
        Public Integer data{get;set;}
       public picModelClass(String name,Integer data){
           this.name=name;
           this.data=data;
       }
    }
 }