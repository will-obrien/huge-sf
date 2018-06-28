public with sharing class ContactTriggerHandler {
    
    public static void updateAccountLookup(List<Contact> newContacts) {

        //Fetch accounts with not null domain
        List<Account> accList = [Select a.Website,
                                        a.Id
                                 From Account a
                                 where a.Website <> NULL
                                 order by a.Name];

        //Create map of websites and Ids
        Map<String,Id> mapWebsites = new Map<String,Id>();
        for(Account accInstance : accList) {
            mapWebsites.put(accInstance.Website,accInstance.Id);
        }

        //map website to email address
        set<String> websites = mapWebsites.keyset();
        for(String website : websites) {
            for(Contact conInstance : newContacts) {
                if(conInstance.Email <> NULL) {
                    if(website.containsIgnoreCase(conInstance.Email.substringBetween('@','.'))) {
                        conInstance.AccountId = mapWebsites.get(website);
                    }
                }
            }
        }
    }
}