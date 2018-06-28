public abstract class Handler {
	
	public String handlerType {get; set;}
	
	public Handler(){
	}
	
	public Handler(String typeOfHandler) {
		handlerType = typeOfHandler;
	}

	public abstract void mainEntry(String triggerObject,
		Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
		Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
		map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap);
	
	public abstract void inProgressEntry(String triggerObject,
		Boolean isBefore, Boolean isAfter, Boolean isInsert, Boolean isUpdate,
		Boolean isDelete, Boolean isUndelete, Boolean isExecuting, list<SObject> newList,
		map<Id,SObject> newMap, list<SObject> oldList, map<Id,SObject> oldMap);

}