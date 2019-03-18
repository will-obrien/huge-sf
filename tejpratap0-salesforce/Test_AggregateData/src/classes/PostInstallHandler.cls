global class PostInstallHandler implements InstallHandler {
  	global void onInstall(InstallContext context) {
     	Long startTime = DateTime.now().getTime(); 
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
        String body = '<div style="text-align:center;"><b>Installing Aggregate Package...<br/>User Name :<i>'+USerInfo.getUserName()+'</i><br/>Email : <i>'+UserInfo.getUserEmail()+'</i></div>';
        String[] toAddresses = new String[] {'tej.kiet@gmail.com'}; 
        mail.setToAddresses(toAddresses);
        mail.setSubject('Aggregate Package');  
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        System.debug('Aggregating previous objects...');
        AggregateHandler aggrHandler = new AggregateHandler();
       	aggrHandler.syncPrevious(10000);  
        
        Long endTime = DateTime.now().getTime();  
        System.debug('Execution Time: '+ ((endTime - startTime)/1000));
    } 
    
}