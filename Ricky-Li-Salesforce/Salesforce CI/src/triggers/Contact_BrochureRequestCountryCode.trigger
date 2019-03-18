trigger Contact_BrochureRequestCountryCode on Contact (before Insert, before Update) {
        List <Contact> contacts = new List<Contact>();
      //Set <Id> contactIds = new Set <Id>();
      //if(BrochureRequestTriggerController.getRunTimesContact() < 1){ 
              for(Contact con : trigger.new){
                     contacts.add(con);
              }
          //BrochureRequestTriggerController.setRunTimesContact();
          BrochureRequestTriggerController.BrochureRequest_Contact(contacts);
      //}
}