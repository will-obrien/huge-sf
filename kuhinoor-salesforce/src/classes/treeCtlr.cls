Public Class treeCtlr{
    Public List<model> modelList{get;set;}
    Public treeCtlr(){
       
    }
    Public List<model> getTreeNode(){
        modelList = new List<model>();
        List<Account> Acclist = [select id,name from account limit 5];
        for(Integer i=0;i<acclist.size();i++){
            List<Contact> con = [select lastname,(select subject from cases) from contact where accountid=:acclist[i].id];
            modelList.add(new model(Acclist[i],con));
        }
        return modelList;
    }
    //------------wrapper class-------------------------
    Public Class model{
        Public Account acc{get;set;}
        Public List<Contact> conList{get;set;}
        Public model(Account a,List<Contact>con){
            acc= a;
            conList = con;
        }
    }
}