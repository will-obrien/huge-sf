Public Class BatchExmCtrl{
    Private list<contact> conList;
    // Constructer
    public BatchExmCtrl() {
       
    }
    
    public void createContact() {
        try{
            BatchClass b = new BatchClass();
            database.executebatch(b,10);
        }catch(Exception e){
        
        }
        
    }
}