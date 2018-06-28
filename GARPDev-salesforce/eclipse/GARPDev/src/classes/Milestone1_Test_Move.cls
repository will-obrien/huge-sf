@isTest
private class Milestone1_Test_Move {

    static testMethod void testMilestoneMove() {
        final Integer NUMBER_OF_MILESTONES = 5;
        final Integer NUMBER_OF_TASKS = 20;
        final Integer NUMBER_OF_TIMES = 50;
        final Integer NUMBER_OF_EXPENSES = 50;
        
        //create two projects
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        Milestone1_Project__c proj2 = Milestone1_Test_Utility.sampleProject('proj2');
        insert proj;
        insert proj2;
        
        //create a couple of top-level milestones
        List<Milestone1_Milestone__c> topMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        topMilestones.add(ms1);
        Milestone1_Milestone__c ms2 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms2');
        topMilestones.add(ms2);
        insert topMilestones;
        
        //create a few sub-milestones underneath ms1 and ms2
        List<Milestone1_Milestone__c> subMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms3 = Milestone1_Test_Utility.sampleMilestone(null, ms1.Id, 'ms3');
        subMilestones.add(ms3);
        Milestone1_Milestone__c ms4 = Milestone1_Test_Utility.sampleMilestone(null, ms2.Id, 'ms4');
        subMilestones.add(ms4);
        Milestone1_Milestone__c ms5 = Milestone1_Test_Utility.sampleMilestone(null, ms2.Id, 'ms5');
        subMilestones.add(ms5);
        insert subMilestones;
        
        //collect all milestones that will be moved
        List<Milestone1_Milestone__c> milestonesToMove = new List<Milestone1_Milestone__c>();
        milestonesToMove.add(ms2);
        milestonesToMove.add(ms3);
        
        //create move page controller and call move action
        ApexPages.StandardSetController stc = new ApexPages.StandardSetController(milestonesToMove);
        stc.setSelected(milestonesToMove);
        Milestone1_Move_Milestone_Extension cont = new Milestone1_Move_Milestone_Extension(stc);
        cont.dummyMS.Project__c = proj2.Id;
        cont.moveMilestones();
        
        List<Milestone1_Milestone__c> milestones2 = [SELECT Id,
                                                            Name
                                                     FROM Milestone1_Milestone__c
                                                     WHERE Project__c = :proj2.Id
                                                    ];
        
        System.assertEquals(4, milestones2.size());
        
        milestones2[0].Project__c = proj.Id;
        Boolean errorOccured = false;
        try{
            update milestones2[0];
        } catch (DMLException e){
            errorOccured = true;
        } finally {
            System.assert(errorOccured);
        }
    }
    
    static testMethod void testMilestoneMoveDetail() {
        final Integer NUMBER_OF_MILESTONES = 1;
        final Integer NUMBER_OF_TASKS = 20;
        final Integer NUMBER_OF_TIMES = 50;
        final Integer NUMBER_OF_EXPENSES = 50;
        
        //create two projects
        Milestone1_Project__c proj = Milestone1_Test_Utility.sampleProject('proj');
        Milestone1_Project__c proj2 = Milestone1_Test_Utility.sampleProject('proj2');
        insert proj;
        insert proj2;
        
        //create a couple of top-level milestones
        List<Milestone1_Milestone__c> topMilestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        topMilestones.add(ms1);
        insert topMilestones;
             
        //create move page controller and call move action
        ApexPages.StandardController stc = new ApexPages.StandardController(ms1);
        Milestone1_Move_Milestone_Extension cont = new Milestone1_Move_Milestone_Extension(stc);
        cont.dummyMS.Project__c = proj2.Id;
        cont.moveMilestones();
        
        List<Milestone1_Milestone__c> milestones2 = [SELECT Id,
                                                            Name
                                                     FROM Milestone1_Milestone__c
                                                     WHERE Project__c = :proj2.Id
                                                    ];
        
        System.assertEquals(1, milestones2.size());
        
        milestones2[0].Project__c = proj.Id;
        Boolean errorOccured = false;
        try{
            update milestones2[0];
        } catch (DMLException e){
            errorOccured = true;
        } finally {
            System.assert(errorOccured);
        }
    }
    
    static testMethod void testTaskMoveFromList() {
        //create a project
        Milestone1_Project__c proj = new Milestone1_Project__c();
        proj.Name = 'Project';
        insert proj;
        
        //create a couple of milestones
        List<Milestone1_Milestone__c> milestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        milestones.add(ms1);
        Milestone1_Milestone__c ms2 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms2');
        milestones.add(ms2);
        insert milestones;

        //create a couple of tasks
        List<Milestone1_Task__c> tasks = new List<Milestone1_Task__c>();
        Milestone1_Task__c task1 = Milestone1_Test_Utility.sampleTask(ms1.Id);
        tasks.add(task1);
        Milestone1_Task__c task2 = Milestone1_Test_Utility.sampleTask(ms1.Id);
        tasks.add(task2);
        insert tasks;
        
        //create a time record for task1
        Milestone1_Time__c time1 = Milestone1_Test_Utility.sampleTime(task1.Id);
        insert time1;
        
        List<Milestone1_Task__c> tasksToMove = new List<Milestone1_Task__c>();
        tasksToMove.add(task1);
        
        //create move page controller and ensure that task1 can't be moved
        ApexPages.StandardSetController stc = new ApexPages.StandardSetController(tasksToMove);
        stc.setSelected(tasksToMove);
        Milestone1_Move_Task_Extension cont = new Milestone1_Move_Task_Extension(stc);
        System.assert(cont.hasChildren);
        
        tasksToMove.clear();
        tasksToMove.add(task2);
        
        //create a log record for task2
        Milestone1_Log__c log = new Milestone1_Log__c();
        log.Project__c = proj.Id;
        log.Project_Task__c = task2.Id;
        insert log;
        
        //recreate move page controller and call move action
        stc = new ApexPages.StandardSetController(tasksToMove);
        stc.setSelected(tasksToMove);
        cont = new Milestone1_Move_Task_Extension(stc);
        cont.dummyTask.Project_Milestone__c = ms2.Id;
        cont.moveTasks();
        
        //load clone back and make sure it exists
        List<Milestone1_Task__c> tasks2 = [SELECT Id,
                                                  Name
                                           FROM Milestone1_Task__c
                                           WHERE Project_Milestone__c = :ms2.Id
                                          ];
        
        System.assertEquals(1, tasks2.size());
        
        //load log back and make sure it points to clone,not original
        log = [SELECT Id FROM Milestone1_Log__c WHERE Project_Task__c = :tasks2[0].Id];
        System.assertNotEquals(null, log);
        
    }
    
    static testMethod void testTaskMove() {
        //create a project
        Milestone1_Project__c proj = new Milestone1_Project__c();
        proj.Name = 'Project';
        insert proj;
        
        //create a couple of milestones
        List<Milestone1_Milestone__c> milestones = new List<Milestone1_Milestone__c>();
        Milestone1_Milestone__c ms1 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms1');
        milestones.add(ms1);
        Milestone1_Milestone__c ms2 = Milestone1_Test_Utility.sampleMilestone(proj.Id, null, 'ms2');
        milestones.add(ms2);
        insert milestones;

        //create a couple of tasks
        List<Milestone1_Task__c> tasks = new List<Milestone1_Task__c>();
        Milestone1_Task__c task1 = Milestone1_Test_Utility.sampleTask(ms1.Id);
        insert task1;
        
        //create a time record for task1
        Milestone1_Time__c time1 = Milestone1_Test_Utility.sampleTime(task1.Id);
        insert time1;
        
        //create move page controller and ensure that task1 can't be moved
        ApexPages.StandardController stc = new ApexPages.StandardController(task1);
        Milestone1_Move_Task_Extension cont = new Milestone1_Move_Task_Extension(stc);
        System.assert(cont.hasChildren);
        
        //create a log record for task2
        Milestone1_Log__c log = new Milestone1_Log__c();
        log.Project__c = proj.Id;
        log.Project_Task__c = task1.Id;
        insert log;
        
        //recreate move page controller and call move action
        stc = new ApexPages.StandardController(task1);
        cont = new Milestone1_Move_Task_Extension(stc);
        cont.dummyTask.Project_Milestone__c = ms2.Id;
        cont.moveTasks();
        
        //load clone back and make sure it exists
        List<Milestone1_Task__c> tasks2 = [SELECT Id,
                                                  Name
                                           FROM Milestone1_Task__c
                                           WHERE Project_Milestone__c = :ms2.Id
                                          ];
        
        System.assertEquals(1, tasks2.size());
        
        //load log back and make sure it points to clone,not original
        log = [SELECT Id FROM Milestone1_Log__c WHERE Project_Task__c = :tasks2[0].Id];
        System.assertNotEquals(null, log);
        
    }

}