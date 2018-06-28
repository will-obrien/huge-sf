// *************************************************************************/
// ContactAfterUpdate Trigger
//           
//  2015/05/26		Mark Maslow			Original
//
//  August 2015         Mark Maslow
//                      Add call to FlagAddUpAccounts
//
//  January 2017        Mark Maslow
//                      Add call to MobileSubscriberContactUpdate
// *************************************************************************/
trigger ContactAfterUpdate on Contact (after update) {
	ContactAfterUpdateHandler.afterUpdateHandler(trigger.new, trigger.newMap, trigger.oldMap);
	FlagAddUpAccounts.flagAccounts(Trigger.new, trigger.oldMap);
	MobileSubscriberContactUpdate.handleUpdate(Trigger.new, Trigger.oldMap);
}