//schedulable class that converts WorkFeedback from rich text field to int/string

global class ScheduleConvertWorkFeedback implements Schedulable
{
    convertFeedbackCtrl convertCtrl;
    SchConvertFeedbackBatch schConvertFeedbackBatch;
    public ScheduleConvertWorkFeedback()
    {
    	schConvertFeedbackBatch = new SchConvertFeedbackBatch(UserInfo.getUserEmail());
    }
    
    global void execute(SchedulableContext SC) {
    	ID batchprocessid = Database.executeBatch(schConvertFeedbackBatch);
    }
}