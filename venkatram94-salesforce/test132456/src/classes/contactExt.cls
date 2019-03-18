public with sharing class contactExt {
    
    public Contact c{get;set;}
    
    public contactExt(ApexPages.StandardController controller) {
        c=(Contact)Controller.getRecord();
    }
    
    public pageReference save() {
        pageReference pRef = new pageReference('/003/e?retURL=%2F003%2Fo');
        return pRef;
    }
}