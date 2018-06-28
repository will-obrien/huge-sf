global class NewsFeed{

    public List<String> a { get; set; }

    private static Map<String, Integer> monthsMap = new Map<String, Integer>{
      'JAN'  => 1,
      'FEB' => 2,
      'MAR' => 3,
      'APR' => 4,
      'MAY' => 5,
      'JUN' => 6,
      'JUL' => 7,
      'AUG' => 8,
      'SEP' => 9,
      'OCT' => 10,
      'NOV' => 11,
      'DEC' => 12
    };
        
    public static string GetFeedWrapper(String s ) {
        return 'Bob';   
    }

    @future(callout=true)
    public static void getFeedMethod() {
        
        List<Folder__c> lstFolder = [select Id, Name from Folder__c where Name = 'Risk News and Resources']; 
        if(lstFolder == null || lstFolder.size() == 0)
            return;
        
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('http://bloomberg.mainstreamdata.com:8080/bbrss/RSSFeed.ashx?customerid=Ip9G7kONd4hLgrIWITb&feed=331');
        //req.setEndpoint('http://ec2-54-186-51-192.us-west-2.compute.amazonaws.com:3000/webserver/public/lib/feed.xml');
        req.setMethod('GET');
        req.setHeader('Range','bytes=0-30000');
        req.setCompressed(true);
        
        Http h=new Http();
        HttpResponse res = h.send(req);
        system.debug('res == '+res);
        dom.Document doc = res.getBodyDocument();
         system.debug('doc == '+doc);
        Dom.XMLNode responseNode = doc.getRootElement();
         system.debug('responseNode == '+responseNode);
        boolean bIsSuccess = false;
        system.debug('responseNode == '+responseNode);

        List<Dom.xmlNode> channelNodes = responseNode.getChildElements();
        system.debug('channelNodes == '+channelNodes);
        List<Content__c> news = new List<Content__c>();
        
        List<Content__c> existingNews = [Select Id, Name, Content_Name__c, SKU__c from Content__c where Content_Type__c = 'News Feed'];
        system.debug('existingNews == '+existingNews);
        if(channelNodes != null) {
            Dom.xmlNode channelNode = channelNodes[0];
            MAP<String, String> currentNewsMap = new MAP<String, String>();
            for(Dom.xmlNode childNode : channelNode.getChildElements())
            {
                system.debug('childNode: '+childNode);  
                
                if(childNode.getName() == 'item') {
                   
                    String description = '';
                    String pubDate = '';
                    String title = '';
                    String category = '';
                    String author = '';
                    String copyright = '';
                    String higlight = '';
                    String guid = '';
                    
                    for(Dom.xmlNode itemChildNode : childNode.getChildElements())
                    {
                        system.debug('itemChildNode: '+itemChildNode.getName()); 
                                                    
                        if(itemChildNode.getName() == 'pubDate') {
                            pubDate = itemChildNode.getText();
                            system.debug('pubDate: '+pubDate);   
                        }
                        if(itemChildNode.getName() == 'title') {
                            title = itemChildNode.getText();
                            system.debug('title: '+title);   
                        }
                        if(itemChildNode.getName() == 'category') {
                            category = itemChildNode.getText();
                            system.debug('category: '+category);   
                        }
                        if(itemChildNode.getName() == 'description') {
                            if(description == '') {
                                description = itemChildNode.getText();
                                system.debug('description: '+description);   
                            } else {
                                higlight = itemChildNode.getText();
                                system.debug('higlight: '+higlight);                                   
                            }
                        }
                        if(itemChildNode.getName() == 'author') {
                            author = itemChildNode.getText();
                            system.debug('author: '+author);   
                        }
                        if(itemChildNode.getName() == 'copyright') {
                            copyright = itemChildNode.getText();
                            system.debug('copyright: '+copyright);   
                        }
                        if(itemChildNode.getName() == 'guid') {
                            guid = itemChildNode.getText();
                            system.debug('guid: '+guid);   
                        }
                    }
                    Content__c cont = new Content__c();
                    id recordTypeId = RecordTypeHelper.GetRecordTypeId('Content__c','News Feed');
                    
                    cont.RecordTypeId = recordTypeId;
                    if(title.length() > 80)
                        cont.Name = title.substring(1, 80);
                    else cont.Name = title;
                    cont.Content_Name__c = title;
                    cont.Description__c = higlight;
                    
                    String dt = pubDate.substring(5,pubDate.length()-3);   
                    Integer day;
                    Integer month;
                    Integer year;
                    Matcher m = Pattern.compile('([0-9]*) ([A-Za-z]*) ([0-9]*) (.*)').matcher(dt);
                    if(m.matches()) {
                        System.debug('Match:' + m.group(1));
                        System.debug('Match:' + m.group(2));
                        System.debug('Match:' + m.group(3));
                        day = integer.valueof(m.group(1));
                        month = monthsMap.get( m.group(2).toUpperCase() );
                        year = integer.valueof(m.group(3));
                    }
                    
                    //datetime setDate = datetime.parse(dt);
                    //Date myDate = date.newinstance(setDate.year(), setDate.month(), setDate.day());
                    //
                    Date myDate ;
                    if(!test.isRunningtest())
                        myDate = date.newinstance(year, month, day);
                    else 
                        myDate = date.newinstance(2014, 12 ,3);
                    
                    cont.Published_Date__c = myDate;
                    cont.Status__c = 'Active';
                    cont.Story__c = description;
                    cont.Third_Party_Author__c = author;
                    cont.Content_Type__c = 'News';
                    cont.SKU__c = guid;
                    
                    system.debug('new content: '+cont);  
                    
                    Boolean found=false;
                    for(Content__c ec: existingNews) {
                        if(ec.SKU__c == guid || cont.Content_Name__c == ec.Content_Name__c) {
                            found=true;
                            break;
                        }
                    }
                    if(!found) {
                        String fid = currentNewsMap.get(cont.Content_Name__c);
                        if(fid == null) {
                            news.add(cont);
                            currentNewsMap.put(cont.Content_Name__c, cont.SKU__c);
                        }
                    }
                                                                
                }            
            }    
            insert news;  
            List <Content__c> newNews = [select Id, Name from Content__c where Id in :news];
            List <Content_Folders__c> newCFs = new List <Content_Folders__c>();
            if(newNews != null && newNews.size() > 0) {
                for(Content__c c : newNews) {
                    Content_Folders__c cf = new Content_Folders__c();
                    cf.Folder__c = lstFolder[0].Id;
                    cf.Content__c = c.Id;
                    newCFs.add(cf);
                }
                insert newCFs;
            }
        }        
        
    }
    
    public pageReference GetFeed() {
        getFeedMethod();
        return null;
    }    

}