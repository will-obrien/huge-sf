public class Milestone1_Milestone_Values_Helper {
    
    //used by Milestone1_Milestone_Trigger_Utility to track new field values for a Milestone
    
    public Milestone1_Milestone__c oldRecord {get; set;}
    public Milestone1_Milestone__c newRecord {get; set;}
    
    public Milestone1_Milestone_Values_Helper(Milestone1_Milestone__c rec){
        oldRecord = rec;
        
        //fields require initialization or the "newRecord.[something] += " will fail with an NPE
        newRecord = new Milestone1_Milestone__c();
        newRecord.Actual_Hours_From_Sub_Milestones__c =0;
        newRecord.Actual_Expense_From_Sub_Milestones__c  =0;
        newRecord.Estimated_Hours_From_Sub_Milestones__c  =0;
        newRecord.Estimated_Expense_From_Sub_Milestones__c  =0;
        newRecord.Hours_Budget_from_Sub_Milestones__c  =0;
        newRecord.Expense_Budget_from_Sub_Milestones__c  =0;
        newRecord.Open_Tasks_in_Sub_Milestones__c  =0;
        newRecord.Late_Tasks_in_Sub_Milestones__c  =0;
        newRecord.Complete_Tasks_in_Sub_Milestones__c  =0;
        newRecord.Blocked_Tasks_in_Sub_Milestones__c  =0;

    }
    
    public void addValuesFromChild(Milestone1_Milestone__c child){
        System.debug('*** Adding values from "' + child.Name + '" to "' + oldRecord.Name + '"');
        System.debug('*** Values being added are: ' + child);
        
        newRecord.Actual_Hours_From_Sub_Milestones__c += child.Total_Actual_Hours__c;
        newRecord.Actual_Expense_From_Sub_Milestones__c += child.Total_Actual_Expense__c;
        newRecord.Estimated_Hours_From_Sub_Milestones__c += child.Total_Estimated_Hours__c;
        newRecord.Estimated_Expense_From_Sub_Milestones__c += child.Total_Estimated_Expense__c;
        newRecord.Hours_Budget_from_Sub_Milestones__c += child.Hours_Budget__c;
        newRecord.Expense_Budget_from_Sub_Milestones__c += child.Expense_Budget__c;
        newRecord.Open_Tasks_in_Sub_Milestones__c += child.Total_Open_Tasks__c;
        newRecord.Late_Tasks_in_Sub_Milestones__c += child.Total_Late_Tasks__c;
        newRecord.Complete_Tasks_in_Sub_Milestones__c += child.Total_Late_Tasks__c;
        newRecord.Blocked_Tasks_in_Sub_Milestones__c += child.Total_Blocked_Tasks__c;
        
        System.debug('*** New values are: ' + newRecord);
    }
    
    public void updateOldWithNew(){
        oldRecord.Estimated_Hours_From_Sub_Milestones__c = newRecord.Estimated_Hours_From_Sub_Milestones__c;
        oldRecord.Estimated_Expense_From_Sub_Milestones__c = newRecord.Estimated_Expense_From_Sub_Milestones__c;
        oldRecord.Actual_Hours_From_Sub_Milestones__c = newRecord.Actual_Hours_From_Sub_Milestones__c;
        oldRecord.Actual_Expense_From_Sub_Milestones__c = newRecord.Actual_Expense_From_Sub_Milestones__c;
        oldRecord.Hours_Budget_From_Sub_Milestones__c = newRecord.Hours_Budget_From_Sub_Milestones__c;
        oldRecord.Expense_Budget_From_Sub_Milestones__c = newRecord.Expense_Budget_From_Sub_Milestones__c;
        oldRecord.Open_Tasks_in_Sub_Milestones__c = newRecord.Open_Tasks_in_Sub_Milestones__c;
        oldRecord.Late_Tasks_in_Sub_Milestones__c = newRecord.Late_Tasks_in_Sub_Milestones__c;
        oldRecord.Complete_Tasks_in_Sub_Milestones__c = newRecord.Complete_Tasks_in_Sub_Milestones__c;
        oldRecord.Blocked_Tasks_in_Sub_Milestones__c = newRecord.Blocked_Tasks_in_Sub_Milestones__c;
        System.debug('*** Final values are: ' + oldRecord);
    }

}