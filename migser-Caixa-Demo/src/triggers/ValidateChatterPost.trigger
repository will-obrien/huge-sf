trigger ValidateChatterPost on FeedItem(before insert, before update) {
    if (Trigger.isInsert) {
        for (FeedItem f: Trigger.New) {
            if (String.valueOf(f.body) != null || String.valueOf(f.body) != '') {
                Boolean b = true;
                for (Blacklisted__c bld: [select name From Blacklisted__c]) {
                    if ((String.valueOf(f.body).containsIgnoreCase(bld.Name))) {
                        b = false;
                    }
                    System.debug('--------------------------------' + b);
                }
                if (b) {} else {
                    f.addError('You cannot use blacklisted words to post.');
                }
            }
        }
    }

    if (Trigger.IsUpdate) {
        for (FeedItem f: Trigger.New) {
            if (String.valueOf(f.body) != null || String.valueOf(f.body) != '') {
                Boolean b = true;
                for (Blacklisted__c bld: [select name From Blacklisted__c]) {
                    if ((String.valueOf(f.body).containsIgnoreCase(bld.Name))) {
                        b = false;
                    }
                    System.debug('--------------------------------' + b);
                }
                if (b) {} else {
                    f.addError('You cannot use blacklisted words to post.');
                }
            }
        }
    }
}