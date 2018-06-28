public without sharing class Endpoint_Controller {
 
public String debugInfo {get; set;}{
 
debugInfo = '';

if (ApexPages.currentPage() != null){
// Incoming Headers
debugInfo += '\n***ALL INCOMING HEADERS ***\n';
for (string key: ApexPages.currentPage().getHeaders().keySet()){
if (ApexPages.currentPage().getHeaders().get(key) != null){
debugInfo += key + ' = ' + ApexPages.currentPage().getHeaders().get(key) + '\n';
}
}
 
// Incoming Parameters
debugInfo += '\n***ALL INCOMING PARAMETERS ***\n';
for (string key: ApexPages.currentPage().getParameters().keySet()){
if (ApexPages.currentPage().getParameters().get(key) != null){
debugInfo += key + ' = ' + ApexPages.currentPage().getParameters().get(key) + '\n';
}
}
 
// Other Page Reference Stuff
debugInfo += '\n***OTHER PAGE REFERENCE INFO ***\n';
debugInfo += 'Anchor: ' + ApexPages.currentPage().getAnchor() + '\n';
debugInfo += 'URL: ' + ApexPages.currentPage().getUrl() + '\n';
}
system.debug(debugInfo);
}
 
public Endpoint_Controller(){}
 
public PageReference init() {
 
Task t = new Task();
t.Subject = 'Endpoint Invoked';
t.Description = debugInfo;
t.ActivityDate = Date.Today();
insert t;
 
return null;
 
}

}
