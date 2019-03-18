/**
* @author Jim Hutcherson
* @date May 1 2014
*
**/
public with sharing class MergeHistory {
	
	public String createdDate {get;set;}
	public String field {get;set;}
	public String newValue {get;set;}
	public String oldValue {get;set;}
	
	public MergeHistory(){
		
	}
	
	public MergeHistory(String createdDate,String field,String newValue,String oldValue){
		this.createdDate = createdDate;
		this.field = field;
		this.newValue = newValue;
		this.oldValue = oldValue;
	}

}