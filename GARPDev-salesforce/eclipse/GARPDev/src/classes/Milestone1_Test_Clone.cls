@isTest
private class Milestone1_Test_Clone {

    static testMethod void testProjectClone() {
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
        
        //collect all milestones
        List<Milestone1_Milestone__c> milestones = new List<Milestone1_Milestone__c>();
        milestones.addAll(topMilestones);
        milestones.addAll(subMilestones);
        Map<Id, Milestone1_Milestone__c> milestonesById = new Map<Id, Milestone1_Milestone__c>();
        for(Milestone1_Milestone__c ms : milestones){
            milestonesById.put(ms.Id, ms);
        }
        
        //create tasks linked to milestones
        List<Milestone1_Task__c> tasks = new List<Milestone1_Task__c>();
        for(Integer i = 0; i < NUMBER_OF_TASKS; i++){
            Id parentMilestoneId = milestones[(Math.random() * milestones.size()).intValue()].Id;
            Milestone1_Task__c taskRec = Milestone1_Test_Utility.sampleTask(parentMilestoneId);
            tasks.add(taskRec);
        }
        insert tasks;
        
        //create clone page controller and call clone action
        ApexPages.StandardController stc = new ApexPages.StandardController(proj);
        Milestone1_Clone_Project_Controller cont = new Milestone1_Clone_Project_Controller(stc);
        cont.createClone();
        
        Milestone1_Project__c proj2 = [SELECT Id,
                                              Name,
                                              Deadline__c,
                                              Description__c,
                                              Status__c
                                       FROM Milestone1_Project__c
                                       WHERE ImportID__c = :proj.Id
                                      ];
        System.assertEquals('Copy of ' + proj.Name, proj2.Name);
        System.assertEquals(proj.Deadline__c, proj2.Deadline__c);
        System.assertEquals(proj.Description__c, proj2.Description__c);
        System.assertEquals(proj.Status__c, proj2.Status__c);
        
        List<Milestone1_Milestone__c> milestones2 = [SELECT Id,
                                                            ImportID__c,
                                                            Complete__c,
                                                            Deadline__c,
                                                            Description__c,
                                                            Expense_Budget__c,
                                                            Hours_Budget__c,
                                                            Name,
                                                            OwnerId
                                                     FROM Milestone1_Milestone__c
                                                     WHERE Project__c = :proj2.Id
                                                    ];
        System.assertEquals(NUMBER_OF_MILESTONES, milestones2.size());
        for(Milestone1_Milestone__c clone : milestones2){
            Milestone1_Milestone__c orig = milestonesById.get(clone.ImportID__c);
            System.assertEquals(orig.Complete__c, clone.Complete__c);
            System.assertEquals(orig.Deadline__c, clone.Deadline__c);
            System.assertEquals(orig.Description__c, clone.Description__c);
            System.assertEquals(orig.Expense_Budget__c, clone.Expense_Budget__c);
            System.assertEquals(orig.Hours_Budget__c, clone.Hours_Budget__c);
            System.assertEquals(orig.Name, clone.Name);
        }
        
        List<Milestone1_Task__c> tasks2 = [SELECT Id
                                            FROM Milestone1_Task__c
                                            WHERE Project_Milestone__r.Project__c = :proj2.Id
                                           ];
        System.assertEquals(NUMBER_OF_TASKS, tasks2.size());
    }
    
    static testMethod void testMilestoneClone() {
        final Integer NUMBER_OF_MILESTONES = 5;
        final Integer NUMBER_OF_TASKS = 20;
        final Integer NUMBER_OF_TIMES = 50;
        final Integer NUMBER_OF_EXPENSES = 50;
        
        //create a project
        Milestone1_Project__c proj = new Milestone1_Project__c();
        proj.Name = 'Project';
        insert proj;
        
        //create a top-level milestone
        List<Milestone1_Milestone__c> topMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms2 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms2');
        ms2.Alias__c = 'DCMTEST927';
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
        
        //collect all milestones
        List<Milestone1_Milestone__c> milestones = new List<Milestone1_Milestone__c>();
        milestones.addAll(topMilestones);
        milestones.addAll(subMilestones);
        
        //create tasks linked to milestones
        List<Milestone1_Task__c> tasks = new List<Milestone1_Task__c>();
        for(Integer i = 0; i < NUMBER_OF_TASKS; i++){
            Id parentMilestoneId = milestones[(Math.random() * milestones.size()).intValue()].Id;
            Milestone1_Task__c taskRec = Milestone1_Test_Utility.sampleTask(parentMilestoneId);
            tasks.add(taskRec);
        }
        insert tasks;
        
        //create clone page controller and call clone action
        ApexPages.StandardController stc = new ApexPages.StandardController(ms2);
        Milestone1_Clone_Milestone_Controller cont = new Milestone1_Clone_Milestone_Controller(stc);
        cont.createClone();
        
        Milestone1_Milestone__c ms2Clone = [SELECT Id,
                                                   Name,
                                                   Alias__c
                                            FROM Milestone1_Milestone__c
                                            WHERE ImportID__c = :ms2.Id
                                           ];
        System.assertNotEquals(null, ms2Clone);
        System.assertEquals(null, ms2Clone.Alias__c);
        
        List<Milestone1_Milestone__c> milestones2 = [SELECT Id
                                                     FROM Milestone1_Milestone__c
                                                     WHERE Parent_Milestone__c = :ms2Clone.Id
                                                    ];
        System.assertEquals(3, milestones2.size());
        
        List<Milestone1_Task__c> tasks2 = [SELECT Id
                                            FROM Milestone1_Task__c
                                            WHERE Project_Milestone__c = :ms2Clone.Id
                                            OR Project_Milestone__r.Parent_Milestone__c = :ms2Clone.Id
                                           ];
        System.assertEquals(NUMBER_OF_TASKS, tasks2.size());
    }
}