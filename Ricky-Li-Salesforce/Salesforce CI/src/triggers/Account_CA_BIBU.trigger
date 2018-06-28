trigger Account_CA_BIBU on Account(before insert,before update) {
QAS_NA.RecordStatusSetter.InvokeRecordStatusSetterConstrained(trigger.new,trigger.old,trigger.IsInsert,2);
}