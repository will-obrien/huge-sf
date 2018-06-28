/**
 * This class contains the constant values used accross the application.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class PGIAppConstants {
	
	/* Private constructor as creation of this class instance will not be required. */
	private PGIAppConstants(){}
	
	/* Static block to add the values of Quote status from Custom setting as class loads.
	   Otherwise it gives error while executing test classes. */
	static
	{
		if (Test.isRunningTest())
		{
			PGITestUtilities.createQCStatusValuesCustomSetting();
		}
	}
	
	/* Stores constant for ascending sort direction used in SOQL. */
	public static final String SORT_DIRECTION_ASC = 'ASC';
	
	/* Stores constant for descending sort direction used in SOQL. */
	public static final String SORT_DIRECTION_DESC = 'DESC';
	
	/* Stores constant for descending sort direction used in SOQL. */
	public static final String RECORDS_LIMIT_FOR_SET_CONTROLLER = 'LIMIT 10000';
	
	/* Stores constant for space. */
	public static final String SPACE = ' ';
	
	/* Stores constant for comma. */
	public static final String COMMA = ',';
	
	/* Stores constant for order by clause used in SOQL. */
	public static final String ORDER_BY_CLAUSE = ' ORDER BY ';
	
	/* Stores view options available on the quotes tab. */
	public static final String[] QUOTES_VIEW_OPTIONS = new String[]{'My Q/C Mgmt\'s', 
																	'Q/C Mgmt\'s With Attachment(s)', 
																	'Q/C Mgmt\'s Without Attachment(s)'};
	
	/* Stores boolean value to check if quote's attachment can be deleted or not. This will be used when 
	 * 'Cancel Contract' document is clicked on the quote detail page or when a contract document is voided by docusing process.
	 */
	public static Boolean CHECK_QUOTE_STATUS = true;
	
	/* Stores the Quote's status used in the application. DO NOT CHANGE THE ORDER. */
	public static final String[] QUOTE_STATUSES = new String[]{QCStatusValues__c.getInstance(PGIQuoteStatusEnum.Draft.name()).StatusValue__c, 
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.QuoteInProgress.name()).StatusValue__c, 
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedPriceApproval.name()).StatusValue__c, 
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.PricingApproved.name()).StatusValue__c,
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ReadyforContract.name()).StatusValue__c,
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractDocumentGenerated.name()).StatusValue__c,
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedContractInternalApproval.name()).StatusValue__c,
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.SubmittedContractCustomerApproval.name()).StatusValue__c,
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ContractSignedbyCustomer.name()).StatusValue__c,
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.ReadyforClosedWon.name()).StatusValue__c,
																QCStatusValues__c.getInstance(PGIQuoteStatusEnum.Closed.name()).StatusValue__c};
	
	/* Stores constant for empty string. */									
	public static final String EMPTY_STRING = '';
	
	/* Stores value of user's region field. */									
	public static final String USER_REGION_FIELD_NAME = 'Region__c';
	
	/* Stores value for string none. */									
	public static final String NONE = 'None';
	
	/* Stores name of standard pricebook. */									
	public static final String STANDARD_PRICEBOOK = 'Standard';
	
	/* Stores name of PGI standard product. */
	public static final String STANDARD_PRODUCT_NAME = 'PGI Standard Product';
	
	/* Stores new line character constant. */
	public static final String NEW_LINE_CHARACTER = '\n';
	
	/* Stores the name of the custom setting to send price book entry. */
	public static final String PB_ENTRY_CUSTOM_SETTING_NAME = 'SendPbEntryEmail';
	
	/* Stores forward slash character constant. */
	public static final String FORWARD_SLASH = '/';
	
	/* Stores boolean value to check if 'Attachment_QuoteCount' trigger is called from 'PGICancelContract' trigger.
	 * If this value is true, then we do not need to run the update statement in 'Attachment_QuoteCount' trigger.
	 */
	public static Boolean FROM_CANCEL_CONTRACT_TRIGGER = false;
	
	/* Stores .doc document type to be generated for quote/contract. */
	public static final String DOCUMENT_TYPE_DOC = '.doc';
	
	/* Stores region wise price book custom setting name. */
	public static final String REGION_WISE_APPROVAL_LEVEL_CUSTOM_SETTING_NAME = 'RegionWiseAppLevelNames';
	
	/* Stores constant for semi-colon. */
	public static final String SEMICOLON = ';';
	
	/* Store possible values for user regions. */
	public static final String[] USER_REGIONS = new String[]{'NA', 'EMEA', 'APAC'};
	
	/* Stores the name of contract document custom settings. */
	public static final String CONTRACT_DOC_CUSTOM_SETTINGS = 'Contract Document Values';
	
	/* Stores the name of pgi contract manager. */
	public static final String PGI_CONTRACT_MANAGER_PROFILE_NAME = 'PGi Contract Manager';
	
	/* Stores the name of pgi system admin. */
	public static final String PGI_SYSTEM_ADMIN_PROFILE_NAME = 'System Administrator';
	
	/* Stores the name of pgi system admin no expires. */
	public static final String PGI_SYSTEM_ADMIN_NO_EXPIRES_PROFILE_NAME = 'System Administrator (No Expires)';
	
	/* Stores set of profiles names, which can view the attachment view on the Q/C Mgmt tab. */
	public static final Set<String> PROFILE_NAME_WITH_ATTACHMENT_VIEW_PERMISSION = new Set<String>{
																'PGi Admin Lite', 
																PGI_CONTRACT_MANAGER_PROFILE_NAME, 
																PGI_SYSTEM_ADMIN_PROFILE_NAME, 
																PGI_SYSTEM_ADMIN_NO_EXPIRES_PROFILE_NAME};
	
	/* Stores the name of User Channel Canada. */
	public static final String USER_CHANNEL_CANADA = 'Canada';
	
	/* Stores profile names that cannot set the contract type and status for Q/C. */
	public static final Set<String> PROFILES_CANNOT_UPDATE_CONTRACT_TYPES = new Set<String>{PGI_CONTRACT_MANAGER_PROFILE_NAME, PGI_SYSTEM_ADMIN_PROFILE_NAME, PGI_SYSTEM_ADMIN_NO_EXPIRES_PROFILE_NAME};
	
	/* Stores the pgi integration user name. */
	public static final String PGI_INTEGRATION_USER = 'PGI Integration';
	
	/* Stores no record message string. */
	public static final String NO_RECORDS_MESSAGE = 'There are no records to display.';
	
	/* Stores the name of min commit package product name. */
	public static final String MIN_COMMIT_AUDIO_MIN_PRODNAME = 'Audio Minimum Commitment';
	
	/* Stores the name of min commit package product name. */
	public static final String MIN_COMMIT_DOM_DIAL_PRODNAME = 'Group 1 Domestic Dial out and Local Access';
	
	public static final Set<String> MIN_COMMIT_ADD_ON_NAMES = new Set<String>{'GlobalMeet Audio 1YR Minimum Commit', 'GlobalMeet Audio 2YR Minimum Commit'};
	
	/* Stores Id */
	public static final Id PGI_INTEGRATION_USERID = '0053000000627fiAAA';
	public static final Id HUBSPOT_INTEGRATION_USERID = '005300000071JU5AAM';
	public static final Id SF_NA_SUPPORT_ORGWIDE_EMAILADDRESSID = '0D2300000004DdOCAU';
	public static final Set<Id> ADMIN_PROFILES = new Set<Id>{'00e30000001kms9AAA','00e30000001rXZsAAM','00e30000001rSOHAA2','00ea0000001sgqLAAQ'};
	public static final Set<Id> GCS_DIAMOND_PROFILES = new Set<Id>{'00e30000001sVaUAAU','00ea0000001sZgUAAU'};
}