public with sharing class Milestone1_One_Line_Controller {
    
    public String line {get; set;}
    public Milestone1_Task__c task {get;set;}
    public Milestone1_One_Line_Controller()
    {
        task = null;
    }
    
    public void executeLine()
    {
        task = null;
        List<String> stringTokens = line.split('---',2);
        if(stringTokens.size() == 2)
        {
            String milestoneAlias = stringTokens.get(0).trim();
            Milestone1_Milestone__c milestone = getMilestoneByAlias(milestoneAlias);
            if(milestone != null)
            {
                try
                {
                    task = new Milestone1_Task__c();
                    String descriptionString = stringTokens.get(1).trim();
                    String nameString = stringTokens.get(1).trim();
                    nameString = Milestone1_General_Utility.processTaskName(nameString);
                    task.Name = nameString; 
                    if(descriptionString.length() >= 5000)
                    {
                        descriptionString = descriptionString.substring(0,4999);
                    }
                    task.Description__c = descriptionString;
                    task.Project_Milestone__c = milestone.Id;
                    insert task;
                    line = '';
                }catch(Exception e)
                {
                    ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'There was a Salesforce DML Error: ' + e.getMessage());
                    ApexPages.addMessage(errorMsg);
                }
            }else
            {
                ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The alias( ' + milestoneAlias + ') did not match any milestone.');
                ApexPages.addMessage(errorMsg);
            }
        }else
        {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'The line command was incorrect. Please use format <Alias> --- <DESCRIPTION>');
            ApexPages.addMessage(errorMsg);
        }   
    }
    

    
    private Milestone1_Milestone__c getMilestoneByAlias(String alias)
    {
        List<Milestone1_Milestone__c> milestones = [Select Id, Name, Alias__c from Milestone1_Milestone__c Where alias__c = :alias];
        //Milestones - Alias field is Unique, so we should only have one return value.
        if(milestones.size() > 0)
        {
            return milestones.get(0);
        }
        return null;
    }
    

}