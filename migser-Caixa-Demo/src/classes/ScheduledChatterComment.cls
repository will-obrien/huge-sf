/********************************************
 * takes a feed comment and schedule it
 *
 *******************************************/
global class ScheduledChatterComment implements Schedulable
{
    public FeedComment fc;
    public ScheduledChatterComment(FeedComment fComment)
    {
        fc = fComment;
    }
    
    global void execute(SchedulableContext SC) 
    {
        insert fc;
        //System.abortJob(SC.getTriggerID());
    }
}