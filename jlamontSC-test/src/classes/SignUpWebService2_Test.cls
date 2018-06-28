//*********************************************************************************************************
//Name              : SignUpWebService2Test
//Created By        : Virendra (Appirio JDC)
//Created Date      : 2 May 2014
 
@isTest
private class SignUpWebService2_Test {
    
    
    
      static testmethod void  testSignUpForExistingContact(){
           rC_Giving__Account_Setting__c mc = rC_Giving__Account_Setting__c.getInstance(UserInfo.getProfileId());
            mc.rC_Giving__Disable_All__c = true;
            upsert mc;
            system.debug('::: MC ::'+mc);
            
            Account acc = new Account(Name= 'Customers12',OwnerId = UserInfo.getUserId());
            insert acc;
            contact con = new contact(lastname='lastName123',accountId=acc.id, rC_Bios__Preferred_Email__c = 'Work',rC_Bios__Work_Email__c ='alone@noattach.com',email='alone@noattach.com');
            insert con;
           
            system.debug(':::Before user created :::');
            SignUpWebService2.SignUpResult result = SignUpWebService2.createuser('AA11','BB22','alone@noattach.com','122343222','appirio12we#123','pp','ss',null,'websysId1',null,null,null,'AddressLine1NoMatch',
                                       'AddressLine2NoMatch','JaipurNoMatch', 'Rajasthan', '302033', 'India', 'Yes');
//            System.assert(result.isSuccess == true);
      }
      
    static testmethod void  testSignUpForContactAddressAndAccount(){

		// VB: 2/9/15: Why is this doing the below code?  
		//		the usr object is never used, is it?
		//		Commenting out the below 'update usr role section'      
		//
        //update current user role
        //list<UserRole> usrRole = [SELECT ID FROM UserRole];
        //User usr = new User(Id = UserInfo.getUserId());
        //system.runas(usr){
        //    if(usrRole.size()>0){
        //        usr.UserRoleId = usrRole.get(0).Id;
        //    }
        //    update usr;
        //}
        
        //Run the test As BSD User
        system.runAs(TestDataUtility.createBDSUser()){
            //create account
            system.debug('::Current user profile ::'+UserInfo.getProfileId());
            // Make All trigger disable for BSD user on Rc Giving Account setting 
            rC_Giving__Account_Setting__c mc = rC_Giving__Account_Setting__c.getInstance(UserInfo.getProfileId());
            mc.rC_Giving__Disable_All__c = true;
            upsert mc;
            system.debug('::: MC ::'+mc);
         
          
            //call webservice
            SignUpWebService2.SignUpResult result = SignUpWebService2.createuser('AA','BB','abcdTes234234@mytest.com','1222222','appirio#123','pp','ciitdc#123',null,'websysId1',null,null,null,'AddressLine1NoMatch',
                                       'AddressLine2NoMatch','JaipurNoMatch', 'Rajasthan', '302033', 'India', 'Yes');
            
            System.assert(result.isSuccess == true);
            /*SignUpWebService2.createuser('Vir','Singh','vnaruka@mail12me.com','555-555-5555','ciitdc#123',null,null,null,
                                           null,null,null, '10510', null);*/
			//SignUpWebService2.createuser('Vir','Singh','vnaruka@mail12me.com', '555-555-5555', 'mr', null, 'ciitdc#123', null, null, null, null, null, 'test', 'test2', 'CAli', 'CA', '10510', 'USA', 'YES');                                           
           test.startTest();
            List<rC_Bios__Contact_Address__c> contactAddresses = [Select id,rC_Bios__Contact__c,rC_Bios__Original_Street_Line_1__c,rC_Bios__Original_Street_Line_2__c,rC_Bios__Original_City__c  from rC_Bios__Contact_Address__c];
            system.debug('::contactAddresses:::'+contactAddresses);
            
            /*rC_Bios__Contact_Address__c conAddress = contactAddresses.get(0);
            system.assertEquals(1,contactAddresses.size());
            system.assertEquals(conAddress.rC_Bios__Original_Street_Line_1__c,'AddressLine1NoMatch');
            system.assertEquals(conAddress.rC_Bios__Original_City__c,'JaipurNoMatch');*/
            
            
            List<Id> newContacts = new List<Id>();
            for(rC_Bios__Contact_Address__c conAdr:contactAddresses){
                newContacts.add(conAdr.rC_Bios__Contact__c);
            }
            
            system.debug('::newContacts:::'+newContacts);
            List<Contact>  contacts  = [Select id ,accountId from contact where Id in:newContacts];
            
            
            /*SignUpWebService2.createuser('CC','DD','alone@noattach.com','1222222','appirio#123','pp','ss',null,'websysId1',null,null,null,'AddressLine1',
                                       'AddressLine2333','Jaipur', 'Rajasthan', '302033', 'India');*/
            test.stopTest();
            
        }   
        
    }
    
}