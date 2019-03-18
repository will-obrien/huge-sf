public with sharing class Napili_ReportChartController {

    
    //get URL for report REST API
    private static string getReportRestAPIURL(String sitePrefix){
        
        if (sitePrefix==null){
            
            return System.URL.getSalesforceBaseUrl().getHost() + '/services/data/v36.0/analytics/reports/';              
        }
            
        return System.URL.getSalesforceBaseUrl().getHost() + sitePrefix +'/services/data/v36.0/analytics/reports/';
    }
    
    @AuraEnabled
    public static String getReportMetaData(String reportId, String sitePrefix){
        
        Map<String, Object> resultMap = new Map<String, Object>();
        List<Object> chartValueList = new List<Object>();
                
        string xmdString = makeRequest(sitePrefix, reportId, 'GET');
        System.debug('metadata in apex:'+xmdString);
        Map<String, Object> reportDescribe = (Map<String, Object>)JSON.deserializeUntyped(xmdString);
        Map<String, Object> reportMetadata = (Map<String, Object>)reportDescribe.get('reportMetadata');
        
        List<Object> aggregates = (List<Object>)reportMetadata.get('aggregates');
        List<Object> groupingsDown = (List<Object>)reportMetadata.get('groupingsDown');
        Map<String, Object> chartMetadata = (Map<String, Object>)reportMetadata.get('chart');
        
        String chartType = (String)chartMetadata.get('chartType');
        String title = (String)chartMetadata.get('title');
        List<Object> groupings = (List<Object>)chartMetadata.get('groupings');
        List<Object> summaries = (List<Object>)chartMetadata.get('summaries');
        List<Object> summaryAxisLocations = (List<Object>)chartMetadata.get('summaryAxisLocations');
        
        
        Reports.ReportResults results = Reports.ReportManager.runReport(reportId, true);
        Map<String, Reports.ReportFact> factMap = (Map<String, Reports.ReportFact>)results.getFactMap();
    
        Reports.Dimension dim = results.getGroupingsDown();
        
        resultMap.put('chartType',chartType);
        resultMap.put('title',title);
        
        if (!chartType.contains('Scatter')) {
            
            Integer aggregateIndex = 0;
            Integer groupLevel = 0;
            for (Integer i=0; i<aggregates.size();  i++) {         
        
                if (((String)aggregates.get(i))==((String)summaries.get(0))) {
                    aggregateIndex = i;
                    break;
                }
            }
            for (Integer i=0; i<groupingsDown.size();  i++) {         
           
                Map<String, Object> groupingsDownObject = (Map<String, Object>)groupingsDown.get(i);
                
                if (((String)groupingsDownObject.get('name'))==((String)groupings.get(0))) {
                    groupLevel = i;
                    break;
                }
            }
            
            
            
            String grouping = (String)groupings.get(0);
            String summary = (String)summaries.get(0);
            
            
            System.debug('aggregates: '+aggregates);
            System.debug('aggregateIndex: '+aggregateIndex);
            System.debug('groupLevel: '+groupLevel);
            System.debug('chartType: '+chartType);
            System.debug('title: '+title);
            System.debug('groupings: '+groupings);
            System.debug('summaries: '+summaries);
            System.debug('summaryAxisLocations: '+summaryAxisLocations);
            
            resultMap.put('grouping',grouping);
            resultMap.put('summary',summary);
    
            retrieveChartValue(factMap,dim.getGroupings(), chartValueList, aggregateIndex, groupLevel, summary);
            
            
            resultMap.put('chartData', chartValueList);
      
            return JSON.serialize(resultMap);                     
        }
        else{
            
            for (Integer i=0; i<groupings.size(); i++) {
                
                Map<String, Map<String, String>> summaryGroupMap = new Map<String, Map<String, String>>();
                
                Integer groupingLevel = identifyGroupingLevel(groupingsDown, (String)groupings.get(i));
                
                //find all the groupings in hierachy based on level
                List<Reports.GroupingValue> tempgroups = retrieveGroups(dim.getGroupings(), 0, groupingLevel);
                
                for (Integer j=0; j<summaries.size(); j++) {
                    
                    String summary =(String)summaries.get(j);
                    
                    Map<String, List<Double>> tempGroupValueMap = new  Map<String, List<Double>>();
                    
                    Integer aggregateIndex = identifySummaryAggregateIndex(aggregates,summary);
                    
                    for (Reports.GroupingValue groupingVal: tempgroups) {
  
                            
                        Double value = getGroupValue(groupingVal, aggregateIndex, factMap);
                           
                        if (tempGroupValueMap.get(groupingVal.getLabel())==null) {
                            
                            List<Double> valueList = new List<Double>();
                            valueList.add(value);
                            tempGroupValueMap.put(groupingVal.getLabel(), valueList);          
                        }
                        else{
                            
                            tempGroupValueMap.get(groupingVal.getLabel()).add(value);
                            
                        }
                        
                    }
                    
                    for (String groupLabel: tempGroupValueMap.keySet()) {   
                        
                        Map<String, String> chartValueMap = summaryGroupMap.get(groupLabel);
                        
                        if (chartValueMap==null){
                            
                            chartValueMap = new Map<String, String>();
                            summaryGroupMap.put(groupLabel, chartValueMap);
                        }
  
                        //set Value
                        chartValueMap.put('value'+i, groupLabel);
                        
                        if (summary.contains('s!') || summary.contains('RowCount')) {

                              populateValues(chartValueMap, sumValues(tempGroupValueMap.get(groupLabel)), j, i);  
                             
                         }
                         else if (summary.contains('a!')){
                           
                              populateValues(chartValueMap, avgValues(tempGroupValueMap.get(groupLabel)), j, i); 
                         }
                         else if (summary.contains('mx!')) {
                                  
                              populateValues(chartValueMap, maxValues(tempGroupValueMap.get(groupLabel)), j, i); 
                         }
                         else if (summary.contains('m!')) {
                               
                              populateValues(chartValueMap, minValues(tempGroupValueMap.get(groupLabel)), j, i); 
                         }
                         
                    }
     
                }
                
                for (Map<String, String> value: summaryGroupMap.values()){
                    
                    chartValueList.add(value);
                }
                
            }
            
            resultMap.put('chartData', chartValueList);
      
            return JSON.serialize(resultMap);  
            
            
            
        }
        
             
    }
    
    //works out what grouping level
    private static Integer identifyGroupingLevel(List<Object> groupingsDown, String grouping){
        
        for (Integer i=0; i<groupingsDown.size();  i++) {         
               
            Map<String, Object> groupingsDownObject = (Map<String, Object>)groupingsDown.get(i);
            
            if (((String)groupingsDownObject.get('name'))==grouping) {
                return i;
            }
         }
        
         return 0;    
    }
    
    private static Integer identifySummaryAggregateIndex(List<Object> aggregates, String summary){
        
          for (Integer i=0; i<aggregates.size();  i++) {         
            
              if (((String)aggregates.get(i))==summary) {
                  return i;
              }
          }
         return 0;
        
    }
    
    
    
    //Public API GET Request here 
    private static string makeRequest(String sitePrefix, string endpoint, string method){
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://' + getReportRestAPIURL(sitePrefix) + endpoint);
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setMethod(method);

        System.debug('URL' + getReportRestAPIURL(sitePrefix));
        System.debug('sessionId' + UserInfo.getSessionId());
        
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        res = http.send(req);
        
        return res.getBody();
    }

    //populate chart data
    private static void retrieveChartValue(Map<String, Reports.ReportFact> factMap, List<Reports.GroupingValue> groups, List<Object> chartValueList, Integer aggregateIndex, Integer groupLevel, String summary){

           Map<String, List<Double>> tempGroupValueMap = new  Map<String, List<Double>>();
        
           List<Reports.GroupingValue> tempgroups = retrieveGroups(groups, 0, groupLevel);
        
        
            for (Reports.GroupingValue groupingVal: tempgroups) {

               System.debug('Key: ' + groupingVal.getKey());
               System.debug('Label: ' + groupingVal.getLabel());
               System.debug('Value: ' + groupingVal.getValue());
               System.debug('subgroup: ' + groupingVal);
            
                Double value = getGroupValue(groupingVal, aggregateIndex, factMap);

               
                if (tempGroupValueMap.get(groupingVal.getLabel())==null) {
                    
                    List<Double> valueList = new List<Double>();
                    valueList.add(value);
                    tempGroupValueMap.put(groupingVal.getLabel(), valueList);          
                }
                else{
                    
                    tempGroupValueMap.get(groupingVal.getLabel()).add(value);
                    
                }
                
            }
        
        for (String groupLabel: tempGroupValueMap.keySet()) {
            
             if (summary.contains('s!') || summary.contains('RowCount')) {
               chartValueList.add(populateValues(groupLabel,sumValues(tempGroupValueMap.get(groupLabel))));
             }
             else if (summary.contains('a!')){
               chartValueList.add(populateValues(groupLabel,avgValues(tempGroupValueMap.get(groupLabel))));
             }
             else if (summary.contains('mx!')) {
               chartValueList.add(populateValues(groupLabel,maxValues(tempGroupValueMap.get(groupLabel))));                
             }
             else if (summary.contains('m!')) {
               chartValueList.add(populateValues(groupLabel,minValues(tempGroupValueMap.get(groupLabel))));                
             }
             
        }
 
  
    }
    
    //recursively retrieve the groups in hierachy
    private static List<Reports.GroupingValue>  retrieveGroups(List<Reports.GroupingValue> groups, Integer levelIndex, Integer groupLevel){
        
        List<Reports.GroupingValue> tempGroups = new List<Reports.GroupingValue>();
        
        if (levelIndex==groupLevel) {
            
            tempGroups.addAll(groups);
        }
        else{
        
            for (Reports.GroupingValue tempGroup: groups) {
                
                if (tempGroup.getGroupings()!=null){
                    
                    tempGroups.addAll(retrieveGroups(tempGroup.getGroupings(), ++levelIndex, groupLevel));
                    --levelIndex;
                }
            }
        }
        
        return tempGroups;
   
    }
    
    
    //find value based on group in factmap
    private static Double getGroupValue(Reports.GroupingValue groupingVal, Integer aggregateIndex, Map<String, Reports.ReportFact> factMap){
        
        // Construct a fact map key, using the grouping key value
        String factMapKey = groupingVal.getKey() + '!T';
        
        // Get the fact map from the report results
        Reports.ReportFactWithDetails factDetails =
            (Reports.ReportFactWithDetails)factMap.get(factMapKey);
        
        // System.debug('factDetails: ' + factDetails);
        // // Get the first summary amount from the fact map
        Reports.SummaryValue sumVal = factDetails.getAggregates()[aggregateIndex];
        System.debug('Summary Value: ' + sumVal.getValue());
        
        
        return ((Decimal)sumVal.getValue()).setScale(2).doubleValue();
    }
    
    private static Double sumValues(List<Double> groupValueList) {
 
                
        Double resultValue=0;
        
        for (Double value: groupValueList) {
            
            resultValue = resultValue + value;
        }
        
        return resultValue;
      
    }
    
    private static Double avgValues(List<Double> groupValueList) {

        Double resultValue=0;

        for (Double value: GroupValueList) {
            
            resultValue = resultValue + value;
        }
        
        resultValue = resultValue/groupValueList.size();

        return resultValue;
      
    }
    
    private static Double MaxValues(List<Double> groupValueList) {
  
        Double resultValue=0;

        for (Double value: GroupValueList) {
            
            if (value>resultValue){
                resultValue = value;
            }
        }

        return resultValue;
      
    }
    
    private static Double minValues(List<Double> groupValueList) {
  
        Double resultValue=groupValueList.get(0);

        for (Double value: groupValueList) {
           
            if (resultValue>value){
                resultValue = value;
            }
        }

        return resultValue;
      
    }
    
    private static Map<String, String> populateValues(String groupLabel, Double value) {
        
        Map<String, String> chartValueMap = new Map<String, String>();
        chartValueMap.put('summary', groupLabel);

        chartValueMap.put('value', String.valueOf(value));
        
        return chartValueMap;
        
    }
    
    private static void populateValues(Map<String, String> chartValueMap, Double value, Integer index, Integer groupIndex) {

        if (index==0){
                                   
            chartValueMap.put('x'+groupIndex,  String.valueOf(value));
        }
        else{
            chartValueMap.put('y'+groupIndex, String.valueOf(value));
        }
     
    }
}