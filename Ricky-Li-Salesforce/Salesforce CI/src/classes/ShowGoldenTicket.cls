/*
 * Programmer : Subodh Bahl
 * Date : March 19, 2013
 * Purpose: Assigning the permission set to the user on a click of a field
 */
Global Class ShowGoldenTicket{
      /*
       *    This class assigns the Permission Sets to the Users which have Attending_G_Stock__c field set to true 
       */
      public void AssignPermissionSet(Set <Id> UserIds){
           
           //get the Id of the Users
           List <User> UserId = [Select Id, Attending_GStock__c, ManagerId from User where Id in: UserIds];
           String ManagerId = UserId[0].ManagerId; 
           //get the permission set
           List <PermissionSet> PS = [Select Id from PermissionSet where Name ='Golden_Ticket']; 
           List <PermissionSet> PSManager = [Select Id from PermissionSet where Name ='Golden_Ticket_Manager'];
           
           //Check if this user has the permission set assigned already
           List <PermissionSetAssignment> listCheckPS = [Select Id from PermissionSetAssignment where PermissionSetId=:PS[0].Id and AssigneeId=:UserId[0].Id];
           List <PermissionSetAssignment> listCheckPSManager = [Select Id from PermissionSetAssignment where PermissionSetId=:PSManager[0].Id and AssigneeId=:ManagerId];
           
           //User
           if(listCheckPS.size() == 1){
               System.Debug('Already Assigned');
           }
           else{
               List <PermissionSetAssignment> listPSA = new List <PermissionSetAssignment>();
               //create PermissionSetAssignment
               for(integer i=0; i < UserId.size(); i++){
                   PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId=userId[0].Id, PermissionSetId=PS[0].Id);
                   listPSA.add(psa);
               }
               insert listPSA;
          } 
          
          //Manager
          if(listCheckPSManager.size() == 1){
               System.Debug('Already Assigned');
           }
           else{
           		User user = null;
               //Check if the Manager is active
               if(ManagerId != null)
               	user = [Select isActive from User where Id=:ManagerId];
               if(user != null){
               	if(user.isActive==true){
                   List <PermissionSetAssignment> listPSA = new List <PermissionSetAssignment>();
                   //create PermissionSetAssignment
                   for(integer i=0; i < UserId.size(); i++){
                       PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId=ManagerId, PermissionSetId=PSManager[0].Id);
                       listPSA.add(psa);
                   }
                   insert listPSA;
              	}
              		else
                  		System.Debug('Manager is not active');
               }
         } 
         
    }
}