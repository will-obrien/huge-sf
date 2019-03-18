trigger Contact_CA_BIBU on Contact(before insert,before update) {
QAS_NA.RecordStatusSetter.InvokeRecordStatusSetterConstrained(trigger.new,trigger.old,trigger.IsInsert,2);
}