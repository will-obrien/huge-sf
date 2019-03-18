public class DE_RSSObject {
    @AuraEnabled
    public String title {get;set;}
    @AuraEnabled
    public String url {get;set;}
    @AuraEnabled
    public String description {get;set;}
    @AuraEnabled
    public String pubDate {get;set;}
    
    public DE_RSSObject() {
        this.title = 'title';
        this.url = 'url';
        this.description = 'des';
        
    }
    
    public DE_RSSObject(String title, String url, String des,String pubDate) {
        this.title = title;
        this.url = url;
        this.description = des;
        setPubDate(pubDate);
    }
    
    public void setPubDate(String value) {
        if(value != null && value.length() >0 ) {
            List<String> spt = value.split(' ');
            String temp = ''+spt[0]+' '+spt[2]+' '+spt[1]+' '+spt[3]+' '+spt[4];
            this.pubDate = temp;
        } else {
            this.pubDate = '';
        }
        
    }
}