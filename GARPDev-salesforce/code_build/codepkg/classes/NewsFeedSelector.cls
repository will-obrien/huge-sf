public class NewsFeedSelector {
	public Boolean showRecords{get;set;}
    public List<Content__c> cust {get;set;}

    public Content__c startDate {get;set;}
    public Content__c endDate {get;set;}
    public Content__c genHTML {get;set;}

    public Decimal foundNumber {get;set;}
    
    //In constructor
    
    public NewsFeedSelector() {
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
		cust = [Select Id, Name, Description__c, Status__c, Content_Type__c, Is_On_Demand__c, Published_Date__c, RecordTypeID from Content__c where RecordTypeID = :recordTypeID and Published_Date__c >= :startDate.Published_Date__c  and Published_Date__c <= :endDate.Published_Date__c limit 1000];
        foundNumber = cust.size();
        showRecords = true;
    }    

    public void Publish(){
        List<Content__c> selContent = new List<Content__c>();
        
        //String templateString = '<tr><td align="left" valign="top"><table align="left" border="0" cellpadding="0" cellspacing="0" width="440"><!--leadstart --><tbody><tr><td style=" padding-top: 20px; padding-bottom: 5px; font-family: Georgia, &apos;Times New Roman&apos;, Times, serif; font-size: 16px; color: #20374d;" align="left" valign="top"><strong><a href="{0}" target="_blank" style=" color: #20374D;">{1}</a></strong></td></tr><tr><td style=" font-family: Arial, Helvetica, sans-serif; font-size: 13px; color: #535353;" align="left" valign="top"><p>{2} ...</p><table border="0" cellpadding="0" cellspacing="0" width="440"><tbody><tr><td style=" font-family: Arial, Helvetica, sans-serif; font-size: 12px; padding-top: 5px;" align="left" nowrap="" valign="top" width="440"><strong>SHARE:</strong><a href="{0}" target="_blank"><img src="http://newsmanager.commpartners.com/garpdn/images/facebook_icon.gif" alt="Share this on Facebook" border="0" height="15" width="25"></a><a href="{0}" onclick="openPopup(&apos;http://twitter.com/home?status=Check%20this%20out%20--%20{0}&apos;, &apos;NewsManager&apos;, 650, 1024, true);return false;"><img src="http://newsmanager.commpartners.com/garpdn/images/twitter_icon.gif" alt="Share this on Twitter" border="0" height="15" width="25"></a><a href="{0}" news=""><img src="http://newsmanager.commpartners.com/garpdn/images/linkedin_icon.gif" alt="Share this on LinkedIn" border="0" height="15" width="25"></a></td></tr></tbody></table></td></tr>';
        String templateString = '<tr><td align="left" valign="top" style="padding-top: 20px; padding-bottom: 5px; font-family: Georgia, Times New Roman, Times, serif; font-size: 16px; color: #20374d;"><strong><a href="{0}" target="_blank" style="color: #20374D;">{1}</a></strong></td></tr><tr><td style="font-family: Arial, Helvetica, sans-serif; font-size: 13px; color: #535353;" align="left" valign="top"><p>{2} ...</p><table border="0" cellpadding="0" cellspacing="0" width="440"><tbody><tr><td style="font-family: Arial, Helvetica, sans-serif; font-size: 12px; padding-top: 5px;" align="left" nowrap="" valign="top" width="440"><strong>SHARE:</strong><a href="{0}" target="_blank"><img src="http://go.pardot.com/l/39542/2014-06-11/dgfk/39542/15364/facebook_icon.gif" alt="Share this on Facebook" border="0" height="15" width="25"></a><a href="{0}" onclick="openPopup(&apos;http://twitter.com/home?status=Check%20this%20out%20--%20{0}&apos;, &apos;NewsManager&apos;, 650, 1024, true);return false;"><img src="http://go.pardot.com/l/39542/2014-06-11/dgfr/39542/15368/twitter_icon.gif" alt="Share this on Twitter" border="0" height="15" width="25"></a><a href="{0}" news=""><img src="http://go.pardot.com/l/39542/2014-06-11/dgft/39542/15370/linkedin_icon.gif" alt="Share this on LinkedIn" border="0" height="15" width="25"></a><a href="{0}" onclick="javascript:window.open(this.href,&apos;&apos;,&apos;menubar=no,toolbar=no,resizable=yes,scrollbars=yes,height=600,width=600&apos;);return false;" news=""><img src="http://go.pardot.com/l/39542/2014-08-22/3l8mt/39542/28466/googleplus_icon.png" alt="Share on Google+" border="0" height="15" width="25"></a><a href="{0}"><img src="http://go.pardot.com/l/39542/2014-06-24/kyj5/39542/17500/weibo_icon.gif" alt="Share this on Weibo" border="0" height="15" width="25"></a></td></tr></tbody></table></td></tr>';
        
        // 0 = URL, 1 = Name, 2 = Desc
        
        genHTML.Story__c = '<table><tbody>';
        
        for(Content__c cont :cust){
            if(cont.Is_On_Demand__c == true) {
                cont.Status__c = 'Active';
                selContent.add(cont);
		        String[] arguments = new String[] {'http://www.garp.org/#!/risk_intelligence_detail/' + cont.Id , cont.Name, cont.Description__c};
                String formattedString = String.format(templateString, arguments);
                genHTML.Story__c = genHTML.Story__c + formattedString;
            }
        }
        genHTML.Story__c = genHTML.Story__c + '</tbody></table>';
        cust = new List<Content__c>();
        update selContent;
    }    
    


    
}