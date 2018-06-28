public class InvoiceView {
    public Boolean showRecords{get;set;}
    public List<Content__c> cust {get;set;}
    public Content__c startDate {get;set;}
    public Content__c endDate {get;set;}
    public Content__c genHTML {get;set;}
    
    public Exam_Attempt__c ea {get;set;}
    
    public Opportunity opp {get;set;}
    public Contact cont {get;set;}
    public Account acct {get;set;}
    
    public String processStatus {get;set;}
        
    
    //In constructor
    
    public InvoiceView() {
        ea = new Exam_Attempt__c();
        showRecords =false; 
        startDate = new Content__c();        
        endDate = new Content__c();
        genHTML = new Content__c();
        genHTML.Story__c = '';
        processStatus = 'Init';
    }
    
    
    public void fetchRecords(){
        
        if(ea.Opportunity__c == null) {
            processStatus = 'Cannot select opp!';
        } else {        
            processStatus = 'All good!';
            
            List<Opportunity> lstOpp = [select Id, Name, AccountId from Opportunity where Id = :ea.Opportunity__c];
            if(lstOpp != null && lstOpp.size() > 0) {
                opp = lstOpp[0];
            }

            List<Account> lstAcct = [select Id, Name from Account where Id = :opp.AccountId];
            if(lstAcct != null && lstAcct.size() > 0) {
                acct = lstAcct[0];
            }
            
            // select from Contact where AccountId = :acct.id

        }        
        //system.debug('* * * fetch ...'+ startDate.Published_Date__c);
        //cust = [Select Id, Name, Description__c, Status__c, Content_Type__c, Is_On_Demand__c, Published_Date__c, Topic__c, Credit__c from Content__c where Credit__c > 0 and Published_Date__c >= :startDate.Published_Date__c  and Published_Date__c <= :endDate.Published_Date__c limit 1000];
        
        showRecords = true;
    }    

    public void Publish(){
        List<Content__c> selContent = new List<Content__c>();
        
        String templateString = '<tr><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:black"><ahref="http://iz3.me/76Ap1zxV0RC1" target="_blank"><b><spanstyle="color:#111111">{0}</span></b></a> <br><span class=MsoHyperlink><span style="color:#111111;text-decoration:none">{1}</span></span></span><o:p></o:p></p></td><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:black">{2}</span><o:p></o:p></p></td><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:black">{3}</span><o:p></o:p></p></td><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal align=center style="text-align:center"><b><spanstyle="font-size:9.0pt;font-family:"Arial","sans-serif";color:#081A31">{4}</span></b><o:p></o:p></p></td></tr>';
        
        // 0 = URL, 1 = Name, 2 = Desc
        
        genHTML.Story__c = '<table class=MsoNormalTable border=0 cellpadding=0 width="100%" style="width:100.0%"><tr><td colspan=4 valign=top style="background:#091B30;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal align=center style="text-align:center"><b><spanstyle="font-size:10.5pt;font-family:"Arial","sans-serif";color:white">CPE CREDIT OPPORTUNITIES</span></b><o:p></o:p></p></td></tr><tr><td width="41%" valign=top style="width:41.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Title</span></b><o:p></o:p></p></td><td width="25%" valign=top style="width:25.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Details/Provider</span></b><o:p></o:p></p></td><td width="23%" valign=top style="width:23.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Area of Study</span></b><o:p></o:p></p></td><td width="11%" valign=top style="width:11.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Credits</span></b><o:p></o:p></p></td></tr><tr><td colspan=4 valign=top style="background:#091B30;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:white">SELECTED READINGS</span></b><o:p></o:p></p></td></tr>';
        
        for(Content__c cont :cust){
            if(cont.Is_On_Demand__c == true) {
                cont.Status__c = 'Active';
                selContent.add(cont);
                    String[] arguments = new String[] {cont.Name , String.valueOf(cont.Published_Date__c), cont.Description__c, cont.Topic__c, String.valueOf(cont.Published_Date__c)};
                String formattedString = String.format(templateString, arguments);
                genHTML.Story__c = genHTML.Story__c + formattedString;
            }
        }
        genHTML.Story__c = genHTML.Story__c + '</tbody></table>';
        cust = new List<Content__c>();
        update selContent;
    }    
    


    
}