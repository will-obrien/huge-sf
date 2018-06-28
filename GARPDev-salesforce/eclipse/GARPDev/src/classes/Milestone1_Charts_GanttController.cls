public with sharing class Milestone1_Charts_GanttController {

    public String mytarget {get; set;}
    
    public String getProjectGanttJson() {
        
        List<Milestone1_Milestone__c> milestones = [Select Id, Name, NameClean__c, Kickoff__c, Deadline__c,
            Complete__c
            FROM Milestone1_Milestone__c WHERE Project__c = :mytarget order by Name];

        String ret = 'var ganttData' +mytarget + ' = [{id: 1, name: "", series: [';
        
        Boolean addComma=false;
        for (Milestone1_Milestone__c current: milestones) { 
            if (addComma) { ret += ','; }
            
            String color='#2299bb';
            
            if (current.complete__c) {
                color='#333333';
            } else if (current.Deadline__c < Date.today()) {
                color='#ee3322';
            } else if (current.Kickoff__c > Date.today()) {
                color='#666666'; 
            }
            
            
            ret += '{name: "'+current.NameClean__c+'", start: new Date(' +
                current.Kickoff__c.year() +',' + (Integer.valueOf(current.Kickoff__c.month())-1) +',' + current.Kickoff__c.day() +'), end: new Date(' + 
                current.Deadline__c.year() +',' + (Integer.valueOf(current.Deadline__c.month())-1) + ',' + current.Deadline__c.day() +'), ' +
                'color: "' + color + '"}';
            addComma=true;
            
        }
        
        ret+=']}];';            
        
        return ret;
        
    }
    
    static testMethod void TestProjectJson() {
        Milestone1_Project__c p1 = Milestone1_Test_Utility.sampleProjectActive('Json');
        insert p1;
        Milestone1_Milestone__c m1 = Milestone1_Test_Utility.sampleMilestone(p1);
        insert m1;
        
        Milestone1_Charts_GanttController cls = new Milestone1_Charts_GanttController();
        cls.mytarget = p1.id;
        
        String ret = cls.getProjectGanttJson();
        
        System.assert(ret.indexOf('ganttData') > -1);
        System.assert(ret.indexOf(m1.Name) > -1);    
    
        m1.Complete__c = true;
        update m1;
    
        Milestone1_Milestone__c m2 = Milestone1_Test_Utility.sampleMilestone(p1);
        m2.Deadline__c = Date.today()-1;
        insert m2;    
        
        Milestone1_Milestone__c m3 = Milestone1_Test_Utility.sampleMilestone(p1);
        m3.Kickoff__c = Date.today()+1;
        insert m3;            
    
        ret = cls.getProjectGanttJson();
        
        System.assert(ret.indexOf('333333') > -1);
        System.assert(ret.indexOf('ee3322') > -1);
        System.assert(ret.indexOf('666666') > -1);
    }
    
}