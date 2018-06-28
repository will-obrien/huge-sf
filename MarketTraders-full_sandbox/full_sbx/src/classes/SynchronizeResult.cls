public with sharing class SynchronizeResult {
	
	private set<Id> resultIds {get;set;}
	
	public SynchronizeResult() {
		this.resultIds = new set<Id>();
	}

	public void addResultId(Id resultId) {
		this.resultIds.add(resultId);
	}
	
	public set<Id> getResultIds(){
		return this.resultIds;
	}

}