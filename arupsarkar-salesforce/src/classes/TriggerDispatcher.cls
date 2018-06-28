public with sharing class TriggerDispatcher {

	private static final String SPRINT = 'kavayah__Sprint__c';
	private static final String SPRINTTASK = 'kavayah__Sprint_Task__c';

	public static ITriggerEntry activeInstance = null;
	public static Map<Id, SObject> sObjectsToUpdate = new Map<Id, SObject>();
	public static List<SObject> sObjectsToInsert = new List<SObject>();
	public static List<SObject> sObjectsToDelete = new List<SObject>();
    
	public interface ITriggerEntry
	{
		void mainEntry(TriggerParameters tp);
		void inProgressEntry(TriggerParameters tp);
	}
    
	public class TriggerParameters
	{
		public String triggerObject {get; private set;}
	    public Boolean isBefore {get; private set;}
	    public Boolean isAfter {get; private set;}
	    public Boolean isDelete {get; private set;}
	    public Boolean isInsert {get; private set;}
	    public Boolean isUpdate {get; private set;}
	    public Boolean isExecuting {get; private set;}
	    public List<SObject> oldList {get; private set;}
	    public List<SObject> newList {get; set;}
	    public Map<Id, SObject> oldMap {get; private set;}
	    public Map<Id, SObject> newMap {get; set;}
	    
	    public TriggerParameters(Boolean ib, Boolean ia, Boolean id, Boolean ii, Boolean iu, Boolean ie, 
	      List<SObject> ol, List<SObject> nl, Map<Id, SObject> om, Map<Id, SObject> nm)
	    {
	      this.isBefore = ib;
	      this.isAfter = ia;
	      this.isDelete = id;
	      this.isInsert = ii;
	      this.isUpdate = iu;
	      this.isExecuting = ie;
	      this.oldList = ol;
	      this.newList = nl;
	      this.oldMap = om;
	      this.newMap = nm;
	      this.triggerObject = getSObjType((this.oldList != null && this.oldList.size() > 0) ? 
	        this.oldList[0] : this.newList[0]);
	    }
	    
	    private String getSObjType(SObject so)
	    {
	      String retVal;
	      if(so instanceof kavayah__Sprint__c) retVal = SPRINT;
	      return retVal;
	    }
	}
    
	  // Central dispatch entry
	public static void entry(TriggerParameters tp)
	{  
		if(activeInstance == null) 
	      processWork(tp);
	    else
	      activeInstance.inProgressEntry(tp);
	}
  
  	// Order of execution is controlled
  	private static void processWork(TriggerParameters tp)
  	{
    	if(tp.triggerObject == SPRINT && 
           (
               (tp.isAfter && tp.isUpdate) || 
               (tp.isAfter && tp.isInsert)
           )
        )
    	{
	      //execute(new ProductScheduleLineItems(), tp);
	      //execute(new RollupTotals(), tp);
	      //execute(new AccountSync(), tp);
	      //execute(new CalloutQueue(), tp);
    	}
    else if(tp.triggerObject == SPRINTTASK && tp.isAfter && tp.isUpdate)
    {
    //  execute(new SyncUserToContact(), tp);    	
    }

    
        
    	if(sObjectsToDelete.size() > 0)
            delete sObjectsToDelete;

        if(sObjectsToUpdate.size() > 0) 
      		update sObjectsToUpdate.values();
        
        if(sObjectsToInsert.size() > 0)
            insert sObjectsToInsert;
  	}
    
  	private static void execute(ITriggerEntry ite, TriggerParameters tp)
  	{
    	activeInstance = ite;
    	activeInstance.mainEntry(tp);
  	}


}