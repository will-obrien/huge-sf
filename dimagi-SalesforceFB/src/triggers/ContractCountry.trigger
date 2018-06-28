/**
 * Trigger that updates the Country_Text__c field in Contract with the names 
 * of the Contract Countries
 *
 * @author  Virginia Fernández
 * @date    04/12/2013
 */
trigger ContractCountry on Contract_Country__c (after delete, after insert) {
    if (Trigger.isDelete) {
        ContractCountryTrigger.onUpdate(Trigger.old);
    }
    else ContractCountryTrigger.onUpdate(Trigger.new);
}