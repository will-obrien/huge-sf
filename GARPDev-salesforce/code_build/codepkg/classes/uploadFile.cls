public class uploadFile {
    
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
            if (mainNode.getNodeType() == DOM.XMLNodeType.ELEMENT && mainNode.getName() == 'Reference1') {
                strInvoiceNo = mainNode.getText();
            }
        }
       system.debug('strTrackingNumber '+strTrackingNumber);
       system.debug('strInvoiceNo == '+strInvoiceNo);
       try
       {
           Opportunity opp = [select id,Tracking_Number__c,Ups_Stage__c from opportunity where Display_Invoice_Number__c =: strInvoiceNo];
           opp.Tracking_Number__c = strTrackingNumber;
           opp.Ups_Stage__c = 'Completed';
           update opp;
       }
       catch(Exception ex)
       {
            

       }

       contentFile = null;
    }
 

   
}