/*
Copyright 2012, Xede Consulting Group, Inc.
*/

public class XedeTestData {
  void clearDataMap() {
    if (dataMap != null)
      dataMap.clear();
  }
  
  public string find(string aTagName)
  {
    return dataMap.get(aTagname);
  }
  
  map<string, string> loadMapFrom(string aString)
  {
    map<string, string> aMap = new map<string, string>();
    
    XmlStreamReader reader = new XmlStreamReader(aString);
    reader.setCoalescing(true);
    
    reader.nextTag();
    system.assertEquals('xml', reader.getLocalName(), 'test data should start inside <xml> tag.');
    
    while (reader.hasNext()) {
      reader.nextTag();
      
      string nodeName = reader.getLocalName();
      
      if (String.IsNotBlank(nodeName)) {
        for (; reader.getEventType() != XmlTag.END_ELEMENT; reader.next()) {
          if (reader.getEventType() == XmlTag.CHARACTERS) {                    
            aMap.put(nodeName, reader.getText().trim());
          }
        }
        reader.next();
      }
    }
    
    return aMap;
  }
  
  public map<String, String> findMap(String aTagName) {
    Map<String, String> values = new Map<String, String>();
        
    String body = find(aTagName);
    
    List<String> lines = body.split('\n');

    for(String each : lines) {
      List<String> pair = each.split('=>', 2);
      values.put(pair[0].trim(), pair[1].trim());
    }
    
    return values;
  }
  
  void noop() {}
  
  public void release()
  {
    clearDataMap();
    sobjectData = null;
  }
  
  public void refresh() { refresh(resourceName); }
  
  void refresh(string aResourceName)  
  {
    system.debug('refresh loading resource named ' + aResourceName);
    
    sobjectData = [ 
      select  id,  name, body
        from  StaticResource
       where  name = :aResourceName limit 1 
    ];
    
    dataMap = loadMapFrom(sobjectData.body.toString());
  }
  
  // create a list of sobjects (arg1, from the data supplied at the tag, aTag)
  public list<sobject> sobjectListFrom(Schema.sobjectType aType, string aTag)
  {
    Map<String, Schema.SObjectField> fieldMap = aType.getDescribe().fields.getMap();
    system.debug(fieldMap);
    
    string csvString = find(aTag);
    system.debug(csvString);
    
    list<string> csvLine = csvString.split('\n');
    
    list<string> header = csvLine[0].split(',');
    
    list<sobject> sList = new list<sobject>();
    
    for (integer i = 1; i < csvLine.size(); i++) {
      list<string> valueList = csvLine[i].split(',');
      sobject anSobject = aType.newSObject();
      
      for (integer j = 0; j < header.size(); j++) {
        string fieldName = header[j].trim();
        string fieldValue = valueList[j].trim();
        
        system.debug('describing field #' + j + ' ' + fieldName);
        Schema.DisplayType fieldType = fieldMap.get(fieldName).getDescribe().getType();
        
        system.debug(fieldName + ' data type is ' + fieldType);
        
        if (fieldType == Schema.DisplayType.DateTime)
          anSobject.put(fieldName, DateTime.valueOf(fieldValue));
      
        else if (fieldType == Schema.DisplayType.Date)
          anSobject.put(fieldName, Date.valueOf(fieldValue));
          
        else if (fieldType == Schema.DisplayType.Integer)
          anSobject.put(fieldName, Integer.valueOf(fieldValue));
        
        else if (fieldType == Schema.DisplayType.Currency)
          anSobject.put(fieldName, Decimal.ValueOf(fieldValue));
          
        else if (fieldType == Schema.DisplayType.Double ||
            fieldType == Schema.DisplayType.Percent)
          anSobject.put(fieldName, Double.valueOf(fieldValue));
        
        else 
          anSobject.put(fieldName, fieldValue);
      }
      
      slist.add(anSobject);
    }
    
    return sList;
  }
  
  public XedeTestData(string aResourceName)
  {
    resourceName = aResourceName;
    refresh();
  }
  
  public map<string, string> dataMap;
  string resourceName;  
  StaticResource sobjectData;  
}