@istest
public class MYOBOAuthResponseTest {

public static testmethod void MYOBOAuthResponse_TestMethod() {

    MYOBOAuthResponse m = new MYOBOAuthResponse();
    m.access_token = 'long string of characters';
    m.token_type = 'Bearer';
    m.expires_in = '1200';
    m.refresh_token = 'different string of characters';
    m.scope = 'CompanyFile';
    }
  
}
