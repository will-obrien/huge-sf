public class CPDNewsLetterSelector {
    public Boolean showRecords{get;set;}
    public List<contWrapper> cust {get;set;}

    public Content__c startDate {get;set;}
    public Content__c endDate {get;set;}
    public Content__c genHTML {get;set;}
    
    //In constructor
    
    public CPDNewsLetterSelector() {
        showRecords =false; 
        startDate = new Content__c();        
        endDate = new Content__c();
        genHTML = new Content__c();
        genHTML.Story__c = '';
        cust = new List<contWrapper>();
    }

    public class contWrapper { 
        public Boolean selected { get; set; }
        public CPE_Activity__c obj { get; set; }
    }    
        
    public void fetchRecords(){
        system.debug('* * * fetch ...'+ startDate.Published_Date__c);
        //cust = [Select Id, Name, Description__c, Status__c, Content_Type__c, Is_On_Demand__c, Published_Date__c, Topic__c, Credit__c from Content__c where Credit__c > 0 and Published_Date__c >= :startDate.Published_Date__c  and Published_Date__c <= :endDate.Published_Date__c limit 1000];
        List<CPE_Activity__c> cpeActs = [select Id, Name, Title__c, Description__c, CPE_Activity_Type__c, CPE_Activity_Type__r.Name, Activity_Type_Description__c, Area_of_Study__c, Credit__c, Date_Description__c, Organization__c, Provider__c, Publication__c, URL__c, Outreach_Start_Date__c, Outreach_End_Date__c from CPE_Activity__c where Outreach_Start_Date__c <= :startDate.Published_Date__c and Outreach_End_Date__c >= :startDate.Published_Date__c order by CPE_Activity_Type__r.Name, Title__c limit 1000];
        for(CPE_Activity__c ca :cpeActs) {
            contWrapper c = new contWrapper();
            c.obj = ca;
            c.selected = false;
            cust.add(c);
        }
        showRecords = true;
    }    

    public void Publish(){
        List<CPE_Activity__c> selContent = new List<CPE_Activity__c>();
        

        String headerTemplateString = '<tr><td colspan="5" align="left" valign="top" bgcolor="#005c83"><span style="text-align:left;line-height:1.25em;font-weight:bold;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#ffffff;">{0}</span></td></tr>';

        //String templateString = '<tr><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:black"><ahref="http://iz3.me/76Ap1zxV0RC1" target="_blank"><b><spanstyle="color:#111111">{0}</span></b></a><o:p></o:p></p></td><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:black">{1}</span><o:p></o:p></p></td><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:black">{2}</span><o:p></o:p></p></td><td valign=top style="background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal align=center style="text-align:center"><b><spanstyle="font-size:9.0pt;font-family:"Arial","sans-serif";color:#081A31">{3}</span></b><o:p></o:p></p></td></tr>';
        String templateString = '';

        templateString += '<tr>';
        templateString += ' <td align="left" valign="top" bgcolor="#FFFFFF"><span style="text-align:left;line-height:1.25em;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#000000;"><a href="{0}" target="_blank" style="text-decoration:underline;font-weight:bold;color:#111111;">{1}</a> <br />';
        templateString += '   <a href="#" style="color: #111111; text-decoration: none;pointer-events: none;">March 2015</a></span></td>';
        templateString += ' <td align="left" valign="top" bgcolor="#FFFFFF"><span style="text-align:left;line-height:1.25em;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#000000;"><span style="font-weight:normal;">{2}</span></span>';
        templateString += ' </td>';
        templateString += ' <td align="left" valign="top" bgcolor="#FFFFFF"><span style="text-align:left;line-height:1.25em;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#000000;"><span style="font-weight:normal;">{3}</span></span>';
        templateString += ' </td>';
        templateString += ' <td align="center" valign="top" bgcolor="#FFFFFF"><span style="text-align:left;line-height:1.25em;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#000000;"><span style="font-weight:bold;color:#081A31;">{4}</span></span>';
        templateString += ' </td>';
        templateString += ' <td align="left" valign="top" bgcolor="#FFFFFF"><span style="text-align:left;line-height:1.25em;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#000000;"><a href="{5}" target="_blank" style="text-decoration:underline;font-weight:bold;color:#A85123;">Submit</a></span></td>';
        templateString += '</tr>';
                
        
        // 0 = URL, 1 = Name, 2 = Desc
        
        //genHTML.Story__c = '<table class=MsoNormalTable border=0 cellpadding=0 width="100%" style="width:100.0%"><tr><td colspan=4 valign=top style="background:#091B30;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal align=center style="text-align:center"><b><span style="font-size:10.5pt;font-family:"Arial","sans-serif";color:white">CPE CREDIT OPPORTUNITIES</span></b><o:p></o:p></p></td></tr><tr><td width="41%" valign=top style="width:41.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Title</span></b><o:p></o:p></p></td><td width="25%" valign=top style="width:25.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Details/Provider</span></b><o:p></o:p></p></td><td width="23%" valign=top style="width:23.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Area of Study</span></b><o:p></o:p></p></td><td width="11%" valign=top style="width:11.0%;background:white;padding:3.0pt 3.0pt 3.0pt 3.0pt"><p class=MsoNormal><b><span style="font-size:9.0pt;font-family:"Arial","sans-serif";color:#006C99">Credits</span></b><o:p></o:p></p></td></tr>';
        genHTML.Story__c = '';
        
        genHTML.Story__c += '<table width="100%" border="0" align="center" cellpadding="4" cellspacing="2">';
        genHTML.Story__c += '  <tr>';
        genHTML.Story__c += '   <td colspan="5" align="center" valign="top" bgcolor="#005c83"><span style="text-align:left;line-height:1.25em;font-weight:bold;font-size:14px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#ffffff;">FEATURED ACTIVITIES</span></td>';
        genHTML.Story__c += '  </tr>';
        genHTML.Story__c += '  <tr>';
        genHTML.Story__c += '   <td width="46%" align="left" valign="top" bgcolor="#ffffff"><span style="text-align:left;line-height:1.25em;font-weight:bold;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#006c99;">Title</span></td>';
        genHTML.Story__c += '   <td width="17%" align="left" valign="top" bgcolor="#ffffff"><span style="text-align:left;line-height:1.25em;font-weight:bold;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#006c99;">Details/Provider</span></td>';
        genHTML.Story__c += '   <td width="18%" align="left" valign="top" bgcolor="#ffffff"><span style="text-align:left;line-height:1.25em;font-weight:bold;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#006c99;">Area of Study</span></td>';
        genHTML.Story__c += '   <td align="left" valign="top" bgcolor="#ffffff"><span style="text-align:left;line-height:1.25em;font-weight:bold;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#006c99;">Credits</span></td>';
        genHTML.Story__c += '   <td align="left" valign="top" bgcolor="#ffffff"><span style="text-align:left;line-height:1.25em;font-weight:bold;font-size:12px;font-family:Arial,Geneva,Verdana,Helvetica,sans-serif;color:#006c99;">Submit Credits</span></td>';
        genHTML.Story__c += '  </tr>';
                
        
        
        String lastType = '';
        String provider = '';
        String submitLink = '';
        
        for(contWrapper cont :cust){
        
            if(cont.obj.CPE_Activity_Type__r.Name != lastType) {
                String[] arguments = new String[] {cont.obj.CPE_Activity_Type__r.Name};
                String formattedString = String.format(headerTemplateString, arguments);
                genHTML.Story__c += formattedString;
                lastType = cont.obj.CPE_Activity_Type__r.Name;
            }
        
            if(cont.obj.Provider__c != null) {
                provider = cont.obj.Provider__c;
            } else if(cont.obj.Publication__c!= null) {
                provider = cont.obj.Publication__c;
            } else if(cont.obj.Description__c!= null) {
                if(cont.obj.Description__c.length() > 30)
                    provider = cont.obj.Description__c.subString(0,30);
                else if(cont.obj.Description__c.length() > 0)
                    provider = cont.obj.Description__c;
            }
                
            submitLink = 'https://my.garp.org/Login?start=cpe_activity/' + cont.obj.Id;
                
            String[] arguments = new String[] {cont.obj.URL__c, cont.obj.Title__c, provider, cont.obj.Area_of_Study__c, String.valueOf(cont.obj.Credit__c), submitLink};
            String formattedString = String.format(templateString, arguments);
            genHTML.Story__c = genHTML.Story__c + formattedString;
            
        }
        genHTML.Story__c = genHTML.Story__c + '</table>';
    }    
    


    
}