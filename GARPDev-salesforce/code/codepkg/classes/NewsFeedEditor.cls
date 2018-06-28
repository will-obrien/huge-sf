public class NewsFeedEditor {

    public class ContentWrapper implements Comparable {
    
    public Content__c content;
    
    // Constructor
    public ContentWrapper(Content__c con) {
        content = con ;
        if (content.Sequence__c == null) { 
            content.Sequence__c = 0; 
            
        }
    }
    
    // Compare Contents based on the Sequence.
    public Integer compareTo(Object compareTo) {
        // Cast argument to ContentWrapper
        ContentWrapper compareToContent = (ContentWrapper)compareTo;
        
        // The return value of 0 indicates that both elements are equal.
        Integer returnValue = 0;
        if (content.Sequence__c > compareToContent.content.Sequence__c) {
            // Set return value to a positive value.
            returnValue = 1;
        } else if (content.Sequence__c > compareToContent.content.Sequence__c) {
            // Set return value to a negative value.
            returnValue = -1;
        }
        
        return returnValue;       
    }
}
    
    
    
    public void sortRecords() {
        ContentWrapper [] wrapperList = new List<ContentWrapper>();
        for (Content__c content : cust) {
            ContentWrapper wrapper = new ContentWrapper(content);
            wrapperList.add(wrapper);
        }
        wrapperList.sort();
        cust.clear();
        
        for (ContentWrapper wrapper : wrapperList) {
            Content__c content = wrapper.content;
            cust.add(content);
        }
        
    }

    
   public void filterRecords() {
       Integer j = 0;
       while (j < cust.size()) {
          if(cust.get(j).Is_On_Demand__c == false) {
             cust.remove(j);
          }
          else {
            j++;
          }
      }
      sortRecords();
   }
    

    public Boolean showRecords{get;set;}
    public List<Content__c> cust {get;set;}
    public Content__c startDate {get;set;}
    public Content__c endDate {get;set;}
    public Content__c genHTML {get;set;}
    
    public Decimal foundNumber {get;set;}
        
    //In constructor
    public NewsFeedEditor() {
        showRecords =false; 
        startDate = new Content__c();        
        endDate = new Content__c();
        genHTML = new Content__c();
        genHTML.Story__c = '';
        foundNumber = -1;
    }
    
    
    public void fetchRecords(){
        system.debug('* * * fetch ...'+ startDate.Published_Date__c);
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Content__c','News Feed');        
        cust = [Select Id, Name, Name_Override__c, Description__c, Status__c, Content_Type__c, Sequence__c, Is_On_Demand__c, Published_Date__c, RecordTypeID from Content__c where RecordTypeID = :recordTypeID and Published_Date__c >= :startDate.Published_Date__c  and Published_Date__c <= :endDate.Published_Date__c limit 1000];
        foundNumber = cust.size();
        showRecords = true;
        for (Content__c cont : cust) {
            cont.Is_On_Demand__c = false;
        }
        
    }    

    public void Publish(){
        List<Content__c> selContent = new List<Content__c>();
        
        // V1
        //String templateString = '<tr><td align="left" valign="top"><table align="left" border="0" cellpadding="0" cellspacing="0" width="440"><!--leadstart --><tbody><tr><td style=" padding-top: 20px; padding-bottom: 5px; font-family: Georgia, &apos;Times New Roman&apos;, Times, serif; font-size: 16px; color: #20374d;" align="left" valign="top"><strong><a href="{0}" target="_blank" style=" color: #20374D;">{1}</a></strong></td></tr><tr><td style=" font-family: Arial, Helvetica, sans-serif; font-size: 13px; color: #535353;" align="left" valign="top"><p>{2} ...</p><table border="0" cellpadding="0" cellspacing="0" width="440"><tbody><tr><td style=" font-family: Arial, Helvetica, sans-serif; font-size: 12px; padding-top: 5px;" align="left" nowrap="" valign="top" width="440"><strong>SHARE:</strong><a href="{0}" target="_blank"><img src="http://newsmanager.commpartners.com/garpdn/images/facebook_icon.gif" alt="Share this on Facebook" border="0" height="15" width="25"></a><a href="{0}" onclick="openPopup(&apos;http://twitter.com/home?status=Check%20this%20out%20--%20{0}&apos;, &apos;NewsManager&apos;, 650, 1024, true);return false;"><img src="http://newsmanager.commpartners.com/garpdn/images/twitter_icon.gif" alt="Share this on Twitter" border="0" height="15" width="25"></a><a href="{0}" news=""><img src="http://newsmanager.commpartners.com/garpdn/images/linkedin_icon.gif" alt="Share this on LinkedIn" border="0" height="15" width="25"></a></td></tr></tbody></table></td></tr>';
        
        // V2
        //String templateString = '<tr><td align="left" valign="top" style="padding-top: 20px; padding-bottom: 5px; font-family: Georgia, Times New Roman, Times, serif; font-size: 16px; color: #20374d;"><strong><a href="{0}" target="_blank" style="color: #20374D;">{1}</a></strong></td></tr><tr><td style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; color: #535353;" align="left" valign="top"><p>{2} ...</p><table border="0" cellpadding="0" cellspacing="0" width="440"><tbody><tr><td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; padding-top: 5px;" align="left" nowrap="" valign="top" width="440"><strong>SHARE:</strong><a href="{0}" target="_blank"><img src="http://go.pardot.com/l/39542/2014-06-11/dgfk/39542/15364/facebook_icon.gif" alt="Share this on Facebook" border="0" height="15" width="25"></a><a href="{0}" onclick="openPopup(&apos;http://twitter.com/home?status=Check%20this%20out%20--%20{0}&apos;, &apos;NewsManager&apos;, 650, 1024, true);return false;"><img src="http://go.pardot.com/l/39542/2014-06-11/dgfr/39542/15368/twitter_icon.gif" alt="Share this on Twitter" border="0" height="15" width="25"></a><a href="{0}" news=""><img src="http://go.pardot.com/l/39542/2014-06-11/dgft/39542/15370/linkedin_icon.gif" alt="Share this on LinkedIn" border="0" height="15" width="25"></a><a href="{0}" onclick="javascript:window.open(this.href,&apos;&apos;,&apos;menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600&apos;);return false;" news=""><img src="http://go.pardot.com/l/39542/2014-08-22/3l8mt/39542/28466/googleplus_icon.png" alt="Share on Google+" border="0" height="15" width="25"></a><a href="{0}"><img src="http://go.pardot.com/l/39542/2014-06-24/kyj5/39542/17500/weibo_icon.gif" alt="Share this on Weibo" border="0" height="15" width="25"></a></td></tr></tbody></table></td></tr>';
        // 0 = URL, 1 = Name, 2 = Desc
        
        String templateString = '';
        templateString += '<tr>';
        templateString += '<td align="left" valign="top" style="padding-top:20px; padding-bottom:5px; font-family:Georgia,Times New Roman,Times,serif; font-size:16px; color:#20374d">';
        templateString += '<strong><a href="{0}" style="color:#20374D" target="_blank">{1}</a></strong></td>';
        templateString += '</tr>';
        templateString += '<tr>';
        templateString += '<td align="left" valign="top" style="font-family:Arial,Helvetica,sans-serif; font-size:13px; color:#535353">';
        templateString += '<p>{2}</p>';
        templateString += '<table border="0" cellpadding="0" cellspacing="0" width="440">';
        templateString += '<tbody>';
        templateString += '<tr>';
        templateString += '<td align="left" nowrap="" valign="top" width="440" style="font-family:Arial,Helvetica,sans-serif; font-size:12px; padding-top:5px">';
        templateString += '<strong>SHARE:</strong>';
        
        templateString += '<a href="http://www.facebook.com/sharer/sharer.php?u={3}" target="_blank"><img src="http://go.pardot.com/l/39542/2014-06-11/dgfk/39542/15364/facebook_icon.gif" alt="Share this on Facebook" border="0" height="15" width="25"></a>';
        templateString += '<a href="https://twitter.com/intent/tweet?text=GARP%20Risk%20Intelligence%20-%20{1}&url={3}&via=GARP_Risk" target="_blank"><img src="http://go.pardot.com/l/39542/2014-06-11/dgfr/39542/15368/twitter_icon.gif" alt="Share this on Twitter" border="0" height="15" width="25"></a>';
        templateString += '<a href="http://www.linkedin.com/shareArticle?mini=true&amp;url={3}" news="" target="_blank"><img src="http://go.pardot.com/l/39542/2014-06-11/dgft/39542/15370/linkedin_icon.gif" alt="Share this on LinkedIn" border="0" height="15" width="25"></a>';
        templateString += '<a href="https://plus.google.com/share?url={3}" onclick="javascript:window.open(this.href,&apos;&apos;,&apos;menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600&apos;);return false;" news=""><img src="http://go.pardot.com/l/39542/2014-08-22/3l8mt/39542/28466/googleplus_icon.png" alt="Share on Google+" border="0" height="15" width="25"></a>';
        templateString += '<a href="http://service.weibo.com/share/share.php?url={3}"><img src="http://go.pardot.com/l/39542/2014-06-24/kyj5/39542/17500/weibo_icon.gif" alt="Share this on Weibo" border="0" height="15" width="25"></a>';
        
        templateString += '</td>';
        templateString += '</tr>';
        templateString += '</tbody>';
        templateString += '</table>';
        templateString += '</td>';
        templateString += '</tr>';
        
        genHTML.Story__c = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body><table><tbody>';
        
        //Generate Date String for Google Analytics in format 'May_10_2015' 
        DateTime d = DateTime.now();
        String monthName= d.format('MMMMM');
        String dayOfMonth = d.format('d');
        String year = d.format('yyyy');
        String dateString = monthName + '_' + dayOfMonth + '_' + year; 
                
        for(Content__c cont :cust){
        
            String docUrl = 'http://www.garp.org/#!/risk_intelligence_detail/' + cont.Id +  '?utm_source=' + dateString + '&utm_medium=email&utm_campaign=DailyNews';
            String docEscUrl = 'http%3A%2F%2Fwww.garp.org%2F%23!%2Frisk_intelligence_detail%2F' + cont.Id; //Escaped URL will be send to Social Media sites
            
            if(cont.Is_On_Demand__c == true) {
                cont.Status__c = 'Active';
                String name = cont.Name_Override__c != null && !cont.Name_Override__c.isWhiteSpace() ? cont.Name_Override__c : cont.Name;
                selContent.add(cont);
                String[] arguments = new String[] {docUrl, name, cont.Description__c, docEscUrl };
                String formattedString = String.format(templateString, arguments);
                genHTML.Story__c = genHTML.Story__c + formattedString;
            }
        }
        genHTML.Story__c = genHTML.Story__c + '</tbody></table></body></html>';
        //cust = new List<Content__c>();
        
    }    
    
    
    public void sendEmail() {
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       
       //Retrieve email recipient's address from Custom Setting
       List<String> toAddresses = new List<String>();
       News_Feed_Selector__c selector = News_Feed_Selector__c.getInstance('Default');
       //System.debug(selector.Recipient_Emil__c);
       if (selector != null) {
           toAddresses.add(selector.Recipient_Email__c );
       }
       else {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Email address found in Custom Settings, using default value: websiteupdates@garp.com'));
            toAddresses.add('websiteupdates@garp.com'); 
       }
       
       mail.setToAddresses(toAddresses);
       mail.setSenderDisplayName('News Feed Selector');
       mail.setSubject('Newsletter Feed');
       mail.setBccSender(false);
       //mail.setUseSignature(true); ??
       mail.setPlainTextBody('HTML copy for Newsletter');
       //mail.setHtmlBody('<b> This is HTML body </b>' );
        
       List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
       Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
       efa.setFileName('newsletter.html');
       Blob body = Blob.valueOf(genHTML.Story__c);
       efa.setBody(body);
       fileAttachments.add(efa);
       mail.setFileAttachments(fileAttachments);
       
       if (!Test.isRunningTest() && selector != null) {
           Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
       
       ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Email sent on ' + DateTime.now().format()));
       
    }
  
}