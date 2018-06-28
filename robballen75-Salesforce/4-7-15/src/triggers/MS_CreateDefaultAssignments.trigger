trigger MS_CreateDefaultAssignments on MS_Project__c (after insert) {
	 if (trigger.size == 1)
    {

 
MS_assignment__c assignment3 = new MS_assignment__c();
	assignment3.Area_of_Effort__c = 'Build';
	assignment3.Hours_Assigned__c = 0;
	assignment3.Project__c = trigger.new[0].Id;
	insert assignment3;

MS_assignment__c assignment6 = new MS_assignment__c();
	assignment6.Area_of_Effort__c = 'Design';
	assignment6.Hours_Assigned__c = 0;
	assignment6.Project__c = trigger.new[0].Id;
	insert assignment6;

MS_assignment__c assignment8 = new MS_assignment__c();
	assignment8.Area_of_Effort__c = 'Desktop Deployment';
	assignment8.Hours_Assigned__c = 0;
	assignment8.Project__c = trigger.new[0].Id;
	insert assignment8;

MS_assignment__c assignment2 = new MS_assignment__c();
	assignment2.Area_of_Effort__c = 'Discovery/Analysis';
	assignment2.Hours_Assigned__c = 0;
	assignment2.Project__c = trigger.new[0].Id;
	insert assignment2;
	
	
MS_assignment__c assignment10 = new MS_assignment__c();
	assignment10.Area_of_Effort__c = 'Document';
	assignment10.Hours_Assigned__c = 0;
	assignment10.Project__c = trigger.new[0].Id;
	insert assignment10;

MS_assignment__c assignment1 = new MS_assignment__c();
	assignment1.Area_of_Effort__c = 'Project Management';
	assignment1.Hours_Assigned__c = 0;
	assignment1.Project__c = trigger.new[0].Id;
	insert assignment1;

MS_assignment__c assignment11 = new MS_assignment__c();
	assignment11.Area_of_Effort__c = 'Scope';
	assignment11.Hours_Assigned__c = 0;
	assignment11.Project__c = trigger.new[0].Id;
	insert assignment11;

MS_assignment__c assignment7 = new MS_assignment__c();
	assignment7.Area_of_Effort__c = 'Test';
	assignment7.Hours_Assigned__c = 0;
	assignment7.Project__c = trigger.new[0].Id;
	insert assignment7;
	
MS_assignment__c assignment5 = new MS_assignment__c();
	assignment5.Area_of_Effort__c = 'Train';
	assignment5.Hours_Assigned__c = 0;
	assignment5.Project__c = trigger.new[0].Id;
	insert assignment5;

MS_assignment__c assignment12 = new MS_assignment__c();
	assignment12.Area_of_Effort__c = 'Travel';
	assignment12.Hours_Assigned__c = 0;
	assignment12.Project__c = trigger.new[0].Id;
	insert assignment12;

MS_assignment__c assignment4 = new MS_assignment__c();
	assignment4.Area_of_Effort__c = 'Troubleshoot/Support';
	assignment4.Hours_Assigned__c =0;
	assignment4.Project__c = trigger.new[0].Id;
	insert assignment4;
	
MS_assignment__c assignment9 = new MS_assignment__c();
	assignment9.Area_of_Effort__c = 'Validation & Feedback';
	assignment9.Hours_Assigned__c = 0;
	assignment9.Project__c = trigger.new[0].Id;
	insert assignment9;
	
//end detect if we're creating Standard assignments.	


    }


//end detect of only one record 
}