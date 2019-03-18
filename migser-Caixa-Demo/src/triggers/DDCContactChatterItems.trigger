trigger DDCContactChatterItems on Contact (after update) {
    List<FeedItem> fitmList = new List<FeedItem>();
   
    for (Integer i=0; i < Trigger.new.size(); i++)
    {       
        if ( Trigger.new[i].CleanStatus != Trigger.old[i]. CleanStatus )
        {
            // Create FeedItem using this Contact as a Parent Record
            FeedItem fp = new FeedItem();
            fp.parentId = Trigger.new[i].id;
 
            if ( Trigger.new[i]. CleanStatus == 'Different' ) {
                fp.Body = 'There is updated information for this contact.';
            }           
           
            if ( fp.Body != null )
                fitmList.add(fp);
        }
    }
    insert fitmList;
}