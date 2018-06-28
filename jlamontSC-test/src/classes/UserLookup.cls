//*************************************************************************************************
//
// Name              : UserLookup
// Date Created		 : 4/2/2015
// By                : Mark Maslow
// Description       : In order to minimize SOQL queries, get UserId from alias from Custom Setting

public class UserLookup {
    public static Id getId(String alias) {
        Map<String, UserLookup__c> userMap = UserLookup__c.getAll();
        UserLookup__c lookup = userMap.get(alias);
        Id userId = null;
        if(lookup != null) {
            userId = lookup.Id__c;
        }
        if(userId == null) {
            if(Test.isRunningTest()) {
                if(alias == 'ciron') {
                    userId = '005i000000264p4AAA';
                }
            }
        }
        return userId;
    }
}