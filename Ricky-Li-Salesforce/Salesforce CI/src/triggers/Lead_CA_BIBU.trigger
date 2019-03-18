trigger Lead_CA_BIBU on Lead(before insert,before update) {
QAS_NA.RecordStatusSetter.InvokeRecordStatusSetterConstrained(trigger.new,trigger.old,trigger.IsInsert,2);
}