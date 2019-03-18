global with sharing class TimeRemote {
    
    public TimeRemote() {}
    
	@RemoteAction
    global static Long getTimeNow() {
	   	Long theTime = DateTime.now().getTime();
        return theTime;
    }
}