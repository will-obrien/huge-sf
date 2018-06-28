@RestResource(urlMapping='/getjString')
Global class getjstringController{
    @HttpGet
    Global static String demo(){
        List<contact> conlist = [ select lastname from contact limit 20 ];
        
        /*JSONGenerator generator = JSON.createGenerator(true);   //instantiation of the generator
        generator.writeStartObject();                           // Writes the starting marker of a JSON object '{'
        generator.writeNumberField('count', conlist.size());   //Writes the # of contacts 
        generator.writeEndObject();                             //Writes the ending marker of a JSON object '}'
        String jstring = generator.getAsString();
        System.debug('***********'+jstring);*/
        //return jsonString;
        String str =  JSON.serialize(conlist);
        System.debug('***********'+str );     
        return 'hiiii.....';   
    }
}