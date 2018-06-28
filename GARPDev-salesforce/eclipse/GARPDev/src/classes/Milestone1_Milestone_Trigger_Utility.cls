public class Milestone1_Milestone_Trigger_Utility {
    
    
    public static void handleMilestoneDeleteTrigger(Map<Id, Milestone1_Milestone__c> oldMap){
        //Map<Id, Milestone1_Milestone__c> recMapById = createRecMapById(recs);
        
        //query for list of child milestones that are NOT part of the recs collection
        List<Milestone1_Milestone__c> extraChildren = new List<Milestone1_Milestone__c>();

            extraChildren = [SELECT Id
                             FROM Milestone1_Milestone__c
                             WHERE Parent_Milestone__c IN :oldMap.keySet()
                             AND Id NOT IN :oldMap.keySet()
                            ];

        
        delete extraChildren;
    }
    
    public static void checkMilestoneManualReparent(Map<Id, Milestone1_Milestone__c> oldMap, Map<Id, Milestone1_Milestone__c> newMap){
        Boolean allPassed = true;
        
        for(Milestone1_Milestone__c newRec : newMap.values()){
            Milestone1_Milestone__c oldRec = oldMap.get(newRec.Id);
            if(oldRec.Project__c != newRec.Project__c && newRec.Okay_to_Reparent__c == false){
                allPassed = false;
                newRec.Project__c.addError('Milestones should not be moved to different Projects, except through the "Move to New Project" button in Milestone list view.');
            }
        }
        
        if(allPassed){
            handleMilestoneBeforeTrigger(newMap.values(), newMap);
        }
    }

    public static void handleMilestoneBeforeTrigger(List<Milestone1_Milestone__c> recs, Map<Id, Milestone1_Milestone__c> recMapById){
        //Map<Id, Milestone1_Milestone__c> recMapById = createRecMapById(recs);

        
        //create a map of records by parent milestone ID
        Map<Id, List<Milestone1_Milestone__c>> recMapByParentId = refreshRecordMapByParent(recs);
        
        //ensure parent project IDs for all records
        Set<Id> parentMilestoneIds = new Set<Id>();
        for(Milestone1_Milestone__c rec : recs){
            rec.Okay_to_Reparent__c = false;
            if(rec.Parent_Milestone__c != null){
                parentMilestoneIds.add(rec.Parent_Milestone__c);
            }
        }
        if(parentMilestoneIds.size() > 0){
            List<Milestone1_Milestone__c> parentMilestones = [SELECT Id,
                                                                     Project__c,
                                                                     Parent_Milestone__c
                                                              FROM Milestone1_Milestone__c
                                                              WHERE Id IN :parentMilestoneIds
                                                             ];
            Map<Id, Milestone1_Milestone__c> parentMilestonesMap = new Map<Id, Milestone1_Milestone__c>();
            for(Milestone1_Milestone__c parent : parentMilestones){
                parentMilestonesMap.put(parent.Id, parent);
            }
            for(Milestone1_Milestone__c rec : recs){
                if(rec.Parent_Milestone__c != null){
                    //test to make sure we're not creating any "grandchildren" milestones
                    if(parentMilestonesMap.get(rec.Parent_Milestone__c).Parent_Milestone__c != null){
                        rec.Parent_Milestone__c.addError('Sub-milestones can only go one level deep. Please select a top-level milestone as this record\'s parent milestone.');
                    } else {
                        rec.Project__c = parentMilestonesMap.get(rec.Parent_Milestone__c).Project__c;
                    }
                }
            }
        }
        
        //query for list of child milestones that are NOT part of the recs collection
        List<Milestone1_Milestone__c> extraChildren = new List<Milestone1_Milestone__c>();
        if(recMapById != null && recMapById.size() > 0){
            extraChildren = [SELECT Id,
                                    Name,
                                    Parent_Milestone__c,
                                    Parent_Milestone__r.Name,
                                    Hours_Budget__c,
                                    Expense_Budget__c,
                                    Total_Actual_Hours__c,
                                    Total_Actual_Expense__c,
                                    Total_Estimated_Hours__c,
                                    Total_Estimated_Expense__c,
                                    Total_Open_Tasks__c,
                                    Total_Late_Tasks__c,
                                    Total_Complete_Tasks__c,
                                    Total_Blocked_Tasks__c
                             FROM Milestone1_Milestone__c
                             WHERE Parent_Milestone__c IN :recMapById.keySet()
                             AND Id NOT IN :recMapById.keySet()
                            ];
        }
        
        //map children by their parent milestone ID
        Map<Id, List<Milestone1_Milestone__c>> extraChildrenMap = new Map<Id, List<Milestone1_Milestone__c>>();
        for(Milestone1_Milestone__c extraChild : extraChildren){
            System.debug('*** extra child found: ' + extraChild.Name + ', parent is ' + extraChild.Parent_Milestone__r.Name);
            System.debug('*** child is: ' + extraChild);
            if(extraChildrenMap.get(extraChild.Parent_Milestone__c) == null){
                extraChildrenMap.put(extraChild.Parent_Milestone__c, new List<Milestone1_Milestone__c>());
            }
            extraChildrenMap.get(extraChild.Parent_Milestone__c).add(extraChild);
        }
        
        //query for late tasks
        //TODO do we need this here? Is there a better way to handle this?
        List<Milestone1_Task__c> lateTasks = new List<Milestone1_Task__c>();
        if(recMapById != null && recMapById.size() > 0){
            lateTasks = [SELECT Id,
                                Project_Milestone__c
                         FROM Milestone1_Task__c
                         WHERE Project_Milestone__c IN :recMapById.keySet()
                         AND Complete__c = false
                         AND Due_Date__c < :Date.today()
                        ];
        }
        
        //map late tasks by parent milestone
        Map<Id, List<Milestone1_Task__c>> lateTasksByMilestoneId = new Map<Id, List<Milestone1_Task__c>>();
        for(Milestone1_Task__c lateTask : lateTasks){
            if(lateTasksByMilestoneId.get(lateTask.Project_Milestone__c) == null){
                lateTasksByMilestoneId.put(lateTask.Project_Milestone__c, new List<Milestone1_Task__c>());
            }
            lateTasksByMilestoneId.get(lateTask.Project_Milestone__c).add(lateTask);
        }
        
        //instantiate sets of value helpers, to track new field values
        Map<Id, Milestone1_Milestone_Values_Helper> parentHelpers = new Map<Id, Milestone1_Milestone_Values_Helper>();
        List<Milestone1_Milestone_Values_Helper> selfHelpers = new List<Milestone1_Milestone_Values_Helper>();
        
        //while there are still records in recs, pull out those that are NOT the parent to
        //any other record in recs (in other words, the bottom-most records) and process them
        while(recs.size() > 0){
            List<Milestone1_Milestone__c> topChildren = new List<Milestone1_Milestone__c>();
            List<Milestone1_Milestone__c> bottomChildren = new List<Milestone1_Milestone__c>();
            recMapByParentId = refreshRecordMapByParent(recs);
            
            for(Milestone1_Milestone__c rec : recs){
                if(recMapByParentId.get(rec.Id) == null){
                    //record is not the parent to any other records in our set
                    bottomChildren.add(rec);
                } else {
                    //record is the parent to another record in our set
                    topChildren.add(rec);
                }
            }
            recs = topChildren;
            
            for(Milestone1_Milestone__c rec : bottomChildren){
                
                //update number of late tasks from tasks
                if(lateTasksByMilestoneId.get(rec.Id) == null){
                    rec.Late_Tasks_in_Tasks__c = 0;
                } else {
                    rec.Late_Tasks_in_Tasks__c = lateTasksByMilestoneId.get(rec.Id).size();
                }
                
                if(rec.Parent_Milestone__c != null){
                    if(recMapById!=null&&recMapById.get(rec.Parent_Milestone__c) != null){
                        //record has parent and parent is in our recs list
                        //create helper for parent and add our values to it
                        if(parentHelpers.get(rec.Parent_Milestone__c) == null){
                            parentHelpers.put(rec.Parent_Milestone__c, new Milestone1_Milestone_Values_Helper(recMapById.get(rec.Parent_Milestone__c)));
                        }
                        parentHelpers.get(rec.Parent_Milestone__c).addValuesFromChild(rec);
                    } else {
                        //record has parent, but parent is not in our recs list
                        //create self-helper
                        selfHelpers.add(new Milestone1_Milestone_Values_Helper(rec));
                    }
                } else {
                    //record does not have parent milestone
                    //create self-helper
                    selfHelpers.add(new Milestone1_Milestone_Values_Helper(rec));
                }
            }
        }
        
        List<Milestone1_Milestone_Values_Helper> allHelpers = selfHelpers.clone();
        allHelpers.addAll(parentHelpers.values());
        
        for(Milestone1_Milestone_Values_Helper helper : allHelpers){
            //if the record is the parent to milestones outside of the set we're updating, add their values
            List<Milestone1_Milestone__c> recChildren = extraChildrenMap.get(helper.oldRecord.Id);
            if(recChildren != null){
                for(Milestone1_Milestone__c extraChild : recChildren){
                    helper.addValuesFromChild(extraChild);
                }
            }
            
            //overwrite old values with new
            helper.updateOldWithNew();
        }
    }
    

    
    //TODO do we need this or could we be using oldMap / newMap?
    /*
    private static Map<Id, Milestone1_Milestone__c> createRecMapById(List<Milestone1_Milestone__c> recs){
        //create a map of records by ID
        Map<Id, Milestone1_Milestone__c> recMapById = new Map<Id, Milestone1_Milestone__c>();
        for(Milestone1_Milestone__c rec : recs){
            System.debug('*** Milestone "' + rec.Name + '" with Id ' + rec.Id + ' begin after trigger');
            if(rec.Id != null){
                recMapById.put(rec.Id, rec);
            }
        }
        return recMapById;
    }
    */
    
    public static void handleMilestoneAfterTrigger(Map<Id, Milestone1_Milestone__c> recs){
        updateParents(recs);
    }
    
    private static void updateParents(Map<Id, Milestone1_Milestone__c> recMapById){
        //Map<Id, Milestone1_Milestone__c> recMapById = createRecMapById(recs);
        
        //instantiate sets of parent IDs, to be updated afterward
        Set<Id> milestoneUpdateSet = new Set<Id>();
        Set<Id> projectUpdateSet = new Set<Id>();
        
        for(Milestone1_Milestone__c rec : recMapById.values()){
            if(rec.Parent_Milestone__c != null){
                if(recMapById.get(rec.Parent_Milestone__c) != null){
                    //record has parent and parent is in our recs list
                    //do nothing, as the parent has already been updated
                } else {
                    //record has parent, but parent is not in our recs list
                    //mark parent milestone to be updated
                    milestoneUpdateSet.add(rec.Parent_Milestone__c);
                    System.debug('*** added parent ' + rec.Parent_Milestone__c + ' to list of milestones to update (child: ' + rec.Name + ')');
                }
            } else {
                //record does not have parent milestone
                //mark parent project to be updated
                projectUpdateSet.add(rec.Project__c);
            }
        }
        
        if(milestoneUpdateSet.size() > 0){
            updateMilestones(milestoneUpdateSet);
        }
        //TODO force projects to go out and true themselves up, top down style
        if(projectUpdateSet.size() > 0){
            updateProjects(projectUpdateSet);
        }
    }
    
    //create a map of records by parent milestone ID
    private static Map<Id, List<Milestone1_Milestone__c>> refreshRecordMapByParent(List<Milestone1_Milestone__c> recs){
        Map<Id, List<Milestone1_Milestone__c>> recMapByParentId = new Map<Id, List<Milestone1_Milestone__c>>();
        for(Milestone1_Milestone__c rec : recs){
            if(rec.Parent_Milestone__c != null){
                if(recMapByParentId.get(rec.Parent_Milestone__c) == null){
                    recMapByParentId.put(rec.Parent_Milestone__c, new List<Milestone1_Milestone__c>());
                }
                recMapByParentId.get(rec.Parent_Milestone__c).add(rec);
            }
        }
        return recMapByParentId;
    }
    
    //call an update to any parent milestones that weren't part of our trigger set

    private static void updateMilestones(Set<Id> idSet) {
        update [SELECT Id FROM Milestone1_Milestone__c WHERE Id IN :idSet];
    }
    
    //call an update to any parent projects
    private static void updateProjects(Set<Id> idSet) {
        update [SELECT Id FROM Milestone1_Project__c WHERE Id IN :idSet];
    }

}