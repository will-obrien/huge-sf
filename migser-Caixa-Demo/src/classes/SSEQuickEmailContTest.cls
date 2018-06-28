@isTest
public class SSEQuickEmailContTest {

	static testMethod void testEmail() {

		SSEQuickEmailCont qe;
		Date currDate = Date.today();
		List<SelectOption> opList = new List<SelectOption>();
		//opList = qe.getTemplateOptions();

/* Test for Account */
		Account acc = new Account(Name='Demo');
		insert acc;
		// Create Contact for Acc
		Contact c = new Contact(FirstName = 'Joe',LastName = 'Bloggs',AccountId = acc.Id, Email='dummy@email.com');
		insert c;
		System.currentPageReference().getParameters().put('Id', acc.Id);
		qe = new SSEQuickEmailCont();
		qe.to = 'joe@bloggs.com';
		qe.emailBody = 'The body';
		qe.subject = 'Subject';
		qe.cc = 'cc@cc.com';
		qe.bcc = 'bcc@bcc.com';
		qe.sendEmail();
/* End Account Test */	
/* Test for Person Account */
		//String RecTypeId= [select Id from RecordType where (Name='Person Account') and (SobjectType='Account')].Id;

		/*
		Account pAcc = new Account(
		RecordTypeID='012G0000001G6rB',
	 	FirstName='First Name',
		LastName='Last Name',
	  	PersonMailingStreet='Street',
		PersonMailingPostalCode='Zip',
		PersonMailingCity='City',
		PersonEmail='test@test.com',
		PersonHomePhone='325234',
		PersonMobilePhone='234234'
		);

		insert pAcc;
		System.currentPageReference().getParameters().put('Id', pAcc.Id);
		qe = new SSEQuickEmailCont();
		*/
/* End for Person Account */


/* Test if Lead */	
		Lead l = new Lead(FirstName='Joe',LastName='Bloggs',email='test@test.com',Status='Open');
		insert l;
		System.currentPageReference().getParameters().put('Id', l.Id);
		qe = new SSEQuickEmailCont();
/* End Lead Test */
/* Start Opportunity Test */

		Opportunity opp = new Opportunity(Name='Opp Name',AccountId=acc.Id,StageName='Prospecting',ForecastCategoryName='Pipeline',CloseDate=currDate);
		insert opp;
		System.currentPageReference().getParameters().put('Id', opp.Id);
		qe = new SSEQuickEmailCont();
/* End test if Opp */
/* Test if Contact */
		System.currentPageReference().getParameters().put('Id', c.Id);
		qe = new SSEQuickEmailCont();
/* End test if contact */ 
/* Start Case Test */
		Case theCase = new Case(Subject='Demo Subject',Status='New',ContactId = c.Id);
		insert theCase;
		System.currentPageReference().getParameters().put('Id', theCase.Id);
		qe = new SSEQuickEmailCont();
/* End Case test */
/* Misc */
		qe = new SSEQuickEmailCont();
		String emailContent = qe.emailContent;
		qe.selectedTemplateId = '-- None --';
		emailContent = qe.emailContent;

/* END Misc */



	}	
}