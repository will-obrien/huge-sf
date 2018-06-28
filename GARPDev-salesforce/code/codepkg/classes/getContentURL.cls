public without sharing class getContentURL{

    public String ContentVersion { get; set; }

	public PageReference getContentURL() { 
		ContentVersion []cv=[select id, ContentDocumentId from ContentVersion where contentdocumentid='069f00000009MQTAA2']; 
		return new PageReference('/' + cv[0].id); 
	}    
    
}