public class siteSeatChart {
   
    private final Site__c site;
    public string header{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    public class wrapper{
        public string SFid {get; set;}
        public string GARPid {get; set;}
        public string FirstName {get; set;}
        public string MiddleInitial {get; set;}
        public string LastName {get; set;}
        public string Exam {get; set;}
        public string Section {get; set;}
        public string Seat {get; set;}
    }
   
    public string Filetype{get;set;}
    public boolean isExcel {get;set;}
    public boolean isCsv {get;set;}   
 
    public siteSeatChart(ApexPages.StandardController stdcontroller){
            this.site = (Site__c)stdController.getRecord();
            Filetype = '';
            lstwrapper = new List<wrapper>();
            header = 'SFid,GARP ID,First Name, Middle Initial, Last Name, Exam, Section, Seat';    //  \r\n   
                          
    }
 
   
    public void getEAList(){
          // Get the ExamSiteIDs associated with this site
          set<id> examSiteIDs = new set<id>  () ;
          for ( Exam_Sites__c s : [ SELECT id FROM Exam_Sites__c WHERE Site__c = : site.id ] ) examSiteIDs.add(s.id) ; 
          system.debug('examSiteIDs :'+examSiteIDs);
          // Get the EA's for this site
          list<Exam_Attempt__c> EAs2Send = [ 
            SELECT id, member__r.firstName, member__r.Middle_Initial__c, member__r.lastName, member__r.GARP_ID__c,
            exam_site__r.exam__r.name, Seating_Section__c, Seat_No__c  
            FROM Exam_Attempt__c 
            WHERE Exam_Site__c IN :examSiteIDs
            ORDER BY exam_site__r.exam__r.name, member__r.lastName,  member__r.firstName ASC 
            LIMIT 3000 ] ;
          system.debug('EAs2Send :'+EAs2Send);
          if(EAs2Send.size()>0){
              for(Exam_Attempt__c eaItem : EAs2Send ){
                  wrapper w = new wrapper();
                  w.SFid = eaItem.id ;
                  w.GARPid = eaItem.member__r.GARP_ID__c ;
                  w.FirstName = eaItem.member__r.firstName ;
                  w.MiddleInitial = eaItem.member__r.Middle_Initial__c ;
                  w.LastName = eaItem.member__r.lastName ;
                  w.Exam = eaItem.exam_site__r.exam__r.name ;
                  w.Section = eaItem.Seating_Section__c ;
                  w.seat = eaItem.Seat_No__c ;
                  lstwrapper.add(w);               
              }             
          }
          system.debug('lstwrapper :'+lstwrapper.size());
    }
 
public string getJSONExport() {
    
    String str = JSON.serialize(lstwrapper); 
    return str ;
  }     
 
}