@RestResource(urlMapping='/contentEndPoint/*')
 
global with sharing class contentEndPoint {

	global class MyClass {
        public String s;
        public Integer i;

        public MyClass(String s, Integer i) {
            this.s = s;
            this.i = i;
        }
    }
     
    @HttpPOST
    global static List<MyClass> getContent(String username, String password) {
        
        MyClass obj = new MyClass('Hello', 1234);
        
        List<MyClass> returnObjs = new List<MyClass>();
		returnObjs.add(obj);
        
        List<String> passContentTypes = new List<String>();
        List<String> passTopics = new List<String>();
        List<String> passMediaTypes = new List<String>();
        
        passContentTypes.add('News');
        passTopics.add('all');
        passMediaTypes.add('all');
        
        List<sfdcAppRemoter.contentData> lstCont = sfdcAppRemoter.getContentBrowseDocsInternal('Risk News and Resources',passContentTypes,passTopics,passMediaTypes);
        
        system.debug('* * * Login ...'+  username + ':' + password);   
        
        return returnObjs; 
    }

    
}