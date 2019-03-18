public with sharing class DragAndDropController{
    public List<Account> getWarmAccounts()
    {
        return [Select Id, Name, AccountNumber, OwnerId, Phone, Fax, Rating From Account where Rating='Warm' limit 10];
    }
    public List<Account> getCoolAccounts()
    {
        return [Select Id, Name, AccountNumber, OwnerId, Phone, Fax, Rating From Account where Rating='cold' limit 10];
    }
    
    @RemoteAction
    public static String updateStatus(String AccId,String containerId){
        Account obj=[select id,Rating from account where id=:AccId];
        if(containerId.contains('theTable1')){
            obj.Rating='Warm';
        }
        if(containerId.contains('theTable2')){
            obj.rating='Cold';
        }
        update obj;
        return AccId;
    }
}