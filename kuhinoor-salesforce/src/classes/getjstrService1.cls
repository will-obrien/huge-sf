@RestResource(urlMapping='/Getjstrservice')
Global Class getjstrService1{
    @HttpGet
    global static List<Contact> postRestMethod(){   
        List<contact>conlist = [ select lastname from contact limit 10];
       
        
        //String str = JSON.serialize(conlist); 
        return conlist;
    }
}