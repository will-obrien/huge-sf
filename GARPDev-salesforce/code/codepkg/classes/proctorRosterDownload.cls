global class proctorRosterDownload
{

    public proctorRosterDownload() {
    lstwrapper = new List<wrapper>();
    objSite = ApexPages.currentPage().getParameters().get('ID');


    }

    public id objSite{get;set;}
    public string session{get;set;}
    public string procName{get;set;}
    public List<wrapper> lstwrapper {get; set;}
    public List<Exam_Attempt__c> lstExamAttempts{get;set;}
    public List<Exam_Attempt__c> lstFinalEAs{get;set;}
    public List<Site__c> lstExamSite{get;set;}
    public string exam_session {get;set;}
    public integer i {get;set;}
    public string sitecode{get;set;}
    public string name{get; set;}
    public integer slno {get; set;}
    public String sectionDesc {get;set;}
    Public Boolean update1;
    public string rosterExamName {get;set;}
  
      
     global class wrapper implements comparable{
        public string garpId {get; set;}
        global string section {get; set;}
        public string fName{get; set;}
        public string lName{get; set;}
        public string room {get; set;}
        public string seatno{get; set;}
        public decimal candno {get;set;}
        public integer slno {get;set;}
        public string member{get;set;}
        public string minitial {get;set;}
        public string session {get;set;}
        Public String AM {get;set;}
        Public String PM {get;set;}
        
 	global Integer compareTo(Object ObjToCompare) {
            wrapper compareTow = (wrapper)ObjToCompare;
        	if (section == compareTow.section) return 0;
        	if (section > compareTow.section) return 1;
        	return -1;
        }
    }  
    public void getExamAttempts()
    {
  
      
      lstFinalEAs = new List<Exam_Attempt__c>();
      procName = ApexPages.currentPage().getParameters().get('name');
      ProctorRoster__c roster = ProctorRoster__c.getall().values();
      rosterExamName = roster.RosterExamName__c;
      
       lstExamAttempts = [select id, Garp_Id__c,Section__c,Section_Description__c,Seat_No__c, Room__c, Room__r.Name, Member__c, Member__r.Middle_Initial__c, Member__r.Name_As_it_Appears_On_ID__c, Member__r.FirstName, Member__r.LastName, Session__c, Candidate_ID__c from Exam_Attempt__c where Cancelled__c != True and Exam_Site__r.Site__c =: objSite and Defered__c != 'Pending' and Candidate_Commitment__r.Status != 'Draft' ORDER BY Section__c];
       lstExamSite = [select Name, Site_Code__c from Site__c where ID = : objSite ];
       
       if(lstExamSite.size()>0)
       {
           for(Site__c s :lstExamSite)
          {
              sitecode = s.Site_Code__c;
              name = s.Name;
          }
       }
        
        Map<String, Exam_Attempt__c> attempts = new Map<String, Exam_Attempt__c>();
        
        for(Exam_Attempt__c e :lstExamAttempts)
        {
            Exam_Attempt__c existingValue = attempts.get(e.Garp_Id__c);
            
            if (existingValue == null) 
            {
                e.Section_Description__c = e.Section__c;
                attempts.put(e.Garp_Id__c, e);
            }
            else 
            {
                
                                if((E.Garp_Id__c == existingValue.Garp_Id__c) && (E.Section__c != existingValue.Section__c))
                                {
                                    if((E.Section__c == 'FRM Part 1' && existingValue.Section__c == 'FRM Part 2') || (E.Section__c == 'FRM Part 2' && existingValue.Section__c == 'FRM Part 1'))
                                    {
                                        existingValue.Section_Description__c = 'FRM P1&2';
                                        attempts.put(existingValue.garp_id__c, existingValue);
                              
                                    }
                                    
                                    if((E.Section__c == 'ERP Part 1' && existingValue.Section__c == 'ERP Part 2') || (E.Section__c == 'ERP Part 2' && existingValue.Section__c == 'ERP Part 1'))
                                    {
                                        existingValue.Section_Description__c = 'ERP P1&2';
                                        attempts.put(existingValue.garp_id__c, existingValue);
                                      
                                    }
                                }
            	}
        }
        
       // lstFinalEAs.addAll(attempts.values());
    
        
            if(attempts.values().size()>0)
            {
                     i=0;
                      for(Exam_Attempt__c csd :attempts.values())
                      {
                          wrapper w = new wrapper();
                          w.slno = ++i;
                          w.garpId = csd.Garp_Id__c ;
                          w.section = csd.Section_Description__c;
                          w.fName = csd.Member__r.FirstName;
                          w.lName = csd.Member__r.LastName ;
                          w.minitial = csd.Member__r.Middle_Initial__c;
                          w.room = csd.Room__r.name;
                          w.seatno = csd.Seat_No__c;
                          w.candno = csd.Candidate_ID__c;
                          w.member = csd.member__r.Name_As_it_Appears_On_ID__c;
                          w.session = csd.session__c;
                         /* 
                          if(csd.Section_Description__c =='FRM Part 1' || csd.Section_Description__c =='ERP Part 1')
                              w.AM = 'True';
                          else if(csd.Section_Description__c=='FRM Part 2' || csd.Section_Description__c=='ERP Part 2')
                              w.PM = 'True';
                          else if(csd.Section_Description__c == 'FRM P1&2' || csd.Section_Description__c == 'ERP P1&2')
                          {
                              w.AM = 'True';
                              w.PM = 'True';
                          }
                           else if(csd.Section_Description__c == 'ERP')
                          {
                              w.AM = 'True';
                              w.PM = 'True';
                          }
                          */
                          lstwrapper.add(w);               
                      } 
            
            }
        lstwrapper.sort();
    }        
}