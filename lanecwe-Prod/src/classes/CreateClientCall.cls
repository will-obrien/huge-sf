public class CreateClientCall{

    public class CreateClientCallRequest{
        public String                          HowHeardCode;   //"WB",// (WB)(optional)
        public String                          POCC;           //"",// (optional)
        public String                          SpecialInfo;    //"",// (optional)
        public String                          CompanyId;      //"781357",//  (Required, a valid company id should be passed)
        public String                          ExternalId;     //"",// (optional)
        public String                          RoleCode;       //"3", //(optional)
        public String                          DoNotSolicit;   //"",//(False)(optional)
        public String                          TimeZoneCode;   //"ESTRN-BASE",// (you can pass or use some default)
        public String                          FirstName;      //"Testing",// (Required)
        public String                          LastName;       //"Testing PGi",//  (Required)
        public String                          JobTitle;       //"Developer",// (Required)
        public String                          Phone;          //"333-333-3333",// (Required)
        public String                          PhoneIsDefault; //"FALSE",// (False)(optional)
        public String                          HomePhoneIsDefault; //"FALSE",//(False)(optional)
        public String                          MobilePhoneIsDefault;   //"FALSE",//(False)(optional)
        public String                          Address1;       //"10 Main Street",// (Required)
        public String                          Address2;       //"Suite 101",// (Required, or can be blank)
        public String                          City;           //"Atlanta",// (Required)
        public String                          StateCode;      //"GA",// (Required, when country code is USA)
        public String                          Province;       //"",//  (Required, when country code is not USA)
        public String                          CountryCode;    //"USA",// (Required)
        public String                          PostalCode;     //"30068",//  (Required)
        public String                          Email;          //"hema.naredla@pgi.com",//(Required)
        public String                          HubId;          //"259350",//(Required, a valid HubId is required)
        public String                          ENV;            //"DEV",//  should be DEV, QA, or PROD
        public String                          webID;          //"1973568",//DEV
        public String                          webPwd;         //"nI$DE6LT1#U",// DEV
        public String                          ClientID;       //"7216225",//DEV
        public String                          ClientPwd;      //"pgiPr@v1der",// DEV
        public String                          action;         //"SubscriberCreate",//  (Required)
        public String                          PlanType;       //"Audio",//  (Required)    
        public String                          Ponumber;       //"",// (optional)
        public String                          RoomName;       //"pgitesternar1",// (Required) should be unique always if not will return an error
        public String                          username;       //"restapitesting",// (Required)
        public String                          password;       //"password1234" // (Required)
        public string                          pwd;

    
        public CreateClientCallRequest (){
            Integrationparameters__c integ = Integrationparameters__c.getInstance('ClientCreate');
            this.HowHeardCode   =   'WB';
            this.POCC           =   '';
            this.SpecialInfo    =   '';
            this.ExternalId     =   '';
            this.RoleCode       =   '3';
            this.DoNotSolicit   =   '';
            this.TimeZoneCode   =   'ESTRN-BASE';
            this.PhoneIsDefault     =   'FALSE';
            this.HomePhoneIsDefault =   'FALSE';
            this.MobilePhoneIsDefault   =   'FALSE';
            this.env            =   integ.env__c;
            this.webID          =   integ.webid__c;
            this.webPwd         =   integ.webpwd__c;
            this.ClientID       =   integ.clientid__c;
            this.clientPwd      =   integ.clientPwd__c;
            this.action         =   integ.action__c;
            this.username       =   integ.username__c;
            this.password       =   integ.password__c;
            this.pwd            = '';
        }   
    }
    
    public class CreateClientCallResponse{
        public Integer                         confID;             // 4218389,
        public Integer                         moderatorPassCode;  // 6682551
        public String                          participantPassCode;// "668255",
        public String                          listenOnlyPassCode; // "6682558",
        public String                          confPhoneNumber1;   // "1-719-457-0613",
        public String                          confPhoneNumber2;   // "1-800-689-9374",
        public String                          confPhoneNumber3;   // null,
        public String                          status;             // "OK",
        public Integer                         clientId;           // 9709933,
        public String                          hubUrl;             // "pgitestcointernationallimited2244.itdev.local", 
        public ClientCallResponse              clientCallResponse;
        public ReservationCallResponse         ReservationCallResponse;
        public String                          Errorcode;
        public String                          Message;
        
        public CreateClientCallResponse(){
            confId = 0;
            moderatorPassCode = 0;
            participantPassCode = '';
            listenOnlyPassCode = '';
            confPhoneNumber1 = '';
            confPhoneNumber2 = '';
            confPhoneNumber3 = '';
            status = '';
            clientId = 0;
            hubUrl = '';
            clientCallResponse = new ClientCallResponse();
            ReservationCallResponse = new ReservationCallResponse();
            Errorcode = '';
            Message = '';
            
        }
    }
    
    public class ClientCallResponse{
        public ClientCreateResult              clientCreateResult; 
        public ClientCallResponse(){
            clientCreateResult = new ClientCreateResult();
        }
    }
    
    public class ReservationCallResponse{
        public ReservationCreateResult         reservationCreateResult;
        public ReservationCallResponse(){
            reservationCreateResult = new ReservationCreateResult();
        }
    }
    
    public class ClientCreateResult{
        public String                          correlationId;  // null,
        public list<String>                    errors;
        public Integer                         executionTime;  // 171,
        public String                          messageId;      // "d8ff9985-29d9-4e8e-be11-1fc8356a8a4f",
        public DateTime                        serverDateTime; // "2014-10-05T12:23:02.6814917Z",
        public Integer                         confId;         // 4218389
        public ClientHierarchy                 clientHierarchy;
        public Integer                         ClientId;
        public ClientCreateResult(){
            correlationId = '';
            errors = new list<string>();
            executionTime = 0;
            messageId = '';
            serverDateTime = System.now();
            confId = 0;
            clientHierarchy = new ClientHierarchy();
            ClientId = 0;
        }
    }
    
    public class ClientHierarchy{
        public Integer                         companyId;      // 781357,
        public String                          companyName;    // "PGiTestcoInternationalLimited2244",
        public Integer                         corporateCustomerId; // 0,
        public String                          corporateCustomerName; // "Default CorporateCustomer",
        public Integer                         enterpriseId;   // 1770,
        public String                          enterpriseName; // "GlobalMeet_mB1_Online",
        public String                          enterpriseType; // "1",
        public Integer                         hubGroupId;     // 259252,
        public String                          hubGroupName;   // "pgitestcointernationallimited2244",
        public Integer                         hubId;          // 259350,
        public String                          hubName;        // "pgitestcointernationallimited2244",
        public String                          hubUrl;         // "pgitestcointernationallimited2244.itdev.local",
        public Integer                         providerId;     // 1,
        public String                          providerName;   // "Premiere Global Services",
        public String                          providerType;   // "1"
        public ClientHierarchy(){
            companyId = 0;
            companyName = '';
            corporateCustomerId = 0;
            corporateCustomerName = '';
            enterpriseId = 0;
            enterpriseName = '';
            enterpriseType = '';
            hubGroupId = 0;
            hubGroupName = '';
            hubId = 0;
            hubName = '';
            hubUrl = '';
            providerId = 0;
            providerName = '';
            providerType = '';  
        }
    }
    
    public class ReservationCreateResult{
        public String                          correlationId;  // null,
        public list<String>                    errors;
        public Integer                         executionTime;  // 171,
        public String                          messageId;      // "d8ff9985-29d9-4e8e-be11-1fc8356a8a4f",
        public DateTime                        serverDateTime; // "2014-10-05T12:23:02.6814917Z",
        public Integer                         confId;         // 4218389  
        public PassCodes                       passCodes;
        public PhoneNumbers                    phoneNumbers;
        
        public ReservationCreateResult(){
            correlationId = '';
            errors = new list<String>();
            executionTime = 0;
            messageId = '';
            serverDateTime = system.now();
            confId = 0;
            passCodes =  new PassCodes();
            phoneNumbers = new PhoneNumbers();
        }
    }
    
    public class PassCodes{
        public String                          moderatorPassCode;  // "6682551",
        public String                          participantPassCode;// "668255",
        public String                          securityCode;       // null,
        public String                          listenOnlyPassCode; // "6682558"
        public PassCodes(){
            moderatorPassCode = '';
            participantPassCode = '';
            securityCode = '';
            listenOnlyPassCode = '';
        }
    }

    public class Errors{
        public list<ApiError>                   ApiError;
        public Errors(){
            ApiError = new list<ApiError>();
        }
    }
    
    public class ApiError{
        public Integer                          Code;
        public String                           Message;
        public string                           Parameter;
        public string                           ParameterValue;
        public string                           Severity;
        public string                           Source;
        public string                           Client;
        public ApiError(){
            Code = 0;
            Message = '';
            Parameter = '';
            ParameterValue = '';
            Severity = '';
            Source = '';
            Client = '';
        }
    }
    
    public class PhoneNumbers{
        public list<ReservationPhoneNumber>    reservationPhoneNumber;
        public PhoneNumbers(){
            reservationPhoneNumber = new list<ReservationPhoneNumber>();
        }
    }
    public class ReservationPhoneNumber{
        public String                          customLocation; // null,
        public String                          customPhoneType;// null,
        public String                          location;       // null,
        public String                          locationCode;   // null,
        public String                          phoneNumber;    // "1-719-457-0613",
        public String                          phoneType;      // "2"
        
        public ReservationPhoneNumber(){
            customLocation  = null;
            customPhoneType = null;
            location = null;
            locationCode = null;
            phoneNumber = null;
            phoneType = null;
        }
    }
}