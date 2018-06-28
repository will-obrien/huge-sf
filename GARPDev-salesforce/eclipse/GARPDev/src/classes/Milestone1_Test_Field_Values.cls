@isTest
private class Milestone1_Test_Field_Values {

    static testMethod void testFieldValues() {
        final Integer NUMBER_OF_MILESTONES = 5;
        final Integer NUMBER_OF_TASKS = 20;
        final Integer NUMBER_OF_TIMES = 50;
        final Integer NUMBER_OF_EXPENSES = 50;
        
        //create a project
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        insert proj;
        
        //create a couple of top-level milestones
        List<Milestone1_Milestone__c> topMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        topMilestones.add(ms1);
        Milestone1_Milestone__c ms2 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms2');
        topMilestones.add(ms2);
        insert topMilestones;
        
        //create a few sub-milestones underneath ms2
        List<Milestone1_Milestone__c> subMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms3 = Milestone1_Test_Utility.sampleMilestone(null, ms2.Id, 'ms3');
        subMilestones.add(ms3);
        Milestone1_Milestone__c ms4 = Milestone1_Test_Utility.sampleMilestone(null, ms2.Id, 'ms4');
        subMilestones.add(ms4);
        Milestone1_Milestone__c ms5 = Milestone1_Test_Utility.sampleMilestone(null, ms2.Id, 'ms5');
        subMilestones.add(ms5);
        insert subMilestones;
        
        //create a grandchild milestone to make sure that's prevented
        Milestone1_Milestone__c ms6 = Milestone1_Test_Utility.sampleMilestone(null, ms5.Id, 'ms6');
        Boolean errorFound = false;
        try {
            insert ms6;
        } catch (DMLException e){
            errorFound = true;
        } finally {
            System.assert(errorFound);
        }
        
        //collect all milestones
        List<Milestone1_Milestone__c> milestones = new List<Milestone1_Milestone__c>();
        milestones.addAll(topMilestones);
        milestones.addAll(subMilestones);
        
        //create tasks linked to milestones
        List<Milestone1_Task__c> tasks = new List<Milestone1_Task__c>();
        for(Integer i = 0; i < NUMBER_OF_TASKS; i++){
            Id parentMilestoneId = milestones[(Math.random() * NUMBER_OF_MILESTONES).intValue()].Id;
            Milestone1_Task__c taskRec = Milestone1_Test_Utility.sampleTask(parentMilestoneId);
            tasks.add(taskRec);
        }
        insert tasks;
        
        //create time entries linked to tasks
        List<Milestone1_Time__c> times = new List<Milestone1_Time__c>();
        for(Integer i = 0; i < NUMBER_OF_TIMES; i++){
            Id parentTaskId = tasks[(Math.random() * NUMBER_OF_TASKS).intValue()].Id;
            Milestone1_Time__c timeRec = Milestone1_Test_Utility.sampleTime(parentTaskId);
            times.add(timeRec);
        }
        insert times;
        
        
        //create expense entries linked to tasks
        List<Milestone1_Expense__c> expenses = new List<Milestone1_Expense__c>();
        for(Integer i = 0; i < NUMBER_OF_EXPENSES; i++){
            Id parentTaskId = tasks[(Math.random() * NUMBER_OF_TASKS).intValue()].Id;
            Milestone1_Expense__c expense = Milestone1_Test_Utility.sampleExpense(parentTaskId);
            expenses.add(expense);
        }
        insert expenses;
        
        //query to get updated project and milestone records
        proj = [SELECT Id,
                       Number_of_Incomplete_Milestones__c,
                       Number_of_Incomplete_Top_Milestones__c,
                       Next_Project_Milestone_Due_Date__c,
                       Next_Project_Top_Milestone_Due_Date__c,
                       Total_Hours_Incurred__c,
                       Total_Hours_Estimate__c,
                       Total_Expense_Incurred__c,
                       Total_Expense_Estimate__c,
                       Total_Hours_Budget_from_Milestones__c,
                       Total_Expense_Budget_from_Milestones__c
                FROM Milestone1_Project__c
                WHERE Id = :proj.Id
               ];
               
        //query to get updated milestone records
        milestones = [SELECT Id,
                             Name,
                             Project__c,
                             Parent_Milestone__c,
                             Complete__c,
                             Deadline__c,
                             Actual_Hours_From_Tasks__c,
                             Actual_Expense_From_Tasks__c,
                             Estimated_Hours_From_Tasks__c,
                             Estimated_Expense_From_Tasks__c,
                             Actual_Hours_From_Sub_Milestones__c,
                             Estimated_Hours_From_Sub_Milestones__c,
                             Actual_Expense_From_Sub_Milestones__c,
                             Estimated_Expense_From_Sub_Milestones__c,
                             Hours_Budget__c,
                             Hours_Budget_From_Sub_Milestones__c,
                             Expense_Budget__c,
                             Expense_Budget_From_Sub_Milestones__c,
                             Open_Tasks_in_Tasks__c,
                             Late_Tasks_in_Tasks__c,
                             Open_Tasks_in_Sub_Milestones__c,
                             Late_Tasks_in_Sub_Milestones__c,
                             Total_Actual_Hours__c,
                             Total_Estimated_Hours__c,
                             Total_Hours_Balance__c,
                             Total_Actual_Expense__c,
                             Total_Estimated_Expense__c,
                             Total_Expense_Balance__c,
                             Total_Hours_Budget__c,
                             Total_Expense_Budget__c,
                             Total_Open_Tasks__c,
                             Total_Late_Tasks__c
                      FROM Milestone1_Milestone__c
                      WHERE Project__c = :proj.Id
                     ];
        
        //map milestones by their parent projects and milestones
        Map<Id, List<Milestone1_Milestone__c>> milestonesByProjectID = new Map<Id, List<Milestone1_Milestone__c>>();
        Map<Id, List<Milestone1_Milestone__c>> milestonesByMilestoneID = new Map<Id, List<Milestone1_Milestone__c>>();
        for(Milestone1_Milestone__c ms : milestones){
            //by project
            if(milestonesByProjectID.get(ms.Project__c) == null){
                milestonesByProjectID.put(ms.Project__c, new List<Milestone1_Milestone__c>());
            }
            milestonesByProjectID.get(ms.Project__c).add(ms);
            
            //by milestone
            if(milestonesByMilestoneID.get(ms.Parent_Milestone__c) == null){
                milestonesByMilestoneID.put(ms.Parent_Milestone__c, new List<Milestone1_Milestone__c>());
            }
            milestonesByMilestoneID.get(ms.Parent_Milestone__c).add(ms);
        }
               
        //query to get updated task, time, and expense records
        tasks = [SELECT Complete__c,
                        Due_Date__c,
                        Project_Milestone__c,
                        Total_Hours__c,
                        Total_Expense__c,
                        Estimated_Hours__c,
                        Estimated_Expense__c,
                        Hours_Balance__c,
                        Expense_Balance__c,
                        (SELECT Id,                     //child time data
                                Project_Task__c,
                                Hours__c
                         FROM Project_Times__r
                        ),
                        (SELECT Id,                     //child expense data
                                Project_Task__c,
                                Amount__c
                         FROM Project_Expenses__r
                        )
                 FROM Milestone1_Task__c
                 WHERE Project_Milestone__r.Project__c = :proj.Id
                ];
        
        //map tasks by their parent milestones
        Map<Id, List<Milestone1_Task__c>> tasksByMilestoneID = new Map<Id, List<Milestone1_Task__c>>();
        for(Milestone1_Task__c taskRec : tasks){
            if(tasksByMilestoneID.get(taskRec.Project_Milestone__c) == null){
                tasksByMilestoneID.put(taskRec.Project_Milestone__c, new List<Milestone1_Task__c>());
            }
            tasksByMilestoneID.get(taskRec.Project_Milestone__c).add(taskRec);
        }
        
        Test.startTest();
        
        //test Task field values
        for(Milestone1_Task__c taskRec : tasks){
            //test total times
            Double expectedTotal = 0;
            for(Milestone1_Time__c timeRec : taskRec.Project_Times__r){
                expectedTotal += timeRec.Hours__c;
            }
            System.assertEquals(expectedTotal, taskRec.Total_Hours__c);
            
            //test total expenses
            expectedTotal = 0;
            for(Milestone1_Expense__c expenseRec : taskRec.Project_Expenses__r){
                expectedTotal += expenseRec.Amount__c;
            }
            System.assertEquals(expectedTotal, taskRec.Total_Expense__c);
            
            //test balances
            System.assertEquals(taskRec.Estimated_Hours__c - taskRec.Total_Hours__c, taskRec.Hours_Balance__c);
            System.assertEquals(taskRec.Estimated_Expense__c - taskRec.Total_Expense__c, taskRec.Expense_Balance__c);
            
            
        }
        
        //test Milestone field values
        for(Milestone1_Milestone__c ms : milestones){
            
            //ensure that the correct number of record were generated and queried
            System.assertEquals(NUMBER_OF_TASKS, tasks.size());
            System.assertEquals(NUMBER_OF_MILESTONES, milestones.size());
            
            //if milestone has child tasks
            if(tasksByMilestoneID.get(ms.Id) != null){
                //test actual hours from tasks
                Decimal expectedTotal = 0;
                for(Milestone1_Task__c taskRec : tasksByMilestoneID.get(ms.Id)){
                    expectedTotal += taskRec.Total_Hours__c;
                }
                System.assertEquals(expectedTotal, ms.Actual_Hours_From_Tasks__c);
            
                //test estimated hours from tasks
                expectedTotal = 0;
                for(Milestone1_Task__c taskRec : tasksByMilestoneID.get(ms.Id)){
                    expectedTotal += taskRec.Estimated_Hours__c;
                }
                System.assertEquals(expectedTotal, ms.Estimated_Hours_From_Tasks__c);
                
                //test actual expense from tasks
                expectedTotal = 0;
                for(Milestone1_Task__c taskRec : tasksByMilestoneID.get(ms.Id)){
                    expectedTotal += taskRec.Total_Expense__c;
                }
                System.assertEquals(expectedTotal, ms.Actual_Expense_From_Tasks__c);
            
                //test estimated expense from tasks
                expectedTotal = 0;
                for(Milestone1_Task__c taskRec : tasksByMilestoneID.get(ms.Id)){
                    expectedTotal += taskRec.Estimated_Expense__c;
                }
                System.assertEquals(expectedTotal, ms.Estimated_Expense_From_Tasks__c);
                
                //test number of open tasks from tasks
                expectedTotal = 0;
                for(Milestone1_Task__c taskRec : tasksByMilestoneID.get(ms.Id)){
                    if(taskRec.Complete__c == false){
                        expectedTotal++;
                    }
                }
                System.assertEquals(expectedTotal, ms.Open_Tasks_in_Tasks__c);
                
                //test number of late tasks from tasks
                expectedTotal = 0;
                for(Milestone1_Task__c taskRec : tasksByMilestoneID.get(ms.Id)){
                    if(taskRec.Complete__c == false && taskRec.Due_Date__c < Date.today()){
                        expectedTotal++;
                    }
                }
                System.assertEquals(expectedTotal, ms.Late_Tasks_in_Tasks__c);
            }
            
            //if milestone has child milestones
            if(milestonesByMilestoneID.get(ms.Id) != null){
                //test actual hours from subs
                Decimal expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Total_Actual_Hours__c;
                }
                System.assertEquals(expectedTotal, ms.Actual_Hours_From_Sub_Milestones__c);
                
                //test estimated hours from subs
                expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Total_Estimated_Hours__c;
                }
                System.assertEquals(expectedTotal, ms.Estimated_Hours_From_Sub_Milestones__c);
                
                //test actual expense from subs
                expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Total_Actual_Expense__c;
                }
                System.assertEquals(expectedTotal, ms.Actual_Expense_From_Sub_Milestones__c);
                
                //test estimated expense from subs
                expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Total_Estimated_Expense__c;
                }
                System.assertEquals(expectedTotal, ms.Estimated_Expense_From_Sub_Milestones__c);
                
                //test hours budget from subs
                expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Hours_Budget__c;
                }
                System.assertEquals(expectedTotal, ms.Hours_Budget_From_Sub_Milestones__c);
                
                //test expense budget from subs
                expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Expense_Budget__c;
                }
                System.assertEquals(expectedTotal, ms.Expense_Budget_From_Sub_Milestones__c);
                
                //test number of open tasks from subs
                expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Total_Open_Tasks__c;
                }
                System.assertEquals(expectedTotal, ms.Open_Tasks_in_Sub_Milestones__c);
                
                //test number of late tasks from subs
                expectedTotal = 0;
                for(Milestone1_Milestone__c subMS : milestonesByMilestoneID.get(ms.Id)){
                    expectedTotal += subMS.Total_Late_Tasks__c;
                }
                System.assertEquals(expectedTotal, ms.Late_Tasks_in_Sub_Milestones__c);
            }
            
            //test total actual hours
            System.assertEquals(ms.Actual_Hours_From_Tasks__c + ms.Actual_Hours_From_Sub_Milestones__c, ms.Total_Actual_Hours__c);
            
            //test total estimated hours
            System.assertEquals(ms.Estimated_Hours_From_Tasks__c + ms.Estimated_Hours_From_Sub_Milestones__c, ms.Total_Estimated_Hours__c);
            
            //test total hours balance
            System.assertEquals(ms.Total_Estimated_Hours__c - ms.Total_Actual_Hours__c, ms.Total_Hours_Balance__c);
            
            //test total actual expense
            System.assertEquals(ms.Actual_Expense_From_Tasks__c + ms.Actual_Expense_From_Sub_Milestones__c, ms.Total_Actual_Expense__c);
            
            //test total estimated expense
            System.assertEquals(ms.Estimated_Expense_From_Tasks__c + ms.Estimated_Expense_From_Sub_Milestones__c, ms.Total_Estimated_Expense__c);
            
            //test total expense balance
            System.assertEquals(ms.Total_Estimated_Expense__c - ms.Total_Actual_Expense__c, ms.Total_Expense_Balance__c);
            
            //test total hours budget
            System.assertEquals(ms.Hours_Budget_from_Sub_Milestones__c + ms.Hours_Budget__c, ms.Total_Hours_Budget__c);
            
            //test total expense budget
            System.assertEquals(ms.Expense_Budget_from_Sub_Milestones__c + ms.Expense_Budget__c, ms.Total_Expense_Budget__c);
            
            //test total open tasks
            System.assertEquals(ms.Open_Tasks_in_Tasks__c + ms.Open_Tasks_in_Sub_Milestones__c, ms.Total_Open_Tasks__c);
            
            //test total late tasks
            System.assertEquals(ms.Late_Tasks_in_Tasks__c + ms.Late_Tasks_in_Sub_Milestones__c, ms.Total_Late_Tasks__c);
        }
        
        //test project field values
        //test actual hours from milestones
        Decimal expectedTotal = 0;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Parent_Milestone__c == null){
                expectedTotal += ms.Total_Actual_Hours__c;
            }
        }
        System.assertEquals(expectedTotal, proj.Total_Hours_Incurred__c);
        
        //test expected hours from milestones
        expectedTotal = 0;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Parent_Milestone__c == null){
                expectedTotal += ms.Total_Estimated_Hours__c;
            }
        }
        System.assertEquals(expectedTotal, proj.Total_Hours_Estimate__c);
        
        //test actual expense from milestones
        expectedTotal = 0;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Parent_Milestone__c == null){
                expectedTotal += ms.Total_Actual_Expense__c;
            }
        }
        System.assertEquals(expectedTotal, proj.Total_Expense_Incurred__c);
        
        //test expected expense from milestones
        expectedTotal = 0;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Parent_Milestone__c == null){
                expectedTotal += ms.Total_Estimated_Expense__c;
            }
        }
        System.assertEquals(expectedTotal, proj.Total_Expense_Estimate__c);
        
        //test hours budget from milestones
        expectedTotal = 0;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Parent_Milestone__c == null){
                expectedTotal += ms.Total_Hours_Budget__c;
            }
        }
        System.assertEquals(expectedTotal, proj.Total_Hours_Budget_from_Milestones__c);
        
        //test expense budget from milestones
        expectedTotal = 0;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Parent_Milestone__c == null){
                expectedTotal += ms.Total_Expense_Budget__c;
            }
        }
        System.assertEquals(expectedTotal, proj.Total_Expense_Budget_from_Milestones__c);
        
        //test number of incomplete milestones fields
        expectedTotal = 0;
        Integer expectedTop = 0;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Complete__c == false){
                expectedTotal++;
                if(ms.Parent_Milestone__c == null){
                    expectedTop++;
                }
            }
        }
        System.assertEquals(expectedTotal, proj.Number_of_Incomplete_Milestones__c);
        System.assertEquals(expectedTop, proj.Number_of_Incomplete_Top_Milestones__c);
        
        //test next milestone due date fields
        Date expectedTotalDate = null;
        Date expectedTopDate = null;
        for(Milestone1_Milestone__c ms : milestones){
            if(ms.Deadline__c != null && ms.Complete__c == false){
                if(expectedTotalDate == null){
                    expectedTotalDate = ms.Deadline__c;
                } else if(ms.Complete__c == false && ms.Deadline__c < expectedTotalDate){
                    expectedTotalDate = ms.Deadline__c;
                }
                if(ms.Parent_Milestone__c == null){
                    if(expectedTopDate == null){
                        expectedTopDate = ms.Deadline__c;
                    } else if(ms.Complete__c == false && ms.Deadline__c < expectedTopDate){
                        expectedTopDate = ms.Deadline__c;
                    }
                }
            }
        }
        System.assertEquals(expectedTotalDate, proj.Next_Project_Milestone_Due_Date__c);
        System.assertEquals(expectedTopDate, proj.Next_Project_Top_Milestone_Due_Date__c);
        
        Id projId = proj.Id;
        
        delete proj;
        
        System.assertEquals(0, [SELECT Id FROM Milestone1_Project__c WHERE Id = :projId].size());
        System.assertEquals(0, [SELECT Id FROM Milestone1_Milestone__c WHERE Project__c = :projId].size());
        
        Test.stopTest();
        
    }
}