public with sharing class DE_Applicants{

public List<Applicant__c> alist {get;set;}

public List<Applicant__c> blist {get;set;}
public List<Applicant__c> clist {get;set;}


public List<ApplicantDisplayModel> applicants {get;set;}

public DE_Applicants(){

    alist= [Select Id,phoneformat__c,Applicant_Name__c,Phone__c,Email__c, photo_url__c,Photo__c,Job_Opening__c, Job_Opening__r.Name From Applicant__c where Job_Opening__r.Name='Sales Manager' ORDER BY Job_Opening__c ASC];    

    blist= [Select Id,phoneformat__c,Applicant_Name__c,Phone__c,Email__c, photo_url__c,Photo__c,Job_Opening__c, Job_Opening__r.Name From Applicant__c where Job_Opening__r.Name='Sales Engineer' ORDER BY Job_Opening__c ASC];    
    clist= [Select Id,phoneformat__c,Applicant_Name__c,Phone__c,Email__c, photo_url__c,Photo__c,Job_Opening__c, Job_Opening__r.Name From Applicant__c where Job_Opening__r.Name='IT Director' ORDER BY Job_Opening__c ASC];    


    
    applicants = new List<ApplicantDisplayModel>();
    if(alist !=null && alist.size() > 0){
        for(Applicant__c a:alist){ applicants.add(new ApplicantDisplayModel(a));}
    }    
}

public class ApplicantDisplayModel {
        public String job   { get; private set; }
        public String name  { get; private set; }
        public String phone { get; private set; }
        Public String email { get; private set; }
        public String photo { get; private set; }
        public String id    { get; private set; }
        
        
        public ApplicantDisplayModel(Applicant__c a) {
            name = a.Applicant_Name__c;
            phone = a.phone__c;
            email = a.email__c;
            id = a.id;
            job = a.Job_Opening__r.Name;
            photo = a.photo_url__c;
        }
    }

}