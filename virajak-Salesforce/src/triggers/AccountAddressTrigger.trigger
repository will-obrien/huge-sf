trigger AccountAddressTrigger on Account (before insert, before update) {
    AccountAddressTriggerHandler.doCheckboxMatchBillingAddress(Trigger.new);
}