/*************************************************************
*Name : OverlayListViewExtension
*Created By : Appirio
*Created Date : 23rd Feb,2012
*Purpose : Retrieve and shows the Account team members associated with the parent.
****************************************************************/

public class OverlayListViewExtension {
  //variable account
  private final Account account = null;
 
  public List<AccountTeamMember> lstAccountTeamMember {get;set;}
 
  //========================================================================//
  //Constructor
  //========================================================================//
  public OverlayListViewExtension(ApexPages.StandardController controller) {
    account = (Account)controller.getRecord();
    lstAccountTeamMember = LoadAccountTeamMembersForChildAccounts();
  }
 
  //=========================================================================
  //Load Account Team Members,for the child accounts only
  //=========================================================================//
  public List<AccountTeamMember> LoadAccountTeamMembersForChildAccounts() {     
    return [SELECT id, user.phone, User.Name,  User.UserRole.Name, Account.Name,TeamMemberRole FROM AccountTeamMember
                            WHERE AccountId = :account.Id
                            Order By Account.Name,User.Name];
  }
  
  @isTest
  private static void Test_Page(){
  	Test.startTest();
  	User testUser = PGITestUtilities.getTestUser();
  	insert testUser;
  	Account testAccount = PGITestUtilities.getAccountDetails();
  	insert testAccount;
  	AccountTeamMember testAccountTeamMember = PGITestUtilities.getAccountTeamMember(testAccount.Id, testUser.Id);
  	insert testAccountTeamMember;
  	Test.stopTest();
  	PageReference pageRef = Page.AccountTeamReadonlyListView;
  	ApexPages.StandardController stdController = new ApexPages.StandardController(testAccount); 
  	OverlayListViewExtension controller = new OverlayListViewExtension(stdController);
  	system.assertNotEquals(controller.lstAccountTeamMember, null);
  }
 }