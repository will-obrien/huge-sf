public class TokenManagerService {
    @future
    public static void upsertToken(String clientId, String token){
        Token_Manager__c tm = new Token_Manager__c();
        tm.Service_Name__c = 'slack';
        tm.Client_ID__c = clientId;
        tm.Token__c = token;
        System.debug('>>>>>>xxxxxx Hello');
        Database.upsert(tm);
    }
}