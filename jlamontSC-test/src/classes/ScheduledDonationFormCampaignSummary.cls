global class ScheduledDonationFormCampaignSummary implements Schedulable {
	global void execute(SchedulableContext ctx) {
		String recordTypeToSummarize = 'Donation Form';
		Date minDate = Date.Today() - 5;
		Database.executeBatch(new InitializeGiftCampaignSummary(recordTypeToSummarize, minDate), 1000);
	}
}