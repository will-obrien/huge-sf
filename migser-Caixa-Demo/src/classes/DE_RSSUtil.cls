public class DE_RSSUtil {
	
    public static List<DE_RSSObject> getRSSFeedObjects(String theUrl) {
        List<DE_RSSObject> toReturn = new List<DE_RSSObject>();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(theUrl);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        System.debug(res);
        XmlStreamReader reader = res.getXmlStreamReader();
        boolean hasElements = true;
        
        while(hasElements) {
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                //System.debug('^^^^' + reader.getLocalName());
                if ('item' == reader.getLocalName()) {
                    DE_RSSObject item = parseItem(reader);
                    toReturn.add(item);
                }
            }
            if (reader.hasNext()) {
                reader.next();
            } else {
                hasElements = false;
                break;
            }
        } 
        
        return toReturn;
        
    }
    
    public static DE_RSSObject parseItem(XMLStreamReader reader) {
        DE_RSSObject toReturn = new DE_RSSObject();
        boolean hasElements = true;
        while(hasElements) {
            if (reader.getEventType() == XmlTag.END_ELEMENT &&
               'item' == reader.getLocalName()) {
                hasElements = false;  
                break;
            }
            if (reader.getEventType() == XmlTag.START_ELEMENT) {
                //System.debug('****' + reader.getLocalName() + '~~~~' + reader.getNamespace());
                if ('title' == reader.getLocalName() && reader.getNamespace() == null) {
                        String title = parseString(reader);
                        toReturn.title = title;
                }
                if ('link' == reader.getLocalName() && reader.getNamespace() == null) {
                        String link = parseString(reader);
                        toReturn.url = link;
                }
                if ('pubDate' == reader.getLocalName() ) {
                        String pubDate = parseString(reader);
                        toReturn.setPubDate(pubDate);
                } 
                if ('description' == reader.getLocalName() ) {
                        String description = parseString(reader);
                        toReturn.description = description;
                }                 

            }
            // Always use hasNext() before calling next() to confirm 
            // that we have not reached the end of the stream
            if (reader.hasNext()) {
                reader.next();
            } else {
                hasElements = false;
                break;
            }
        }        
       
        return toReturn;
    }
    
    public static String parseString(XmlStreamReader reader) {
        String ret = '';

        boolean hasElements = true;
        while(hasElements) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                ret = ret + reader.getText();
            } else if (reader.getEventType() == XmlTag.CDATA) {
                ret = reader.getText();
            }
            if (reader.hasNext()) {
                reader.next();
            } else {
                hasElements = false;
                break;
            }
        }
        return ret.trim();
    }
}