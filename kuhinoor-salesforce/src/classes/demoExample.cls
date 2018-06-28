Public Class demoExample{
    Public Contact con{get;set;}
    Public DemoExample(){
        con = new Contact();
        }
        public pageReference save(){
            insert con;
            return New PageReference('/'+con.id);
        }
}