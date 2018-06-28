trigger ChatterTrigger on FeedItem (before insert, after update) {
   
    system.debug('Trigger Feeds...');
    List<FeedItem> feeds = new List<FeedItem>();
    User auser = [select id , name from user where id='00558000000nJmkAAE'];

// if (Trigger.IsUpdate ) {
      system.debug('Update en el feed...');
      List<FeedAttachment> attachments =  [SELECT Id, Title, Type, FeedEntityId , recordId
                                         FROM FeedAttachment 
                                         WHERE FeedEntityId IN :Trigger.new ];
     
    
    for (FeedAttachment attachment : attachments) {
        System.debug(attachment.Type);
         system.debug('El nuevo content version es... '+attachment.RecordId);
    }
 //   }

    if (Trigger.IsInsert ) {
       for (FeedItem f : Trigger.new) {
        if (f.body!=null) {
           system.debug('Body:' +f.body);
          }
          system.debug('Community: '+f.NetworkScope);
          system.debug('Type: '+f.Type);
          system.debug('Visibility: '+f.Visibility);
          system.debug('Creador: '+userinfo.getuserid());
          system.debug('Tipo de Objeto' +findObjectNameFromRecordIdPrefix(f.parentid));
          if (findObjectNameFromRecordIdPrefix(f.parentid)=='Account'&&userinfo.getuserid()=='00558000000nJmkAAE')
            {
              f.Visibility='AllUsers';
            //  feeds.add(f);
          }
          if (findObjectNameFromRecordIdPrefix(f.parentid)=='Account'&&f.body!=null&&f.body.toUpperCase().trim().equals('DNI')&&f.Type.equals('ContentPost')) {
            system.debug('Nuevo DNI subido a la cuenta con ID...'+f.parentid);
           // system.debug('El contenido es...'+f.ContentData);
           // system.debug('Y el tamaño...'+f.ContentData.size());
          }

               }
        //update(feeds);
}

        public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
            String objectName = '';
            try{
                //Get prefix from record ID
                //This assumes that you have passed at least 3 characters
                String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
                 
                //Get schema information
                Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
                 
                //Loop through all the sObject types returned by Schema
                for(Schema.SObjectType stype : gd.values()){
                    Schema.DescribeSObjectResult r = stype.getDescribe();
                    String prefix = r.getKeyPrefix();
                //    System.debug('Prefix is ' + prefix);
                     
                    //Check if the prefix matches with requested prefix
                    if(prefix!=null && prefix.equals(myIdPrefix)){
                        objectName = r.getName();
                 //       System.debug('Object Name! ' + objectName);
                        break;
                    }
                }
            }catch(Exception e){
                System.debug(e);
            }
            return objectName;
        
    
  }
}