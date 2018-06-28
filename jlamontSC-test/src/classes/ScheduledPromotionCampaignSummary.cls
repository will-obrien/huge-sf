global class ScheduledPromotionCampaignSummary implements Schedulable {
	global void execute(SchedulableContext ctx) {
		String recordTypeToSummarize = 'Promotion';
		Date minDate = Date.Today() - 5;
		Database.executeBatch(new InitializeGiftCampaignSummary(recordTypeToSummarize, minDate), 1000);
	}
}