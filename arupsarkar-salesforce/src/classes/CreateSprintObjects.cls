public without sharing class CreateSprintObjects{

    /*
    private static List<Team_Member__c> teamMemberList;
    private static List<Team_Member__c> teamMemberProductOwnerList;
    private static List<Team_Member__c> teamMemberScrumMasterList;
    private static List<Team_Member__c> teamMemberDevelopersList;    
    private static List<AgileProject__c> agileProjectList;
    private static List<Product_Backlog_Item__c> pbiList;
    private static List<Development_Team__c> devTeamList;
    private static List<Development_Team_Member__c> devTeamMemberList;
    private static List<Sprint__c> sprintList;
    private static List<Sprint_Task__c> sprintTaskList;
    
    public CreateSprintObjects(){
        //initialize team members and subsequently create them
        teamMemberList = new List<Team_Member__c>();
        teamMemberProductOwnerList = new List<Team_Member__c>();
        teamMemberScrumMasterList = new List<Team_Member__c>();
        teamMemberDevelopersList = new List<Team_Member__c>();
        
        teamMemberProductOwnerList = TeamMember('Product Owner');
        teamMemberScrumMasterList = TeamMember('Scrum Master');
        teamMemberDevelopersList = TeamMember('Developer');
        
        
        agileProjectList = new List<AgileProject__c>();
        pbiList = new List<Product_Backlog_Item__c>();   
        devTeamList = new List<Development_Team__c>();        
        devTeamMemberList = new List<Development_Team_Member__c>();
        sprintList = new List<Sprint__c>();
        sprintTaskList = new List<Sprint_Task__c>();
    }
    
    
    public List<Team_Member__c> TeamMember(string type){
        try{
            //create a developers
            Team_Member__c teamMember = new Team_Member__c();
            
            if(type == 'Developer'){
                string RandomName = String.valueOf(Math.random());
                teamMember.Name = RandomName + ' Last Name';
                teamMember.First_Name__c = RandomName + ' First Name';
                teamMember.Email__c = 'dev1@sprintproject.com';
                teamMember.Active__c = true;
                insert teamMember;
                teamMemberList.add(teamMember);
                System.debug('~~~~~~~~ Developer 1 Id : ' + teamMember.Id);                
            }else if(type == 'Scrum Master'){
                //create a scrum Master
                teamMember = new Team_Member__c();
                teamMember.Name = 'SM1 Last Name';
                teamMember.First_Name__c = 'SM1 First Name';
                teamMember.Email__c = 'SM1@sprintproject.com';
                teamMember.Active__c = true;
                insert teamMember;
                teamMemberList.add(teamMember);
                System.debug('~~~~~~~~ SM 1 Id : ' + teamMember.Id);                
            }else if(type == 'Product Owner'){
                //create a project owner
                teamMember = new Team_Member__c();
                teamMember.Name = 'PO1 Last Name';
                teamMember.First_Name__c = 'PO1 First Name';
                teamMember.Email__c = 'PO1@sprintproject.com';
                teamMember.Active__c = true;
                insert teamMember;
                teamMemberList.add(teamMember);
                System.debug('~~~~~~~~ PO 1 Id : ' + teamMember.Id);                            
            }

        }catch(Exception e){
            System.debug('~~~~~~~~~~CreateSprintObjects:TeamMember() ' + e.getMessage());            
        }
        return teamMemberList;
    }
    
    public List<AgileProject__c> Project(){
        
        try{
            
            //create a new Agile Project            
            AgileProject__c agileProj = new AgileProject__c();
            agileProj.Name = 'Test Agile Project 1';
            agileProj.Description__c = 'Test description of agile project';
            agileProj.Scrum_Master__c = teamMemberScrumMasterList[0].Id;
            agileProj.Product_Owner__c = teamMemberProductOwnerList[0].Id;
            agileProj.Start_Date__c = Date.today();
            agileProj.End_Date__c = Date.today() + 30;
            agileProj.Status__c = 'Open';
            insert agileProj;
            System.debug('~~~~~~~ Agile Project Id : ' + agileProj.Id);
            agileProjectList.add(agileProj);
        }catch(Exception e){
            System.debug('~~~~~~~~~~CreateSprintObjects:Project() ' + e.getMessage());
        }
        return agileProjectList;
    }
    
    public List<Product_Backlog_Item__c> ProductBackLog(){

 
        try{
            List<AgileProject__c> ap = agileProjectList;
            System.debug('~~~~~~~~~~~~~ Agile project id in Product backlog : ' + ap[0].id);
            Product_Backlog_Item__c pbiObj = new Product_Backlog_Item__c();
            pbiObj.ProductBacklog__c = ap[0].id;
            pbiObj.Name__c = 'PB1';
            pbiObj.Priority__c = '1';
            //pbiObj.Estimation__c = 20;
            pbiObj.Acceptance_Criteria__c = 'test accpetance criteria';
            pbiObj.User_Story__c = 'Test user story';
            pbiObj.Value__c = '5';
            insert pbiObj;
            System.debug('~~~~~~~~~~ Product backlog item Id : ' + pbiObj.Id);
            pbiList.add(pbiObj);
        }catch(Exception e){
            System.debug('~~~~~~~~~~~ CreateSprintObejcts : ProductBacklog : ' + e);
        }
        return pbiList;
    }
    
    public List<Development_Team__c> DevelopmentTeam()
    {
 
        
        try{
            List<Product_Backlog_Item__c> pbi = pbiList;
            Development_Team__c devTeamObj = new Development_Team__c();
            devTeamObj.Product_Backlog_Item__c = pbi[0].Id;
            devTeamObj.Name = 'Dev team Test';
            insert devTeamObj;
            devTeamList.add(devTeamObj);
        }catch(Exception e){
            System.debug('~~~~~~~~ CreateSprintObjects : DevelopmentTeam - ' + e);
        }
        return devTeamList;
           
    }



   public List<Development_Team_Member__c> DevelopmentTeamMember()
    {
        try{
            List<Development_Team__c> pbi = devTeamList;
            Development_Team_Member__c devTeamMemberObj = new Development_Team_Member__c();
            devTeamMemberObj.Development_Team__c = devTeamList[0].Id;
            devTeamMemberObj.Team_Member__c = teamMemberDevelopersList[0].Id;
            devTeamMemberObj.Role__c = 'Developer';
            insert devTeamMemberObj;
            devTeamMemberList.add( devTeamMemberObj);
        }catch(Exception e){
            System.debug('~~~~~~~~ CreateSprintObjects : DevelopmentTeamMember - ' + e);
        }
        return devTeamMemberList;
    }


    public List<Sprint__c> Sprint(){
        try{
            List<Product_Backlog_Item__c> pbi = pbiList;
            Sprint__c sprintObj = new Sprint__c();
            sprintObj.ProductBackLogItem__c = pbiList[0].Id;
            sprintObj.Start_Date__c = Date.Today() - 7;
            sprintObj.End_Date__c = Date.Today() + 1;
            sprintObj.Status__c = 'In Progress';
            sprintObj.Sprint_Planning__c = 'Draft';
            
            insert sprintObj;
            sprintList.add(sprintObj);
            
            //update sprint object to Final
            sprintObj.Sprint_Planning__c = 'Final';
            sprintObj.kavayah__Status__c = 'Open';
            update sprintObj;
            sprintList.add(sprintObj);

        }catch(Exception e){
            System.debug('~~~~~~~~ CreateSprintObjects : Sprint - ' + e);
        }
        return sprintList;    
    }
    
    public List<Sprint_Task__c> SprintTask(){
     
        try{
            Sprint_Task__c sprintTaskObj = new Sprint_Task__c();
            sprintTaskObj.SprintTask__c = sprintList[0].Id;
            sprintTaskObj.Estimation__c = 40;
            sprintTaskObj.Remaining__c = 40;
            sprintTaskObj.Description__c = 'Sprint Task Description';
            sprintTaskObj.Name = 'Sprint Task Name';
            sprintTaskObj.Story_Points__c = 25;
            sprintTaskObj.Team_Member__c = teamMemberDevelopersList[0].Id;
            sprintTaskObj.State__c = 'Development';
            
            insert sprintTaskObj;
            
             sprintTaskList.add(sprintTaskObj);
             
             sprintTaskObj.Remaining__c = 20;
             update sprintTaskObj;
            
             sprintTaskObj.kavayah__Remaining__c = 0;
			 update sprintTaskObj;            
            
        }catch(Exception e){
            System.debug('~~~~~~~~ CreateSprintObjects : Sprint Task List - ' + e);            
        }
        return sprintTaskList;
    }
 	*/   
}