/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class CustomForgotPasswordController {
    public String username {get; set;}   

    public CustomForgotPasswordController() {}

    public PageReference forgotPassword() {

        if (String.isBlank(username)) {

          return null;

        }

        boolean success = false;

        //String constructedUsername = username + '@0dbo0000000tn4o.force.com';

        List<User> users = [SELECT Id, FirstName, Username, Email FROM User WHERE Username = :username limit 1];

        if (users.size() == 1) {
            String resetUrl = Site.getBaseUrl() + '/CustomSetPassword?token=' + issueJWT(username, 600);


            Map<String, String> mapBodyParams = new Map<String, String> {
                   '{!resetUrl}' => resetUrl,
                   '{!User.FirstName}' => users.get(0).FirstName,
                   '{!Community_Name}' => 'AddUP',
                   '{!Organization.Name}' => 'AddUP'
            };

            System.debug('\n[CustomForgotPasswordController:forgotPassword] : sending email...');
            SendUserEmail.sendEmail(users.get(0), username, mapBodyParams);
            success = true;
            System.debug('\n[CustomForgotPasswordController:forgotPassword] : sending email: Success');
        }

        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);

        if (success) {
            return pr;
        }
        return null;
    }




    public static String issueJWT(String subject, Integer validFor) {

        JSONGenerator claim = JSON.createGenerator(false);
        claim.writeStartObject();
        claim.writeStringField('sub', subject);
        Long rightNow = (dateTime.now().getTime()/1000)+1;
        claim.writeNumberField('exp', (rightNow + validFor));
        claim.writeEndObject();

        String jwt = base64URLencode(Blob.valueOf(claim.getAsString()));
        Blob key = EncodingUtil.base64Decode('dGhpc2lzbXlzZWNyZXQ');
        Blob signature = Crypto.generateMac('hmacSHA1',Blob.valueof(jwt),key);
        jwt += '.' + base64URLencode(signature);  
        return jwt;

    }


    public static String base64URLencode(Blob input){ 
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
    }

}