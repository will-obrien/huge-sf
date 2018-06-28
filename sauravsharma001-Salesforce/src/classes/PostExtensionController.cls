public with sharing class PostExtensionController {
    public string key1{get;set;}
    string key =ApexPages.currentPage().getParameters().get('key');        
        public PostExtensionController(PostMethodImplementationController controller) {            
            key1=key;
    }
}