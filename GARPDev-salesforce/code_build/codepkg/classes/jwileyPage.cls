public with sharing class jwileyPage {
    
    public String response {get; set;}
    public String errorResponse {get; set;}
    
    public jwileyPage() {
    }
    
	public PageReference save() {

        String sku = ApexPages.currentPage().getParameters().get('sku');
            
        PageReference pageRef = null;
            
		Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://onlinelibrary.wiley.com/login-proxy-tps?targetURL=http://onlinelibrary.wiley.com/resolve/doi?DOI=' + sku + '&domain=www.garp.org');
        req.setMethod('GET');
        HttpResponse res = http.send(req);
        
        response = String.valueOf(res.getBody());
            
        if(res.getStatusCode() != 200) {
    		errorResponse = 'There was an error opening your Journal.';
        } else {
            response = res.getBody();
            pageRef = new PageReference(response);
        }        
        
        return pageRef;
    }    
}