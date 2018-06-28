public with sharing class TimelineControlApexController {
    public static List<TimelineDataModel> TimelineData{get;set;}
    @AuraEnabled
    public static String  GetTimelineData(){
        TimelineData=new List<TimelineDataModel>();
        Map<String,String> detailedData=new Map<String,String>();
        detailedData.put('Key1','Value11');
        detailedData.put('Key2','Value12');
        detailedData.put('Key3','Value13');
        detailedData.put('Key4','Value14');
        detailedData.put('Key5','Value15');
        detailedData.put('Key6','Value16');
        detailedData.put('Key7','Value17');
        detailedData.put('Key8','Value18');
        TimelineData.add(new TimelineDataModel('1','PQ',Datetime.newInstance(2016, 12, 24),detailedData));
        TimelineData.add(new TimelineDataModel('2','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('3','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('4','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('5','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('6','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('7','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('8','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('9','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('10','PQ1',Datetime.newInstance(2016, 12, 23),detailedData));
        TimelineData.add(new TimelineDataModel('11','Some Activity',Datetime.newInstance(2016, 12, 23),detailedData));
        return JSON.serialize(TimelineData);
    }
    
    @AuraEnabled
    public static String GetSelectedActivity(String SelectedId){
        /*for(TimelineDataModel model:TimelineData){
            if(model.ActivityId==SelectedId){
                return model;
            }
        }*/
        if(TimelineData==null){
            return '0';
        }
        else{
            return '1';
        }
        // return JSON.serialize(TimelineData[0]);
    }
}