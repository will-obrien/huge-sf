public class TimelineEvent{
    @AuraEnabled
    public String headline{get; set;}
    @AuraEnabled
    public String text{get; set;}
    @AuraEnabled
    public String url{get; set;}
    @AuraEnabled
    public String caption{get; set;}
    @AuraEnabled
    public DateWrapper startDate{get; set;}
    @AuraEnabled
    public DateWrapper endDate{get; set;}

    public class DateWrapper{
        @AuraEnabled
        public String month{get; set;}
        @AuraEnabled
        public String day{get; set;}
        @AuraEnabled
        public String year{get; set;}
        @AuraEnabled
        public String hour{get; set;}
        @AuraEnabled
        public String minute{get; set;}
        @AuraEnabled
        public String second{get; set;}

        public DateWrapper(DateTime value){
            this.year = '' + value.year();
            this.month = '' + value.month();
            this.day = '' + value.day();
            this.hour = '' + value.hour();
            this.minute = '' + value.minute();
            this.second = '' + value.second();
        }
    }

    private String traverseSObject(SObject record, String fieldName){
        if(String.isEmpty(fieldName)){
            return ' ';
        }
        String divider = '.';
        if(fieldName.contains(divider)){
            String parent = fieldName.substring(0, fieldName.indexOf(divider));
            String children = fieldName.substring(fieldName.indexOf(divider)+1);
            return traverseSObject(record.getSObject(parent), children);
        }else{
            String value = (String)record.get(fieldName);
            return String.isEmpty(value) ? ' ' : value;
        }
    }

    private DateTime traverseSObjectDatetime(SObject record, String fieldName){
        String divider = '.';
        if(fieldName.contains(divider)){
            String parent = fieldName.substring(0, fieldName.indexOf(divider));
            String children = fieldName.substring(fieldName.indexOf(divider)+1);
            return traverseSObjectDatetime(record.getSObject(parent), children);
        }else{
            return (Datetime)record.get(fieldName);
        }    
    }
    
    public TimelineEvent(SObject record, Map<String, String> fieldMap){
        this.headline = traverseSObject(record, fieldMap.get('headline'));
        this.text = traverseSObject(record, fieldMap.get('text'));
        this.url = traverseSObject(record, fieldMap.get('url'));
        if(!this.url.startsWith('/') && !this.url.startsWith('www.') && !this.url.startsWith('http')){
            this.url = '/' + this.url;
        }
        this.caption = traverseSObject(record, fieldMap.get('caption'));
        this.startDate = new DateWrapper(traverseSObjectDatetime(record, fieldMap.get('startDate')));
        if(!String.isEmpty(fieldMap.get('endDate'))){
            this.endDate = new DateWrapper(traverseSObjectDatetime(record, fieldMap.get('endDate')));            
        }
    }

}