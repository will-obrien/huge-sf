@isTest(seeAllData=false)
public class BKSL_Mandrill_Email_UT {

	public static testMethod void sendEmailTest(){
        BKSL_Mandrill_Email cls = new BKSL_Mandrill_Email();
		
		BKSL_Mandrill_Email.properties prop = new BKSL_Mandrill_Email.properties();
		prop.toAddress = 'test@test.com';
		prop.toName = 'test';
		prop.replyTo = 'rsharpe@markettraders.com';
		prop.appointmentTime = '10 AM EST';
		prop.appointmentId = 'recidofappointment';
		prop.serviceid = 'recidofservice';
		
		cls.prop = prop;
		cls.sendEmail();
    }
}