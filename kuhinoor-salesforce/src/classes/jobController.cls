/*
    Controller : jobController 
    Date       : 
    Author     :
    Description: 
*/
public Class jobController{

    public List<JobModel> jobsMdlList{get;set;}
    Public id ids;
    Public lightingprefix__jobpost__c jb{get;set;}
    Public List<lightingprefix__jobpost__c> joblist{get;set;}   
    Public lightingprefix__Job_Application__c jobApplicant{get;set;}
    Public String applicationdisable{get;set;}
    Public List<lightingprefix__Job_Application__c> applicationList;
    public set<String> applicantIds;
    public set<String> contactIds;
    Public String paramId{get;set;}
    
    Public Attachment ObjAttch{get;set;}
    Public blob resume{get;set;}
    Public string contentType{get;set;}
    Public String fileName{get;set;}
    
    //----------Constructor method------------
    public jobController(){           
        /* applicantIds = new set<String>();
        contactIds =  new set<String>();
        jobsMdlList = new List<JobModel>();
        
        joblist = [SELECT id,Name,lightingprefix__No_of_Post__c, lightingprefix__Start_Date__c, lightingprefix__Expire_Date__c, lightingprefix__No_of_Applicants__c, lightingprefix__Skills_Required__c, lightingprefix__Qualifications__c, lightingprefix__Experience__c, lightingprefix__Descriptions__c FROM lightingprefix__jobpost__c where  lightingprefix__Status__c ='open' limit 10];        
        applicationList =[SELECT Id,lightingprefix__Job__c,lightingprefix__Applicant_Name__c FROM lightingprefix__Job_Application__c];
         
         user uconId=[select contactId,firstname,lastname from user where id=:UserInfo.getUserId()];
         List<lightingprefix__Job_Application__c> ApplicantstatList =[SELECT Id,lightingprefix__Job__c,lightingprefix__Status__c,lightingprefix__Applicant_Name__c FROM lightingprefix__Job_Application__c];        
       
        //--- loop for fill Set-----
        for(lightingprefix__Job_Application__c  val : applicationList){
            applicantIds.add(val.lightingprefix__Job__c);
            contactIds.add(val.lightingprefix__Applicant_Name__c);
        }
       
        //---Query to get contactId of current user----
        user u=[select contactId,firstname,lastname from user where id=:UserInfo.getUserId()];
        System.debug('*************'+u.id+'*************'+u.contactId+'********'+u.lastname);    
        
            
       
        for(jobpost__c obj : joblist){          
            JobModel jbm = new JobModel();
            jbm.jobObj=obj;
            if(applicantIds.contains(obj.id) && contactIds.contains(u.contactId)){
                jbm.disable = true;
               
            }
            jobsMdlList.add(jbm);    
        }    */
    }  
    
    //-------- apply method--------      
    Public pageReference  Apply(){
        if(userInfo.getUserType()=='Guest'){
            return new pageReference('/login');
        }else{
            return new pageReference('/Application?id='+paramId);
        }
    } 
    
    //--- Get (job id) parameter from URL--------
    public void fetchParameter(){
        jb = new lightingprefix__jobpost__c();
        ids=ApexPages.currentPage().getParameters().get('id');
        jb= [select name from jobpost__c where id=: ids];        
    }
    
    //-------- save method is used to submit application form------
    public void save(){
       savepoint sp = Database.setSavepoint();
       try{          
            jobsMdlList.clear();     
            user u=[select contactId,firstname,lastname from user where id=: UserInfo.getUserId()];
            jobApplicant = new lightingprefix__Job_Application__c();
            jobApplicant.lightingprefix__Applicant_Name__c= u.contactId;
            jobApplicant.lightingprefix__Job__c= jb.id;           
           // jobApplicant.lightingprefix__Apply_Date__c=Date.Today();
            jobApplicant.recordTypeId= Schema.SObjectType.lightingprefix__Job_Application__c.getRecordTypeInfosByName().get('Submitted').getRecordTypeId();
            insert jobApplicant; 
            
            //---  Attachment insert method ----
            Attachment att = new Attachment();
            att.body = resume;
            att.contentType = contentType;
            att.name = fileName;
            att.parentId = jobApplicant.id;
            insert att;
            
            /*ObjAttch = new Attachment();
            ObjAttch.parentId = jobApplicant.id;
            insert ObjAttch;*/
                       
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Sucessfully to apply..'));
            
        }catch(Exception e){
            //---Rollback the database ----
            Database.RollBack(sp);
            
            //---Add the error to the page---
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getmessage()));
            
        } 
       
    }
    
    //----- method for job Applicant details------   
     public void jobApplicantDetails(){
       /*   String  jobids = apexPages.currentpage().getParameters().get('id');  
          list<lightingprefix__jobpost__c> jobs = [SELECT id,Name,lightingprefix__No_of_Post__c, lightingprefix__Start_Date__c, lightingprefix__Expire_Date__c, lightingprefix__No_of_Applicants__c, lightingprefix__Skills_Required__c, lightingprefix__Qualifications__c, lightingprefix__Experience__c, lightingprefix__Descriptions__c FROM lightingprefix__jobpost__c where id=:jobids];        
          list<lightingprefix__Job_Application__c> applications =[SELECT Id,lightingprefix__Job__c,lightingprefix__Applicant_Name__c FROM lightingprefix__Job_Application__c];
          */
     } 
    
    //-----wrapper class------
    public class JobModel{
        public jobpost__c jobObj{get;set;}
        public Boolean disable{get;set;}
        public String status{get;set;}
        public JobModel(){
            jobObj = new jobpost__c();
          //  statusList = new lightingprefix__Job_Application__c();
        }        
   }
}