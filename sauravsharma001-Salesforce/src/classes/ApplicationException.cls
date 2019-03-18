/*
 *   Class for Printing the Error Response thrown by Open311 Services in XML, JSON and JSONP format
 *   
 */

global class ApplicationException extends Exception   {

   public Blob vXmlException(String message, String code, String type, String callback)  {   
        
       String response = null;   
       String output = null;       
       RestContext.response.statuscode = Integer.valueOf(code);       
       
       // Printing Error response for JSON type
       if (type.equalsIgnoreCase('json'))   {
           
           if(callback == null)
               RestContext.response.addHeader('Content-Type', 'application/json; charset=utf-8');
           else
               RestContext.response.addHeader('Content-Type', 'application/javascript');
               
           JSONGenerator writer = JSON.createGenerator(true); 
           writer.writeStartArray();  
           writer.writeStartObject(); 
           writer.writeObjectField('code',code);
           writer.writeObjectField('description',message);
           writer.writeEndObject();      
           writer.writeEndArray();
           output = writer.getAsString();
           if(callback != null)    {
               output = callback + '(' + output + ' );';
           }
           output = output.replace('[','[\n');
           output = output.replace('" : "','":"');
           output = output.replace('" : ','":');
           output = output.replace(']','\n]');
           output = output.replace('}',' }'); 
           response = output;                              
       }   
       
       // Printing Error response for XML type  
       else  {  
      
           RestContext.response.addHeader('Content-Type', 'text/xml; charset=utf-8');                
           XmlStreamWriter writer = new XmlStreamWriter();
           writer.writeStartElement(null,'Errors',null);
           writer.writeStartElement(null,'Error',null);
           writer.writeStartElement(null,'code',null);
           writer.writeCharacters(code);
           writer.writeEndElement();
           writer.writeStartElement(null,'description',null);
           writer.writeCharacters(message);     
           writer.writeEndElement();
           writer.writeEndElement();
           writer.writeEndElement();     
           output = writer.getXmlString(); 
           response = output;                
       }  
        
   return blob.valueOf(response);
   }
}