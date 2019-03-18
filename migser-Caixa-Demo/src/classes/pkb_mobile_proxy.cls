global with sharing  class pkb_mobile_proxy {
	
	public static String DEFAULT_LANGUAGE = 'en_US'; 
	public static String COOKIE_SESSION_NAME = 'MOBILE_PKB2SessionId';
	public static String COOKIE_CONTACT_NAME = 'MOBILE_PKB2ContactDetails';
	
	public static set<String> validOperations = new set<String>{'getPopular','getFeatured','getRecommended','searchString','getLanguages','getSetup','getArticleDetail','processContact','submitFeedBack'};

	/*******************************************************************
		controller attributes to use standard component : knowledge:articleList
		
		pageSize="{!pkbCon.articlesPerPage}"
		categories="{!pkbCon.selectedCategory}"
		hasMoreVar="more"
		keyword="{!pkbCon.urlSearchQuery}"
		language="{!pkbCon.selectedLanguage}"
		pageNumber="{!currPage}">
	
	********************************************************************/

	public Integer articlesPerPage	{ get; set; }
	public String selectedCategory	{ get; set; }
	public String urlSearchQuery	{ get; set; }
	public String selectedLanguage	{ get; set; }
	public list<PKBDataCategory> categories	{ get; set; }
	public list<String> languages 	{ get; set; }
	public Integer currPage			{ get; set; }
	public Map<String,String> langMap 		{ get; set; }
	
	public String sessionId { get; set; }
	
	public pkb_mobile_proxy(){

		pkb_Controller p = pkb_mobile_controller.setUp();
		PKB__c  cSetting = null;
		
		try{
			articlesPerPage = p.articlesPerPage;
			urlSearchQuery = p.urlSearchQuery;
			selectedLanguage = p.selectedLanguage;
			currPage = p.currPage;
			//PKBDataCategory
			categories = new list<PKBDataCategory>();
			cSetting = pkb_mobile_controller.getCurrentSiteSetting (p);
			categories =   pkb_mobile_controller.getCategoryGroupData(cSetting);
			//languages
			languages = new list<String>();
			languages = pkb_mobile_controller.getLanguagesList();
			langMap   = pkb_mobile_controller.getLangMap();
			 
			//sessionId
			Cookie sessionCookie = ApexPages.currentPage().getCookies().get(COOKIE_SESSION_NAME);
			if (sessionCookie == null) {
				sessionId = p.randomUUID();
				sessionCookie = new Cookie(COOKIE_SESSION_NAME, sessionId, '/', -1, false);
				ApexPages.currentPage().setCookies(new Cookie[]{sessionCookie});
			} else {
				sessionId = sessionCookie.getValue();
			}
		} catch (Exception e) {
			notifyAdmin(e, System.Label.PKB2_No_Settings_Yet, p.siteAdmin.Email);
		}
		if (cSetting.Id == null){
			notifyAdmin(null, System.Label.PKB2_No_Settings_Yet, p.siteAdmin.Email);
		}
	}

	
	@RemoteAction
	global static String postBlobContent(String pId, String aId, String fileName, String contentType, String base64BlobValue){
	/*
	parentId: The sfdc object Id this file will be attached to
	attachmentId: The record of the current Attachment file being processed
	fileName: Name of the attachment
	contentTye: Content Type of the file being attached
	base64BlobValue: Base64 encoded string of the file piece currently processing
	*/
		try{ 
			Id parentId = pId;
			Id attachmentId;
			//If recordId is blank this is the first part of a multi piece upload
			if((!String.isNotBlank(aId)) ){
				Attachment att = new Attachment(
					ParentId = parentId,
					Body = EncodingUtil.Base64Decode(base64BlobValue),
					Name = fileName,
					ContentType = contentType
				);
				
				//check create permissions 
				pkb_SecurityHandler.canCreate( 
					new Schema.SObjectType[] {Attachment.sObjectType});
				
				insert att;
				//Return the new attachment Id
				return att.Id;

			}else{
				//check Update permissions 
				pkb_SecurityHandler.canUpdate( 
					new Schema.SObjectType[] {Attachment.sObjectType});
				attachmentId = aId;
				for(Attachment atm : [select Id, Body from Attachment where Id = :attachmentId]){
					//Take the body of the current attachment, convert to base64 string, append base64 value sent from page, then convert back to binary for the body
					update new Attachment(Id = attachmentId, Body = EncodingUtil.Base64Decode(EncodingUtil.Base64Encode(atm.Body) + base64BlobValue));
				}
				
				//Return the Id of the attachment we are currently processing
				return attachmentId;
			}
		}catch(pkb_SecurityHandler.SecurityException sEx){
			 return null;
		}
	}	

	/*******************************************************************
		Javascript remoting methods
	********************************************************************/
	@RemoteAction
	global static Object getPhoneCallAvailable(){
		return pkb_mobile_controller.getPhoneCallAvailable(system.now());
	}
	
	@RemoteAction
	global static  String getRemoteAction(String requestJson){

		ApexPages.StandardController theSC2;
		ResponseItem thisResponseItem = new ResponseItem();
		RequestItem thisRequestItem;
		String opType = null;

		try {
			JSONParser parser = JSON.createParser(requestJson);
			Type requestItemType = Type.forName('pkb_mobile_proxy.RequestItem');
			thisRequestItem = (RequestItem)parser.readValueAs(requestItemType);
			opType = thisRequestItem.operationType; 
			
		} catch (Exception ex) {
			//Indicate that an error has occurred
			thisResponseItem.isSuccess = false;
			thisResponseItem.message	= ex.getMessage();
		}

		//validate request Operations

		if (opType == null || ! validOperations.contains(opType) ){
			thisResponseItem.isSuccess  = false;
			thisResponseItem.message    = 'Wrong operation '+opType;

		}else{

			thisRequestItem.lang = (String.isNotBlank(thisRequestItem.lang)) ? thisRequestItem.lang : DEFAULT_LANGUAGE ;
		
			if (opType == 'getPopular'){
				thisResponseItem = pkb_mobile_controller.getPopularArticles(thisRequestItem);
			}
		
			if (opType == 'getFeatured'){
				thisResponseItem = pkb_mobile_controller.getFeaturedArticles(thisRequestItem);
			}

			if (opType == 'getRecommended'){
				thisResponseItem = pkb_mobile_controller.getRecommendedArticles(thisRequestItem);
			}

			if (opType == 'searchString'){
				thisResponseItem = pkb_mobile_controller.searchString(thisRequestItem);
			}

			if (opType == 'getLanguages'){
				thisResponseItem = pkb_mobile_controller.getLanguages();
			}

			if (opType == 'getSetup'){
				thisResponseItem = pkb_mobile_controller.getCurrentSiteSetUp();
			} 

			if (opType == 'processContact'){
				thisResponseItem = pkb_mobile_controller.processContactUs(thisRequestItem);
			} 

			if (opType == 'getArticleDetail'){
				thisResponseItem = pkb_mobile_controller.getArticleDetail(thisRequestItem);
			}

			if (opType == 'submitFeedBack'){
				thisResponseItem = pkb_mobile_controller.submitFeedBack(thisRequestItem);
			}
		}
		system.debug('\n\n [DEBUG RESPONSE ]:' + thisResponseItem);
		return JSON.serialize(thisResponseItem);  
	}



	/*******************************************************************
		Inner class encapsulate request parameters
	********************************************************************/
	public with sharing class RequestItem{
		
		public String   lang = 'en_US';
		public String   sessionId;
		public String   dataCategories = '';
		public String   searchCriteria;
		public String   operationType;
		public map <String,String> contactData;
		public FeedBackDetails articleFeedback;
	}

	public with sharing  class FeedBackDetails{
		
		public Boolean	isDeferred = true;
		public String	sessionId = '';
		public String	feedbackComments;
		public String	searchString;
		public String	source;
		public String	kavId;
		public String	articleNumber;
		public String	title;
	}

	/*******************************************************************
		Inner class encapsulate response
	********************************************************************/
	
	public with sharing  class ResponseItem {
		public Boolean isSuccess = true;
		public String message;
		public String responseBody;
		public String caseId;
		public String caseNumber;
		public map <String,String> contactDetails;
		public list <mobileKnowledgeArticleData> articles;
		public map <String,String> filterDC;
		public list <String> lang;
		public map <String,String> setup;
		public ArticleDetail articleData;
	}
	/*******************************************************************
		Inner class encapsulate category and root node
	********************************************************************/
	public with sharing  class PKBDataCategory{
		public String	catName {get;set;}
		public String	rootName{get;set;}
		public String	catLabel{get;set;}
		
		public PKBDataCategory (String c, String r){
			catName = c;
			rootName = r;
			catLabel = '-';
		}
		public PKBDataCategory (String c, String r, String l){
			catName = c;
			rootName = r;
			catLabel = l;
		}
	}	


	public with sharing  class mobileKnowledgeArticleData { 
		public Id id						{ get; set; } // note this is the ID of the KnowledgeArticle record, not the ID of the KAV record
		public String title					{ get; set; }
		public String summary				{ get; set; }
		public String urlName				{ get; set; }
		public String articleTypeName		{ get; set; }
		public String articleTypeLabel		{ get; set; }
		public DateTime lastModifiedDate	{ get; set; }
		public DateTime firstPublishedDate	{ get; set; }
		public DateTime lastPublishedDate	{ get; set; }
		public String articleNumber			{ get; set; }
		public String elapsed				{ get; set; }
		public KnowledgeArticleVersion theAV { get; set; }
		public Integer viewStat 			{ get; set; }
		public Integer usefulStat 			{ get; set; }


		// ctor for empty KAD
		public mobileKnowledgeArticleData() { }

		// ctor that takes an already constructed-KAV record
		public mobileKnowledgeArticleData(pkb_Controller.KnowledgeArticleData kav) {
			this.id 				= kav.id;
			this.title 				= kav.title;
			this.lastPublishedDate	= kav.lastPublishedDate;
			this.articleNumber 		= kav.articleNumber;
			this.articleTypeName 	= kav.articleTypeName;
			this.articleTypeLabel 	= kav.articleTypeLabel;
			this.theAv				= kav.theAv;
		}
	}
	/*******************************************************************
		Inner class encapsulate Article Detail Data
	********************************************************************/
	
	public with sharing  class ArticleDetail {
		public Id id						{ get; set; } // note this is the ID of the KnowledgeArticle record, not the ID of the KAV record
		public String title					{ get; set; }
		public String summary				{ get; set; }
		public String urlName				{ get; set; }
		public String articleTypeName		{ get; set; }
		public String articleTypeLabel		{ get; set; }
		public DateTime lastModifiedDate	{ get; set; }
		public DateTime firstPublishedDate	{ get; set; }
		public DateTime lastPublishedDate	{ get; set; }
		public String articleNumber			{ get; set; }
		public String elapsed				{ get; set; }
		public Boolean feedbackGiven		{ get; set; }
		public Object fieldValues	 		{ get; set; }
		public Integer viewStat 			{ get; set; }
		public Integer usefulStat 			{ get; set; }
	}
	
	/*******************************************************************
		send email method
	********************************************************************/
	
	public static void notifyAdmin(Exception e, String introMessage, String adminEmail) {
		String body;
		Messaging.SingleEmailMessage msg;
		String debug;

		if (e != null) {
			debug = pkb_controller.debugException(e);
		}

		// send email only if siteAdmin isn't null
		if (adminEmail != null) {
			msg = new Messaging.SingleEmailMessage();
			msg.setSubject('Public Knowledge Base 2 Mobile - Package Exception Notification');
			msg.setToAddresses(new List<String>{adminEmail});
			body = introMessage;
			body += '\n\nAPEX TRANSACTION DEBUG INFORMATION:\n' +debug;
			body += '\n\n';
			msg.setPlainTextBody(body);
			
			List<Messaging.SendEmailResult> results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{msg});
			Boolean success= true;
			for (Integer i=0; i<results.size() && success ; i++){
				success = success && results.get(0).isSuccess();
			}
		}
	}
	
}