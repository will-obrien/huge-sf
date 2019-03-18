public with sharing class getAccounts{


    public Account acc;
    
    public getAccounts (ApexPages.StandardController controller){

        acc = [SELECT id, name from account where id = '0012400000DjylG'];
        
        
    }

}