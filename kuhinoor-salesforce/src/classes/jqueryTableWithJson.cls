public Class jqueryTableWithJson{
    Public String jstr{get;set;}
    String fname;
    String lname;
    String phone;
    Public List<Contact> conList;
    Public jqueryTableWithJson(){
        conList= new List<Contact>();
    }
    public void receiveJsonString(){
     System.debug('***********'+jstr);
        list<Contact> con =(List<Contact>)JSON.deserialize(jstr, List<Contact>.class);
        insert con;
       
       /* JSONParser parser = JSON.createParser(jstr);
       
       
        while (parser.nextToken() != null) {
        
            while(parser.nextToken() != JSONToken.END_ARRAY){
          
            Contact con = new Contact();
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)) {
                String fieldName = parser.getText();
                                
                if(fieldName == 'FirstName'){
                     fname = parser.getText();
                     con.firstname = fname;
                   
                }
                if(fieldName == 'LastName'){
                    lname = parser.getText();
                    con.lastname=lname;
                   System.debug('****************'+lname );
                   
                }
                if(fieldName == 'Phone'){
                    phone= parser.getText();
                    Con.phone = phone;
                    
                }
                parser.nextToken();   
                 conList.add(con);                
            }
           
          }                   
        }  
        system.debug('###############'+conList.size());
        //insert ConList;  */
        
    }
  Public Void model(){
      
  }  
}