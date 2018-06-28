public class BulkOrderTrackingNumbers {
    
    public Blob contentFile{get;set;}
    public string fileName{get;set;}

    public PageReference ReadFile() {
        if(contentFile == null) return null;
         Dom.Document doc = new Dom.Document();
         doc.load(contentFile.toString());
         system.debug('doc == '+doc);
         Dom.XMLNode responseNode = doc.getRootElement();
         String strNameSpace = responseNode.getNamespace();
         for(Dom.XMLNode child : responseNode.getChildElements()) {
           System.debug('Text : '+child.getText());
           Dom.XMLNode openShipMentNode = child.getChildElement('OpenShipment',strNameSpace);
           Dom.XMLNode processMessageNode = child.getChildElement('ProcessMessage',strNameSpace);
           system.debug('processMessageNode == '+processMessageNode);
        
          // XmlStreamReader streamReader = new XmlStreamReader(contentFile.toString());
          readXML(processMessageNode);
         }
         
        return null;
    }
    
    public  void readXML(Dom.XMLNode responseNode)
    {
        String strTrackingNumber = '';
        String strInvoiceNo = '';
        for(Dom.XMLNode mainNode : responseNode.getChildElements())
        {
            system.debug('mainNode == '+mainNode);
            system.debug('mainNode Type == '+mainNode.getNodeType());
            system.debug('mainNode Text == '+mainNode.getName());
            if (mainNode.getNodeType() == DOM.XMLNodeType.ELEMENT && mainNode.getName() == 'TrackingNumbers') {
                    
                    //system.debug('mainNode == '+mainNode);
                     for(Dom.XMLNode node : mainNode.getChildElements())
                     {
                        system.debug('node == '+node);
                        if(node.getNodeType() == DOM.XMLNodeType.ELEMENT)
                        {
                            strTrackingNumber = node.getText();
                        }
                     }
            }
            if (mainNode.getNodeType() == DOM.XMLNodeType.ELEMENT && mainNode.getName() == 'Reference2') {
                strInvoiceNo = mainNode.getText();
            }
        }
       system.debug('strTrackingNumber '+strTrackingNumber);
       system.debug('strInvoiceNo == '+strInvoiceNo);
       try
       {
           Bulk_Orders__c bo = [select id, Name ,Tracking_Number__c from Bulk_Orders__c  where Name =: strInvoiceNo];
           bo.Tracking_Number__c = strTrackingNumber;
           update bo;
       }
       catch(Exception ex)
       {
            

       }

       contentFile = null;
    }
 

   
}