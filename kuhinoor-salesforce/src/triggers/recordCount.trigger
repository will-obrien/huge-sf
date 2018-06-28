trigger recordCount on recordcount__c (after insert) {
list<account> acc =new list<account>();
    if(trigger.isInsert){
    integer count=0;
        for(recordCount__c c : trigger.new){
            count++;
        }
    }

}