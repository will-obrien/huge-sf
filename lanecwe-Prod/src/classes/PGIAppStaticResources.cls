/**
 * This class contains the method to retrieve the static resources that are used accross applications and can be queried only once.
 * This is a singleton class, so for a transaction there can be only one instance created of this class.
 *
 * @author Amit M.
 * @version 1.0
 */
public with sharing class PGIAppStaticResources {
	
	/* private constructor so that no instance can be created other than getInstance method. */
	private PGIAppStaticResources(){}
	
	/* Stores singleton instance of the class. */
	private static PGIAppStaticResources singletonInstance;
	
	/**
	 * This method is the only way to create the instance of this class. If there is already a
	 * instance created for a transaction of this class then returns the same instance.
	 *
	 * @returns the singletion instance of the class.
	 */
	public static PGIAppStaticResources getInstance()
	{
		if (singletonInstance == null)
		{
			singletonInstance = new PGIAppStaticResources();
		}
		return singletonInstance;
	}
	
	/* Stores the profile information for current logged in user. */
	public static Profile currentUserProfile
	{
		get
		{
			if (currentUserProfile == null)
			{
				currentUserProfile = [Select Id, Name From Profile Where Id=:Userinfo.getProfileId()];
			}
			return currentUserProfile;
		}
		private set;
	}
	
	/* Stores the map of profiles that can view the attachment view on quotes tab. */
	public Map<Id, Profile> attachmentViewProfiles
	{
		get
		{
			if(attachmentViewProfiles == null || attachmentViewProfiles.isEmpty())
			{
				attachmentViewProfiles = this.getProfileWithAttachmentViewPermission();
			}
			return attachmentViewProfiles;
		}
		private set;
	}
	
	/* Stores the map of all active pricebooks in the system. */
	public Map<Id, Pricebook2> allPricebooks
	{
		get
		{
			if(allPricebooks == null || allPricebooks.isEmpty())
			{
				allPricebooks = this.getAllPricebooks();
			}
			return allPricebooks;
		}
		private set;
	}
	
	/* Stores the map of region wise pricebooks in the system. */
	public Map<String, Pricebook2> regionWisePricebooks
	{
		get
		{
			if(regionWisePricebooks == null || regionWisePricebooks.isEmpty())
			{
				regionWisePricebooks = this.getRegionWisePricebookMap();
			}
			return regionWisePricebooks;
		}
		private set;
	}
	
	/* Stores PGI standard product object. */
	public Product2 pgiStandardProduct
	{
		get
		{
			if (pgiStandardProduct == null)
			{
				pgiStandardProduct = [Select Id, Name From Product2 Where Name=:PGIAppConstants.STANDARD_PRODUCT_NAME];
			}
			return pgiStandardProduct;
		}
		private set;
	}
	
	/* Stores map of region to approval level detail map. */
	public Map<String, Map<String, String>> regionWiseApprovalLevelMap
	{
		get
		{
			if (regionWiseApprovalLevelMap == null)
			{
				regionWiseApprovalLevelMap = this.getRegionWiseApprovalLevelMap();
			}
			return regionWiseApprovalLevelMap;
		}
		private set;
	}
	
	/* Stores the detail of PGI Integration User. */
	public User pgiIntegrationUser
	{
		get
		{
			if (pgiIntegrationUser == null)
			{
				pgiIntegrationUser = this.getUserByName(PGIAppConstants.PGI_INTEGRATION_USER);
			}
			return pgiIntegrationUser;
		}
		set;
	}
	
	/**
	 * Retrieves the given user info by name.
	 *
	 * @returns the user object.
	 */
	private User getUserByName(String name)
	{
		User pgiIntegrationUser = null;
		List<User> pgiUsers = [Select Id From User  where Name=:name limit 1];
		if (pgiUsers != null && !pgiUsers.isEmpty())
		{
			pgiIntegrationUser = pgiUsers.get(0);
		}
		return pgiIntegrationUser;
	}
	
	/**
	 * Queries the map of profiles than can view the attachment view on quotes tab.
	 *
	 * @returns the map of profiles.
	 */
	private Map<Id, Profile> getProfileWithAttachmentViewPermission()
	{
		return new Map<Id, Profile>([Select Id, Name From Profile Where Name IN:PGIAppConstants.PROFILE_NAME_WITH_ATTACHMENT_VIEW_PERMISSION]);
	}
	
	/**
	 * Queries the map of all the available pricebooks in the system.
	 *
	 * @returns the map of pricebooks.
	 */
	private Map<Id, Pricebook2> getAllPricebooks()
	{
		return new Map<Id, Pricebook2>([Select Id, Name, IsStandard From Pricebook2 Where IsActive=:true]);
	}
	
	
	/**
	 * Gets all the picklist entry values of user's region field and creates map of region wise pricebooks.
	 *
	 * @returns the map of region wise pricebooks.
	 */
	private Map<String, Pricebook2> getRegionWisePricebookMap()
	{
		List<Schema.PicklistEntry> regionFieldPicklistValues = User.sobjectType.getDescribe()
																		.fields.getMap()
																		.get(PGIAppConstants.USER_REGION_FIELD_NAME)
																		.getDescribe()
																		.getPickListValues();
		Map<String, Pricebook2> regionPricebookMap = new Map<String, Pricebook2>();
		if (regionFieldPicklistValues != null && !regionFieldPicklistValues.isEmpty())
		{
			for (Schema.PicklistEntry entry : regionFieldPicklistValues)
			{
				if (entry != null && !entry.getValue().equals(PGIAppConstants.NONE))
				{
					for (Pricebook2 pricebook : this.allPricebooks.values())
					{
						if (pricebook != null)
						{
							if (pricebook.isStandard)
							{
								regionPricebookMap.put(PGIAppConstants.STANDARD_PRICEBOOK, pricebook);
								continue;
							}
							else if (pricebook.Name.startsWith(entry.getValue()))
							{
								regionPricebookMap.put(entry.getValue(), pricebook);
								break;
							}
						}
					}
				}
			}
		}
		return regionPricebookMap;
	}
	
	/**
	 * Gets the value of region wise approval level names from custom setting and generates region to approval level map.
	 *
	 * @returns the map of region to approval level detail map.
	 */
	private Map<String, Map<String, String>> getRegionWiseApprovalLevelMap()
	{
		RegionWiseApprovalLevels__c approvalLevels = RegionWiseApprovalLevels__c.getInstance(PGIAppConstants.REGION_WISE_APPROVAL_LEVEL_CUSTOM_SETTING_NAME);
		Map<String, Map<String, String>> approvalLevelsMap = new Map<String, Map<String, String>>();
		String naRegionValue = approvalLevels.NARegion__c;
		approvalLevelsMap.put(PGIAppConstants.USER_REGIONS[0], createLevelNoToLevelNameMap(approvalLevels.NARegion__c));
		approvalLevelsMap.put(PGIAppConstants.USER_REGIONS[1], createLevelNoToLevelNameMap(approvalLevels.EMEARegion__c));
		approvalLevelsMap.put(PGIAppConstants.USER_REGIONS[2], createLevelNoToLevelNameMap(approvalLevels.APACRegion__c));
		return approvalLevelsMap;
	}
	
	/**
	 * Breaks string of level values and generates level number to level name map.
	 *
	 * @param levelValue, semi-colon separated string value of approval level names.
	 * @returns the map of approval level number to level name.
	 */
	private Map<String, String> createLevelNoToLevelNameMap(String levelValue)
	{
		Map<String, String> approvalLevelMap;
		if (levelValue != null && !levelValue.equals(''))
		{
			String[] splitValues = levelValue.split(PGIAppConstants.SEMICOLON);
			if (splitValues != null && !splitValues.isEmpty())
			{
				approvalLevelMap = new Map<String, String>();
				for (Integer i = 0; i < splitValues.size(); i++)
				{
					approvalLevelMap.put('Level ' + (i + 1), splitValues[i]);
				}
			}
		}
		return approvalLevelMap;
	}
}