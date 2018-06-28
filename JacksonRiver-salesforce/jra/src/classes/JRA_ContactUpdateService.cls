public with sharing class JRA_ContactUpdateService{
/*
PNC June 2015
Class to update Legislator data on Contacts via JRA API 
*/

public List<Contact> consforupdate;
private Map<String, List<JRA_JSONReponse> > LegislatorMap;
private String sZipCodeField;
private JRA_CalloutServiceHandler LegServiceCallout;

public JRA_ContactUpdateService() {
//Default zipcode field
sZipCodeField = 'MailingPostalCode';

//Use new zipcode field if changed in settings
if (JR_Advocacy_Settings__c.getvalues('ZipCodeField') != NULL) {
    if (String.IsEmpty(JR_Advocacy_Settings__c.getvalues('ZipCodeField').String_Value__c) == FALSE) {
        sZipCodeField = JR_Advocacy_Settings__c.getvalues('ZipCodeField').String_Value__c;
    }
}
//Enable Callout Handler
LegServiceCallout = new JRA_CalloutServiceHandler();
}

//Execute callout with list of contact records (synchronous callout, or callout from batch)
public void executecallout (List<Contact> consforupdate) {
    this.consforupdate = consforupdate;
    ProcessContacts();
}

//Used when coming from async queue e.g. @future
public void executecallout (List<Id> idsforupdate) {

//Requery to enable aysnc service to work with handler
String sQuery = 'Select Id, Legislator_Data_Status__c, ';
    sQuery += sZipCodeField;
    sQuery += ' FROM CONTACT WHERE Id IN :idsforupdate';

consforupdate = database.query(sQuery);
ProcessContacts();
}

//Method to actually process contacts
private void ProcessContacts() {
    for (Contact nc: consforupdate) {
    //Recheck Zipcode    
        String sZip = '';
        if (Pattern.matches('\\d{5}-\\d{4}', (String)nc.get(sZipCodeField) ) == TRUE) {
            sZip = (String)nc.get(sZipCodeField);
            //LegServiceCallout = new JRA_CalloutServiceHandler();
            if (LegServiceCallout.retrieveData(sZip) == TRUE) {
                try {
                    LegislatorMap = JRA_JSONReponse.getLegislatorMap(LegServiceCallout.sFinalResponse);
                //system.debug(LegislatorMap);
                    UpdateContactLegislators(nc);
                    nc.Legislator_Data_Status__c = 'Processed';
                }
                catch (Exception Ex) {
                    JRA_ErrorHandler.addErrorMessage(ex.getMessage(), NULL);
                    nc.Legislator_Data_Status__c = 'Error with Service';
                }    
            }
            else { 
                //Callout failed
                resetLegislatorFieldstoBlank(nc);
                nc.Legislator_Data_Status__c = 'Invalid Response';
            }
        }
        else {
            //bad zipcode - will mostly happen when zip changed since aysnc request was made
            resetLegislatorFieldstoBlank(nc);
            nc.Legislator_Data_Status__c = 'Invalid ZipCode';
            
        }
    }    
    
}

//Take Callout Response and set fields on Contact
private void UpdateContactLegislators(Contact con) {
//Response will return two senators - need to identify senior vs junior
JRA_JSONReponse SeniorSenator;
JRA_JSONReponse JuniorSenator;
List<String> sPhones;

if (LegislatorMap.containskey('FS') ) {
List<JRA_JSONReponse> Senators = LegislatorMap.get('FS');
//Are there two?
if (Senators.size() > 1 ) {
//Check Rank - higher = junior
    if ( Integer.ValueOf(Senators[0].rank) >  Integer.ValueOf(Senators[1].rank) ) {
        JuniorSenator = Senators[0];
        SeniorSenator = Senators[1];
    }
    else {
        JuniorSenator = Senators[1];
        SeniorSenator = Senators[0];
    }

}
else {
//If only one, must be senior
SeniorSenator = Senators[0];
}

    con.Sr_Federal_Senator__c = SeniorSenator.Salutation + ' ' + SeniorSenator.first_name + ' ' +  SeniorSenator.last_name;
    con.Sr_Federal_Senator_Facebook__c = SeniorSenator.facebook;
    con.Sr_Federal_Senator_Twitter__c = SeniorSenator.twitter;     
    con.Sr_Federal_Senator_Webform__c = SeniorSenator.webform_url;
    //Need to identify phones appling to Capitol vs District
    sPhones = getPhoneNumbers(SeniorSenator.addresses, 'Fed Capitol');
    if (String.IsEmpty(sPhones[0]) == FALSE) {
        con.Sr_Federal_Senator_DC_office__c = sPhones[0];
    }
    if (String.IsEmpty(sPhones[1]) == FALSE) {
        con.Sr_Federal_Senator_District_Office__c = sPhones[1];
    }
                 

if (JuniorSenator != NULL) {

 con.Jr_Federal_Senator__c = JuniorSenator.Salutation + ' ' + JuniorSenator.first_name + ' ' +  JuniorSenator.last_name;
    con.Jr_Federal_Senator_Facebook__c = JuniorSenator.facebook;
    con.Jr_Federal_Senator_Twitter__c = JuniorSenator.twitter;     
    con.Jr_Federal_Senator_Webform__c = JuniorSenator.webform_url;
    sPhones = getPhoneNumbers(JuniorSenator.addresses, 'Fed Capitol');
    if (String.IsEmpty(sPhones[0]) == FALSE) {
        con.Jr_Federal_Senator_DC_office__c = sPhones[0];
    }
    if (String.IsEmpty(sPhones[1]) == FALSE) {
        con.Jr_Federal_Senator_District_Office__c = sPhones[1];
    }
       
}

}


if (LegislatorMap.containskey('FR') ) {
JRA_JSONReponse JRA = LegislatorMap.get('FR')[0];
    con.Federal_District__c = JRA.district_code;
    con.Federal_Rep__c = JRA.Salutation + ' ' + JRA.first_name + ' ' +  JRA.last_name;
    con.Federal_Rep_Facebook__c = JRA.facebook;
    con.Federal_Rep_Twitter__c = JRA.twitter;     
    con.Federal_Rep_Webform__c = JRA.webform_url;
     sPhones = getPhoneNumbers(JRA.addresses, 'Fed Capitol');
    if (String.IsEmpty(sPhones[0]) == FALSE) {
        con.Federal_Rep_DC_Office__c = sPhones[0];
    }
    if (String.IsEmpty(sPhones[1]) == FALSE) {
        con.Federal_Rep_District_Office__c = sPhones[1];
    }
    
}


if (LegislatorMap.containskey('SR') ) {                          

JRA_JSONReponse JRA = LegislatorMap.get('SR')[0];
    con.State_House_District__c = JRA.district_code;
    con.State_Rep__c = JRA.Salutation + ' ' + JRA.first_name + ' ' +  JRA.last_name;
    if (String.IsEmpty(JRA.Email) == FALSE) {
        con.State_Rep_Email__c = JRA.email;
    }
    con.State_Rep_Facebook__c = JRA.facebook;
    con.State_Rep_Twitter__c = JRA.twitter;     
    //con.Federal_Rep_Webform__c = JRA.webform_url;
    sPhones = getPhoneNumbers(JRA.addresses, 'State Capitol');
    if (String.IsEmpty(sPhones[0]) == FALSE) {
        con.State_Rep_Phone__c = sPhones[0];
    }
    
 }

if (LegislatorMap.containskey('SS') ) {                          

JRA_JSONReponse JRA = LegislatorMap.get('SS')[0];
    con.State_Senate_District__c = JRA.district_code;
    con.State_Senator__c = JRA.Salutation + ' ' + JRA.first_name + ' ' +  JRA.last_name;
    if (String.IsEmpty(JRA.Email) == FALSE) {
        con.State_Senator_Email__c = JRA.email;
    }
    con.State_Senator_Facebook__c = JRA.facebook;
    con.State_Senator_Twitter__c = JRA.twitter;     
    //con.Federal_Rep_Webform__c 
    sPhones = getPhoneNumbers(JRA.addresses, 'State Capitol');
    if (String.IsEmpty(sPhones[0]) == FALSE) {
        con.State_Senator_Phone__c = sPhones[0];
    }
    
  }

if (LegislatorMap.containskey('GOVNR') ) {                          

JRA_JSONReponse JRA = LegislatorMap.get('GOVNR')[0];
    con.Governor__c = JRA.Salutation + ' ' + JRA.first_name + ' ' +  JRA.last_name;
    if (String.IsEmpty(JRA.Email) == FALSE) {
        con.Governor_Email__c = JRA.email;
    }
    con.Governor_Facebook__c = JRA.facebook;
    con.Governor_Twitter__c   = JRA.twitter;     
    con.Governor_Webform__c = JRA.webform_url;
    sPhones = getPhoneNumbers(JRA.addresses, 'State Exec Office');
    if (String.IsEmpty(sPhones[0]) == FALSE) {
        con.Governor_Phone__c = sPhones[0];
    }    
   
}
             

}

//DML must happen after all callouts, so this method executes all DML
public boolean executeupdate() {
Boolean bSuccess = FALSE;
try {
//Write to save result - allow any successes to be written, and capture errors
Database.SaveResult[] srList = database.update(consforupdate, false);
    
// Iterate through each returned result by integer so we can access Id
for(Integer i=0;i<srList.size();i++){

Database.SaveResult sr = srList[i];
//Contact list will match save result list, so can match Id to save result
Id ContactId = consforupdate[i].Id;
    if (sr.isSuccess() == FALSE) {
        // Operation failed, so get all errors                
        String sErrors = ''; 
        for(Database.Error err : sr.getErrors()) {
            sErrors += 'Code' + err.getStatusCode() + ':' + err.getMessage() + '\n';
            sErrors += 'Fields involved: ' + err.getFields();
        }
     //Call error handler to write to error logs
     JRA_ErrorHandler.addErrorMessage(sErrors, ContactId);
    }
    
}
//If we got a new access token, update setting now
    if(LegServiceCallout.bUpdateSetting == TRUE) {
        LegServiceCallout.updateToken();
    }

    bSuccess = true;
}
Catch (Exception Ex) {
    system.debug(Ex);
    JRA_ErrorHandler.addErrorMessage(ex.getMessage(), NULL);
}
//Finally, write any errors to logs
JRA_ErrorHandler.SaveErrors();
return bSuccess;
}
//Process phone numbers basedon type of office in response
private List<String> getPhoneNumbers(List<JRA_JSONReponse.addresses> jaddr, String sCapitol) {
List<String> sPhoneList = new List<String> {'',''};
for (JRA_JSONReponse.addresses addr: jaddr) {
            if (addr.Type == sCapitol) {
                sPhoneList[0] = '(' + addr.area_code + ') ' + addr.phone;
            }
            else {
                sPhoneList[1] = '(' + addr.area_code + ') ' + addr.phone;
            }
    }
return sPhoneList;
}

public static void ExecuteaSyncCallout(List<Id> ContactIds) {
    //To avoid limits, only process via @future for less than 50 in trigger
    //system.debug(ContactIds.size());
    if (ContactIds.size() <= 50 && system.isbatch() == FALSE && system.isfuture() == FALSE) {
        processaSyncCallout(ContactIds);
    }
}
//Enable update to be called from trigger
@future (callout=true)
public static void processaSyncCallout(List<Id> ContactIds) {
    JRA_ContactUpdateService JRACUS = new JRA_ContactUpdateService();
    JRACUS.executecallout(ContactIds);
    JRACUS.executeupdate();
}
//When no response/bad zip, simple utility to reset leg data to blank
public static Contact resetLegislatorFieldstoBlank(Contact con) {

con.Sr_Federal_Senator__c = NULL;
con.Sr_Federal_Senator_Facebook__c = NULL;
con.Sr_Federal_Senator_Twitter__c = NULL;     
con.Sr_Federal_Senator_Webform__c = NULL;
con.Sr_Federal_Senator_DC_office__c = NULL;
con.Sr_Federal_Senator_District_Office__c = NULL;

con.Jr_Federal_Senator__c = NULL;
con.Jr_Federal_Senator_Facebook__c = NULL;
con.Jr_Federal_Senator_Twitter__c = NULL;     
con.Jr_Federal_Senator_Webform__c = NULL;
con.Jr_Federal_Senator_DC_office__c = NULL;
con.Jr_Federal_Senator_District_Office__c = NULL;

con.Federal_District__c = NULL;
con.Federal_Rep__c = NULL;
con.Federal_Rep_Facebook__c = NULL;
con.Federal_Rep_Twitter__c = NULL;     
con.Federal_Rep_Webform__c = NULL;
con.Federal_Rep_DC_Office__c = NULL;
con.Federal_Rep_District_Office__c = NULL;

con.State_House_District__c = NULL;
con.State_Rep__c = NULL;
con.State_Rep_Email__c = NULL;
con.State_Rep_Facebook__c = NULL;
con.State_Rep_Twitter__c = NULL;     
con.State_Rep_Phone__c = NULL;

con.State_Senate_District__c = NULL;
con.State_Senator__c = NULL;
con.State_Senator_Email__c = NULL;
con.State_Senator_Facebook__c = NULL;
con.State_Senator_Twitter__c = NULL;     
con.State_Senator_Phone__c = NULL;

con.Governor__c = NULL;
con.Governor_Email__c = NULL;
con.Governor_Facebook__c = NULL;
con.Governor_Twitter__c   = NULL;     
con.Governor_Webform__c = NULL;
con.Governor_Phone__c = NULL;

return con;
}

}