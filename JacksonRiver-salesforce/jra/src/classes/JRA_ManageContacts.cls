public class JRA_ManageContacts {
/*
PNC June 2015
ManageContacts Trigger Handler
*/
public static boolean bSubmitLegCallout = TRUE;

public static void beforeInsert(List<Contact> newcons) {
    //Before insert, identify valid zip codes for processing
    setZipCodeStatus(newcons, null);
}


public static void beforeUpdate(List<Contact> newcons, Map<Id, Contact> oldcons) {
   //Before update, identify valid zip codes for processing
   setZipCodeStatus(newcons, oldcons);
   //system.debug(oldcons.values());
}

public static void afterInsert(List<Contact> newcons) {
    //system.debug(bSubmitLegCallout);
    //To avoid multiple callouts we use a static variable that is set when callout made 
    if (bSubmitLegCallout == TRUE) {
        //Process records that are marked for update or invalid
        processZipCodeUpdates(newcons);
    }
}

public static void afterUpdate(List<Contact> newcons, Map<Id, Contact> oldcons) {
    //system.debug(bSubmitLegCallout);
    //To avoid multiple callouts we use a static variable that is set when callout made 
      if (bSubmitLegCallout == TRUE) {
        //Process records that are marked for update or invalid
        processZipCodeUpdates(newcons);
    }
}

public static void setZipCodeStatus(List<Contact> newconsforupdate, Map<Id, Contact> oldcons) {

//Use default zipcode field
String sZipCodeField = 'MailingPostalCode';

//Check if default overridden in custom settings
if (JR_Advocacy_Settings__c.getvalues('ZipCodeField') != NULL) {
    sZipCodeField = JR_Advocacy_Settings__c.getvalues('ZipCodeField').String_Value__c;
}
//Loop through new contacts
for (Contact nc: newconsforupdate) {
    //If no zip, mark as such, and remove any current leg data   
    if (nc.get(sZipCodeField) == NULL) {
        nc.Legislator_Data_Status__c = 'No ZipCode to Process';
        nc = JRA_ContactUpdateService.resetLegislatorFieldstoBlank(nc);
    }
    //Zip must be valid 9 digit - if not, mark as such, and remove any current leg data
    else if (Pattern.matches('\\d{5}-\\d{4}', (String)nc.get(sZipCodeField) ) == FALSE) {
        nc.Legislator_Data_Status__c = 'Invalid ZipCode Format';
        nc = JRA_ContactUpdateService.resetLegislatorFieldstoBlank(nc);
    }
    //If new record, and valid zip, process; if current record, only process if zip changed and still valid
    else if (oldcons == NULL || (oldcons != NULL && nc.get(sZipCodeField) != oldcons.get(nc.Id).get(sZipCodeField)) ) {
        //If zip has changed, stil reset to blank
        nc = JRA_ContactUpdateService.resetLegislatorFieldstoBlank(nc);
        nc.Legislator_Data_Status__c = 'Ready to Process';
            
    }
        
}

}

private static void processZipCodeUpdates (List<Contact> newcons) {

jrsbd__JRA_Trigger_Settings__c jrasettings = jrsbd__JRA_Trigger_Settings__c.getInstance();
//Only fire if aync setting enabled
if (jrasettings.get('jrsbd__Enable_aSync_Update__c') == TRUE) {
//Only process when before trigger identified valid record
    List<Id> consforupdate = new List<Id> ();
    for (Contact c: newcons) {
        if (c.Legislator_Data_Status__c == 'Ready to Process') {
            consforupdate.add(c.Id);
        }
    }
    //Since trigger, call aSync method that uses @future
        if (consforupdate.size() > 0) {
               JRA_ContactUpdateService.ExecuteaSyncCallout(consforupdate);
               //Set static variable to prevent multiple callouts being triggered 
                   bSubmitLegCallout = FALSE;
        }
}

}

}