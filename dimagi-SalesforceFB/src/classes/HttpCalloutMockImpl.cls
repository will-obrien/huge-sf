@isTest
public class HttpCalloutMockImpl implements HttpCalloutMock {

    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String, String> responseHeaders;

    private HttpCalloutMockImpl(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseHeaders = responseHeaders;
    }

    public HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        for (String key : this.responseHeaders.keySet()) {
            res.setHeader(key, this.responseHeaders.get(key));
        }
        res.setBody(this.body);
        res.setStatusCode(this.code);
        res.setStatus(this.status);
        return res;
    }

    public static HttpCalloutMockImpl createLoginClassHttpMock_FailedLogin() {
        string body = '<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:sf="urn:fault.partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><soapenv:Fault><faultcode>sf:INVALID_LOGIN</faultcode><faultstring>INVALID_LOGIN: Invalid username, password, security token; or user locked out.</faultstring><detail><sf:LoginFault xsi:type="sf:LoginFault" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:sf="urn:fault.partner.soap.sforce.com"><sf:exceptionCode>INVALID_LOGIN</sf:exceptionCode><sf:exceptionMessage>Invalid username, password, security token; or user locked out.</sf:exceptionMessage></sf:LoginFault></detail></soapenv:Fault></soapenv:Body></soapenv:Envelope>';
        return new HttpCalloutMockImpl(500, 'Server Error', body, new Map<String, String> {'Content-Type' => 'application/xml'});
    }

    public static HttpCalloutMockImpl createLoginClassHttpMock_SuccessfulLogin() {
        string body = '<?xml version="1.0" encoding="UTF-8"?><Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="urn:partner.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Body><loginResponse><result><metadataServerUrl>https://dimagi--DSandbox.cs20.my.salesforce.com/services/Soap/m/29.0/00Dm00000001wJb</metadataServerUrl><passwordExpired>false</passwordExpired><sandbox>true</sandbox><serverUrl>https://dimagi--DSandbox.cs20.my.salesforce.com/services/Soap/u/29.0/00Dm00000001wJb</serverUrl><sessionId>00Dm00000001wJb!AQYAQIbpba9u7nvv1qrSFfiOv5Qma9sG.vgKc.NZySLVjzdwCSycoc0TYcUfsVoLJwGHU5kYIEd0tK3OHXm._u_hxwwXxkyx</sessionId><userId>005m0000001UuiTAAS</userId><userInfo><accessibilityMode>false</accessibilityMode><currencySymbol>$</currencySymbol><orgAttachmentFileSizeLimit>5242880</orgAttachmentFileSizeLimit><orgDefaultCurrencyIsoCode>USD</orgDefaultCurrencyIsoCode><orgDisallowHtmlAttachments>false</orgDisallowHtmlAttachments><orgHasPersonAccounts>false</orgHasPersonAccounts><organizationId>00Dm00000001wJbEAI</organizationId><organizationMultiCurrency>false</organizationMultiCurrency><organizationName>Dimagi</organizationName><profileId>00eb0000000UwOFAA0</profileId><roleId>00Eb0000000cNN9EAM</roleId><sessionSecondsValid>43200</sessionSecondsValid><userDefaultCurrencyIsoCode xsi:nil="true" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" /><userEmail>mustafa.turab@gmail.com</userEmail><userFullName>Mustafa Turab Ali</userFullName><userId>005m0000001UuiTAAS</userId><userLanguage>en_US</userLanguage><userLocale>en_US</userLocale><userName>mustafa.turab+dimagi@gmail.com</userName><userTimeZone>America/Panama</userTimeZone><userType>Standard</userType><userUiSkin>Theme3</userUiSkin></userInfo></result></loginResponse></soapenv:Body></Envelope>';
        return new HttpCalloutMockImpl(200, 'OK', body, new Map<String, String> {'Content-Type' => 'application/xml'});
    }

}