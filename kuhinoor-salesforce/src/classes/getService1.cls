@RestResource(urlMapping='/Getservice')
Global Class getService1{
    @HttpGet
    global static String postRestMethod(){    
        return 'hi.. you invoked getService1 class';
    }
}