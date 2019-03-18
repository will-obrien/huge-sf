/*
Copyright 2012, Xede Consulting Group, Inc.
*/

@isTest
private class XedeTestDataTest {
  static testMethod void GetTestData() {
      XedeTestData data = new XedeTestData('XedeTestData');
      string aString = data.find('getPropertySchedule');
      
      Dom.Document doc = new Dom.Document();
      doc.load(aString);
      Dom.XmlNode root = doc.getRootElement();
      Dom.XmlNode dataNode = root.getChildElement('data', 'urn:schemas-microsoft-com:rowset');
        
    system.assertEquals(3, dataNode.getChildElements().size());
  }

  static testMethod void GetTestDataMap() {
      XedeTestData data = new XedeTestData('XedeTestData');
      Map<String, String> aMap = data.findMap('getAccountInquiryResponse');
              
    system.assertEquals('GREENWOOD', aMap.get('CUST.CUST_CITY'));
    system.assertEquals(304, aMap.size());
  }

  static testMethod void testCSVData() {
      XedeTestData data = new XedeTestData('XedeTestData');
      
      list<Event> aList = (list<Event>) data.sobjectListFrom(Event.sObjectType, 'ContractCSV');
      system.debug(aList);
      system.assertEquals(3, aList.size());

      system.assertEquals('Detroit', aList[0].Location);
      system.assertEquals('Philadelphia', aList[1].Location);
      system.assertEquals('Denver', aList[2].Location);
      for (Event each : aList) {
        system.assertNotEquals(null, each.activityDate, each);
        system.assertNotEquals(null, each.activityDateTime, each);
        system.assertNotEquals(null, each.DurationInMinutes, each);
      }
  }
}