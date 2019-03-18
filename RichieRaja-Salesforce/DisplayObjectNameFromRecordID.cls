public class DisplayObjectNameFromRecordID 
{
	public void displayObjectName(Id RecordId)
    {
        string objName = RecordID.getSobjectType().getDescribe().getName();
        System.debug(objName);
    }
}