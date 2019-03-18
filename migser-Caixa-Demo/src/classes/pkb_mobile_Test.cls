public class pkb_mobile_Test {

	static String lang  = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().get(0).getValue();
	static String siteName = 'PKB2_MOBILE_' + String.valueOf(Crypto.getRandomInteger());
	static String publishStatus = 'draft';
	static String objType;
	static SObject kavObj;

	static PKB_Featured__c featured;
	static PKB_Featured__c keyword;
	static List<PKB_Article_Feedback_Deflection__c> pafds;
	class TestException extends Exception { }
	/*******************************************************************
		Test methods
	********************************************************************/

	static testMethod void test_getCurrentSiteSetting() {

		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();

		PKB__c pS =  pkb_mobile_controller.getCurrentSiteSetting (pc);

		system.assertEquals(pkS.Id, pS.Id);

		// non existing site
		pkb_Controller.DEFAULT_SITE_NAME = 'NONE';
		pS = pkb_mobile_controller.getCurrentSiteSetting (pc);

		system.assertEquals(null, pS.Id);
	}

	static testMethod void test_getGroupToRoot() {

		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;

		pkb_Controller pc = pkb_mobile_controller.setUp();
		PKB__c current =  pkb_mobile_controller.getCurrentSiteSetting (pc);
		map<String,String> m =  pkb_mobile_controller.getGroupToRoot (current);
		for(String k : m.keySet()	){
			system.debug('\n\n====='+k +':'+m.get(k));
		}
	}

	static testMethod void test_controller() {

		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;

		pkb_Controller pc = pkb_mobile_controller.setUp();


	}

	//public static pkb_mobile_proxy.ResponseItem getLanguages()
	@isTest
	static  void test_getLanguages() {

		pkb_mobile_proxy.ResponseItem resp = null;

		//with no Setup
		resp = pkb_mobile_controller.getLanguages();
		system.assert(resp.isSuccess);
		system.assert(resp.lang.size() > 0);

		//with setup
		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();
		resp = pkb_mobile_controller.getLanguages();
		system.assert(resp.isSuccess);
	}

	//public static List<String> getLanguagesList(){
	@isTest
	static  void test_getLanguagesList() {

		List<String> resp = null;

		//with no Setup
		resp = pkb_mobile_controller.getLanguagesList();
		system.assert(resp.size() > 0);

		//with setup
		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();
		resp = pkb_mobile_controller.getLanguagesList();
		system.assert(resp.size() == 1);
		system.assertEquals(resp[0],pkS.Selected_Languages__c);


	}

	//public static pkb_mobile_proxy.ResponseItem getCurrentSiteSetUp(){
	@isTest
	static  void test_getCurrentSiteSetUp() {

		pkb_mobile_proxy.ResponseItem resp = null;

		//with no Setup
		resp = pkb_mobile_controller.getCurrentSiteSetUp();
		system.assert(resp.isSuccess);

		//with setup
		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();
		resp = pkb_mobile_controller.getCurrentSiteSetUp();
		system.assert(resp.isSuccess);
		system.assertEquals(String.valueOf(pkS.Contact_Us_Available__c) ,resp.setup.get('Contact_Us_Available'));
		String lCTypes = resp.setup.get('caseType');
		Integer typesSize = lCTypes.split(';').size() - 1;
		system.assertEquals(pc.caseTypeOptions.size() ,typesSize);

		//update contactUs available flag and recheck
		pkS.Contact_Us_Available__c = !pkS.Contact_Us_Available__c;
		update pkS;
		pc = pkb_mobile_controller.setUp();
		resp = pkb_mobile_controller.getCurrentSiteSetUp();
		system.assert(resp.isSuccess);
		system.assertEquals(String.valueOf(pkS.Contact_Us_Available__c) ,resp.setup.get('Contact_Us_Available'));

		//live Agent setup
		// - initially liveAgent will be disabled
		system.assertEquals(pkS.LiveAgent_ChatEnabled__c ,false);

		//- we change the flag valuem but leave the config values emtpy
		pkS.LiveAgent_ChatEnabled__c = !pkS.LiveAgent_ChatEnabled__c;
		update pkS;
		pc = pkb_mobile_controller.setUp();
		resp = pkb_mobile_controller.getCurrentSiteSetUp();
		system.assert(resp.isSuccess);
		system.assertEquals('false',resp.setup.get('LA_Enabled'));

		// update the config values with something different than null

		pkS.LiveAgent_DeploymentId__c = 'SOMEVALUE';
		pkS.LiveAgent_ChatServerURL__c = 'SOMEVALUE';

		pkS.LiveAgent_ChatButtonId__c = 'SOMEVALUE';
		pkS.LiveAgent_DeploymentURL__c = 'SOMEVALUE';

		update pkS;
		pc = pkb_mobile_controller.setUp();
		resp = pkb_mobile_controller.getCurrentSiteSetUp();
		system.assert(resp.isSuccess);
		system.assertEquals('true',resp.setup.get('LA_Enabled'));

	}


	//public static pkb_mobile_proxy.ResponseItem getPopularArticles(pkb_mobile_proxy.RequestItem req){
	@isTest(SeeAllData=true)
	static  void test_getPopularArticles() {

		populatePKB2Environment();

		pkb_mobile_proxy.ResponseItem resp = null;
		//build request object
		pkb_mobile_proxy.RequestItem req = new pkb_mobile_proxy.RequestItem();
		req.sessionId = 'TESTSESSION';
		req.lang = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().get(0).getValue();
		req.operationType = 'getPopular';
		req.searchCriteria = '';

		//with no Setup
		resp = pkb_mobile_controller.getPopularArticles(req);
		system.assert(resp.isSuccess);

		//with setup
		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();

		resp = pkb_mobile_controller.getPopularArticles(req);
		system.assert(resp.isSuccess);

		//with null request
		resp = pkb_mobile_controller.getPopularArticles(null);
		system.assert(!resp.isSuccess);

	}


	//Recommended are keyword articles
	//public static pkb_mobile_proxy.ResponseItem getRecommendedArticles(pkb_mobile_proxy.RequestItem req){
	@isTest(SeeAllData=true)
	static  void test_getRecommendedArticles() {

		populatePKB2Environment();
		pkb_mobile_proxy.ResponseItem resp = null;

		//build request object
		pkb_mobile_proxy.RequestItem req = new pkb_mobile_proxy.RequestItem();
		req.sessionId = 'TESTSESSION';
		req.lang = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().get(0).getValue();
		req.operationType = 'getRecommended';
		req.searchCriteria = 'NOTFOUND';
		req.sessionId = 'TESTSESSION';

		//with no Setup
		resp = pkb_mobile_controller.getRecommendedArticles(req);
		system.assert(resp.isSuccess);

		//with setup
		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();

		resp = pkb_mobile_controller.getRecommendedArticles(req);

		system.assert(resp.isSuccess);
		system.assertEquals(0, resp.articles.size());


		//MAGIC
		Id [] fixedSearchResults= new Id[]{keyword.Id};
		Test.setFixedSearchResults(fixedSearchResults);
		req.searchCriteria = 'MAGIC';
		resp = pkb_mobile_controller.getRecommendedArticles(req);

		system.assert(resp.isSuccess);
		system.assertEquals(1, resp.articles.size());

		//with null request
		resp = pkb_mobile_controller.getRecommendedArticles(null);
		system.assert(!resp.isSuccess);

	}

	//public static pkb_mobile_proxy.ResponseItem getFeaturedArticles(pkb_mobile_proxy.RequestItem req){
	@isTest(SeeAllData=true)
	static void test_getFeaturedArticles() {

		pkb_mobile_proxy.ResponseItem resp = null;

		//build request object
		pkb_mobile_proxy.RequestItem req = new pkb_mobile_proxy.RequestItem();
		req.sessionId = 'TESTSESSION';
		req.lang = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().get(0).getValue();
		req.operationType = 'getFeatured';
		req.searchCriteria = '';
		req.sessionId = 'TESTSESSION';

		//with no Setup
		resp = pkb_mobile_controller.getFeaturedArticles(req);
		system.assert(resp.isSuccess);

		//with setup
		populatePKB2Environment();
		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();

		resp = pkb_mobile_controller.getFeaturedArticles(req);

		system.assert(resp.isSuccess);
		system.assertEquals(1, resp.articles.size());

		//with null request
		resp = pkb_mobile_controller.getFeaturedArticles(null);
		system.assert(!resp.isSuccess);

	}


	//public static pkb_mobile_proxy.ResponseItem getArticleDetail(pkb_mobile_proxy.RequestItem req){
	@isTest(SeeAllData=true)
	static void test_getArticleDetail() {

		pkb_mobile_proxy.ResponseItem resp = null;

		//with setup
		populatePKB2Environment();
		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();

		//build request object
		pkb_mobile_proxy.RequestItem req = new pkb_mobile_proxy.RequestItem();
		req.lang = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().get(0).getValue();
		req.operationType = 'getArticleDetail';
		req.sessionId = 'TESTSESSION';
		req.searchCriteria = String.valueOf(kavObj.get('KnowledgeArticleId'));
		resp = pkb_mobile_controller.getArticleDetail(req);

 		system.assert(resp.isSuccess);

 		Map<String,String> fieldValues = (Map<String,String>)resp.articleData.fieldValues;
 		String kavTitle = String.valueOf(kavObj.get('title'));
 		String resultTitle = resp.articleData.title;
		system.assert( resultTitle.contains(kavtitle));

		//with null request
		resp = pkb_mobile_controller.getArticleDetail(null);
		system.assert(!resp.isSuccess);

	}


	//public static pkb_mobile_proxy.ResponseItem searchString(pkb_mobile_proxy.RequestItem req){
	@isTest(SeeAllData=true)
	static  void test_searchString() {

		populatePKB2Environment();
		PKB__c pkS = populateSetup();


		Id [] fixedSearchResults= new Id[]{(Id)kavObj.get('Id')};
		Test.setFixedSearchResults(fixedSearchResults);

		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();

		pkb_mobile_proxy.RequestItem req = new pkb_mobile_proxy.RequestItem();
		req.lang = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().get(0).getValue();
		req.operationType = 'searchString';
		req.sessionId = 'TESTSESSION';
		req.searchCriteria = (String)kavObj.get('Title');

		pkb_mobile_proxy.ResponseItem resp = pkb_mobile_controller.searchString(req);

		system.assert(resp.isSuccess);
		system.assertEquals(1, resp.articles.size());

		//test exception
		resp = pkb_mobile_controller.searchString(null);
		system.assert(!resp.isSuccess);

	}


	//public static pkb_mobile_proxy.ResponseItem processContactUs(pkb_mobile_proxy.RequestItem req){
	static  testMethod void test_processContactUs() {

		pkb_mobile_proxy.RequestItem testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.contactData = new map<String,String>();
		testRequestItem.lang = 'NEVAH';
		testRequestItem.operationType = 'SO WRONG';
		testRequestItem.sessionId = 'TESTSESSION';

		Integer initialSize = [select Id from Case where CreatedById =: UserInfo.getUserId()].size();
		String emo = Case.Customer_emoticon_value__c.getDescribe().getPickListValues().get(0).getValue();

		Test.startTest();

		testRequestItem.contactData.put('firstName','TEST');//
		testRequestItem.contactData.put('lastName','ULTIMO NOME');//;
		testRequestItem.contactData.put('email','an@m.com');//'an@m.com';
		testRequestItem.contactData.put('reqType','Other');//'Other';
		testRequestItem.contactData.put('questionBody','WHAT WHOULD PKB2 DO');//;
		testRequestItem.contactData.put('latitude','0.2');//;
		testRequestItem.contactData.put('longitude','0.2');//;
		testRequestItem.contactData.put('emoIcon',emo);//;

		pkb_mobile_proxy.ResponseItem resp =  pkb_mobile_controller.processContactUs(testRequestItem);
		Test.stopTest();

		Integer finalSize = [select Id from Case where CreatedById =: UserInfo.getUserId()].size();

		system.assert(resp.isSuccess);
		system.assertEquals( (initialSize+1) , finalSize );

		Case c = [select Id, pkbgeolocalization__Latitude__s,pkbgeolocalization__Longitude__s,Customer_emoticon_value__c, Customer_emoticon__c  from Case where id =: resp.caseId];
		system.assertEquals(c.pkbgeolocalization__Latitude__s,0.2 );
		system.assertEquals(c.pkbgeolocalization__Longitude__s, 0.2);
		system.assertEquals(emo, c.Customer_emoticon_value__c);
		system.assert(c.Customer_emoticon__c.contains(emo) );


	}



	//public static pkb_mobile_proxy.ResponseItem processContactUs(pkb_mobile_proxy.RequestItem req){
	static  testMethod void test_processContactUsAndDeflection() {

		//create deflection

		pkb_mobile_proxy.RequestItem testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.articleFeedback = new pkb_mobile_proxy.FeedBackDetails();
		testRequestItem.operationType = 'submitFeedBack';
		testRequestItem.sessionId = 'TESTSESSION';

		Integer initialSize = [select Id from PKB_Article_Feedback_Deflection__c ].size();
		String emo = Case.Customer_emoticon_value__c.getDescribe().getPickListValues().get(0).getValue();

		Test.startTest();

		testRequestItem.articleFeedback.isDeferred = true;
		testRequestItem.articleFeedback.feedbackComments = 'a comment';
		testRequestItem.articleFeedback.searchString = 'what wwould';
		testRequestItem.articleFeedback.kavId = 'artID';
		testRequestItem.articleFeedback.articleNumber = 'ARTTTTNUM';
		testRequestItem.articleFeedback.title =  'THE TITLE FOR FEEDBACK';
		testRequestItem.articleFeedback.source =  's';

		pkb_mobile_proxy.ResponseItem resp =  pkb_mobile_controller.submitFeedBack(testRequestItem);

		Integer finalSize = [select Id from PKB_Article_Feedback_Deflection__c ].size();
		system.assert(resp.isSuccess);
		system.assertEquals( (initialSize+1) , finalSize );

		PKB_Article_Feedback_Deflection__c dF = [	select 	Article_ID__c, Article_Number__c, Article_Title__c, Feedback_Source__c, Comments__c,
															Session_ID__c, Channel__c, Deflection__c, Keyword_Searched__c
													from PKB_Article_Feedback_Deflection__c
													where Session_ID__c =: 'TESTSESSION' and Article_Number__c ='ARTTTTNUM' ];

		system.assertEquals(dF.Article_ID__c, testRequestItem.articleFeedback.kavId);



		testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.contactData = new map<String,String>();

		initialSize = [select Id from Case where CreatedById =: UserInfo.getUserId()].size();
		emo = Case.Customer_emoticon_value__c.getDescribe().getPickListValues().get(0).getValue();

		testRequestItem.sessionId = 'TESTSESSION';
		testRequestItem.contactData.put('firstName','TEST');//
		testRequestItem.contactData.put('lastName','ULTIMO NOME');//;
		testRequestItem.contactData.put('email','an@m.com');//'an@m.com';
		testRequestItem.contactData.put('reqType','Other');//'Other';
		testRequestItem.contactData.put('questionBody','WHAT WHOULD PKB2 DO');//;
		testRequestItem.contactData.put('latitude','0.2');//;
		testRequestItem.contactData.put('longitude','0.2');//;
		testRequestItem.contactData.put('emoIcon',emo);//;

		resp =  pkb_mobile_controller.processContactUs(testRequestItem);
		Test.stopTest();

		finalSize = [select Id from Case where CreatedById =: UserInfo.getUserId()].size();


		system.assert(resp.isSuccess);
		system.assertEquals( (initialSize+1) , finalSize );

		Case c = [select Id, ContactId, pkbgeolocalization__Latitude__s,pkbgeolocalization__Longitude__s,Customer_emoticon_value__c, Customer_emoticon__c  from Case where id =: resp.caseId];
		system.assertEquals(c.pkbgeolocalization__Latitude__s,0.2 );
		system.assertEquals(c.pkbgeolocalization__Longitude__s, 0.2);
		system.assertEquals(emo, c.Customer_emoticon_value__c);
		system.assert(c.Customer_emoticon__c.contains(emo) );

		List<PKB_Article_Feedback_Deflection__c> sessionDeflections = [	select Id,Session_ID__c , Contact__c
															from PKB_Article_Feedback_Deflection__c
															where
															Session_ID__c = :'TESTSESSION'];
		system.assertEquals(1,sessionDeflections.size());
		system.assertEquals(sessionDeflections.get(0).Contact__c, c.ContactId);

	}

	static  testMethod void test_processContactUs_invalidData() {

		pkb_mobile_proxy.ResponseItem resp = null;
		pkb_mobile_proxy.RequestItem testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.contactData = new map<String,String>();
		testRequestItem.lang = 'NEVAH';
		testRequestItem.operationType = 'SO WRONG';
		testRequestItem.sessionId = 'TESTSESSION';

		Integer initialSize = [select Id from Case where CreatedById =: UserInfo.getUserId()].size();

		Test.startTest();
		//0 - null request
		resp =  pkb_mobile_controller.processContactUs(null);
		system.assert(!resp.isSuccess);

		//1 - request lacking data
		testRequestItem.contactData.put('firstName','');//
		testRequestItem.contactData.put('lastName','');//;

		resp =  pkb_mobile_controller.processContactUs(testRequestItem);

		system.assert(!resp.isSuccess);
		system.assert(String.isNotBlank(resp.message));
		system.assertEquals(  initialSize , [select Id from Case where CreatedById =: UserInfo.getUserId()].size() );

		//2 - with empty fields
		testRequestItem.contactData.put('email','an@');//'an@m.com';
		testRequestItem.contactData.put('reqType','Other');
		resp =  pkb_mobile_controller.processContactUs(testRequestItem);

		system.assert(!resp.isSuccess);
		system.assert(String.isNotBlank(resp.message));
		system.assertEquals(  initialSize , [select Id from Case where CreatedById =: UserInfo.getUserId()].size() );

		//3 - invalid geolocalization data
		testRequestItem.contactData.put('email','an@dd.com');
		testRequestItem.contactData.put('latitude','NOT');//;
		testRequestItem.contactData.put('longitude','GOOD');//;
		resp =  pkb_mobile_controller.processContactUs(testRequestItem);


		system.assert(!resp.isSuccess);
		system.assert(String.isNotBlank(resp.message));
		system.assertEquals(  initialSize , [select Id from Case where CreatedById =: UserInfo.getUserId()].size() );


		//4 - invalid emoIcon data
		testRequestItem.contactData.put('email','an@dd.com');
		testRequestItem.contactData.put('latitude',null);//;
		testRequestItem.contactData.put('longitude',null);//;
		testRequestItem.contactData.put('emoIcon','NOT IN THE PICKLIST');
		resp =  pkb_mobile_controller.processContactUs(testRequestItem);

		system.assert(!resp.isSuccess);
		system.assert(String.isNotBlank(resp.message));
		system.assertEquals(  initialSize , [select Id from Case where CreatedById =: UserInfo.getUserId()].size() );

		Test.stopTest();

	}

	//	public static pkb_mobile_proxy.ResponseItem submitFeedBack(pkb_mobile_proxy.RequestItem req){
	static  testMethod void test_submitFeedBack() {

		pkb_mobile_proxy.RequestItem testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.articleFeedback = new pkb_mobile_proxy.FeedBackDetails();
		testRequestItem.operationType = 'submitFeedBack';


		Integer initialSize = [select Id from PKB_Article_Feedback_Deflection__c ].size();

		String emo = Case.Customer_emoticon_value__c.getDescribe().getPickListValues().get(0).getValue();

		Test.startTest();

		testRequestItem.articleFeedback.isDeferred = true;
		testRequestItem.articleFeedback.feedbackComments = 'a comment';
		testRequestItem.articleFeedback.searchString = 'what wwould';
		testRequestItem.articleFeedback.kavId = 'artID';
		testRequestItem.articleFeedback.articleNumber = 'ARTTTTNUM';
		testRequestItem.articleFeedback.title =  'THE TITLE FOR FEEDBACK';
		testRequestItem.articleFeedback.source =  's';
		testRequestItem.sessionId = 'TESTSESSION';

		pkb_mobile_proxy.ResponseItem resp =  pkb_mobile_controller.submitFeedBack(testRequestItem);
		Test.stopTest();

		Integer finalSize = [select Id from PKB_Article_Feedback_Deflection__c ].size();

		system.assert(resp.isSuccess);
		system.assertEquals( (initialSize+1) , finalSize );

		PKB_Article_Feedback_Deflection__c dF = [	select 	Article_ID__c, Article_Number__c, Article_Title__c, Feedback_Source__c, Comments__c,
															Session_ID__c, Channel__c, Deflection__c, Keyword_Searched__c
													from PKB_Article_Feedback_Deflection__c
													where Session_ID__c =: 'TESTSESSION' and Article_Number__c ='ARTTTTNUM' ];

		system.assertEquals(dF.Article_ID__c, testRequestItem.articleFeedback.kavId);

		system.assertEquals(dF.Channel__c, 'mobile');

	}


	/*******************************************************************
		SITEMAPS Test methods
	********************************************************************/


	@isTest(SeeAllData=true)
	static  void test_pkb_SiteMap() {

		pkb_SiteMap.MAX_ARTICLES = 7;
		//count Initial amount of kav


		pkb_SiteMap.DEFAULT_PUBLISH_STATUS = 'Draft';
		Integer initialNumber = 0;
		String q = ' SELECT  count() ' +
						' FROM KnowledgeArticleVersion ' +
						' WHERE ' +
						' (PublishStatus = \''+pkb_SiteMap.DEFAULT_PUBLISH_STATUS+'\' AND IsVisibleInPkb = true AND Language=\'en_US\' )  ' +
						' LIMIT '+ Limits.getLimitQueryRows();

		Integer current_en_Us  =  Database.countQuery(q);
		q = ' SELECT  count() ' +
						' FROM KnowledgeArticleVersion ' +
						' WHERE ' +
						' (PublishStatus = \''+pkb_SiteMap.DEFAULT_PUBLISH_STATUS+'\' AND IsVisibleInPkb = true AND Language=\'es\' )  ' +
						' LIMIT '+ Limits.getLimitQueryRows();

		Integer current_es  = 0;// Database.countQuery(q); if we had multilanguage

		q = ' SELECT  count() ' +
						' FROM KnowledgeArticleVersion ' +
						' WHERE ' +
						' (PublishStatus = \''+pkb_SiteMap.DEFAULT_PUBLISH_STATUS+'\' AND IsVisibleInPkb = true AND Language=\'fr\' )  ' +
						' LIMIT '+ Limits.getLimitQueryRows();

		Integer current_fr  =  0;//Database.countQuery(q); if we had multilanguage


		populatePKB2Environment();
		PKB__c pkS = populateSetup();

		pkb_SiteMap pSM = new pkb_SiteMap();

		//assert size of article types
		//Integer allTypes = KnowledgeArticleVersion.ArticleType.getDescribe().getPickListValues().size();
		//system.assertEquals(allTypes, pSM.availableArticleTypes.size());

		//assert size of languages
		Integer allLang = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().size();
		system.assertEquals(allLang, pSM.availableLanguages.size());

		//test SiteMAp index
		Integer aNum = 7 ;
		Double totalP = 0;

		populateArticles( 'en_US',aNum);
		//calculate pages
		Integer max  =  aNum + current_en_Us;
		Long l = Math.mod( max,pkb_SiteMap.MAX_ARTICLES);
		Double numPages = Math.floor(max/pkb_SiteMap.MAX_ARTICLES);
		if (  l>0){
			numPages = numPages+ 1;
		}
		totalP +=numPages;
		List<pkb_SiteMap.SMWrapper> lI = pSM.getSiteMapsList();

		system.assertEquals(totalP, lI.size());

		// test offset

		PageReference pr = new PageReference('/');
		pr.getParameters().put('offset','0');
		pr.getParameters().put('lang','en_US');
		Test.setCurrentPage(pr);
		pSM = new pkb_SiteMap();

		List<pkb_SiteMap.KAWrapper> lKw = pSM.getDocumentationList();
		system.assertEquals(pkb_SiteMap.MAX_ARTICLES, lKw.size());

		pr.getParameters().put('offset','e');//default value will be 0
		pr.getParameters().put('lang','');//default value will be 'en_US'
		Test.setCurrentPage(pr);
		pSM = new pkb_SiteMap();

		lKw = pSM.getDocumentationList();
		system.assertEquals(pkb_SiteMap.MAX_ARTICLES, lKw.size());

		pr.getParameters().put('offset','60');
		Test.setCurrentPage(pr);
		pSM = new pkb_SiteMap();

		lKw = pSM.getDocumentationList();
		system.assertEquals(0, lKw.size());

	}


	/*******************************************************************
		PKB MOBILE PROXY Test methods
	********************************************************************/

	static testMethod void test_getRemoteAction() {
		string response = '';
		String testRequestJson = '';
		pkb_mobile_proxy.RequestItem testRequestItem = null;


		Test.startTest();

	//case0 : invoke with null
		response=pkb_mobile_proxy.getRemoteAction(null);
		system.assert(response.Contains('"isSuccess":false'));

	//case1 : invoke with empty
		response=pkb_mobile_proxy.getRemoteAction('{}');
		system.assert(response.Contains('"isSuccess":false'));

	//case2 : invoke with invalid json string
		response=pkb_mobile_proxy.getRemoteAction('{NOT VALID}');
		system.assert(response.Contains('"isSuccess":false'));


	//case3 :check no parameters
		testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.sessionId = 'TESTSESSION';
		testRequestJson = JSON.serialize(testRequestItem);
		response=pkb_mobile_proxy.getRemoteAction(testRequestJson);
		system.assert(response.Contains('"isSuccess":false'));

	//case4 :check wrong parameters
		testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.sessionId = 'TESTSESSION';
		testRequestItem.lang = 'NEVAH';
		testRequestItem.operationType = 'SO WRONG';
		testRequestJson = JSON.serialize(testRequestItem);
		response=pkb_mobile_proxy.getRemoteAction(testRequestJson);
		system.assert(response.Contains('"isSuccess":false'));

	//case4 :check correct parameters
		testRequestItem = new pkb_mobile_proxy.RequestItem();
		testRequestItem.lang = KnowledgeArticleVersion.Language.getDescribe().getPickListValues().get(0).getValue();
		List<String> nl = new List<String>();
		nl.addAll(pkb_mobile_proxy.validOperations);
		testRequestItem.operationType = nl[0];
		testRequestJson = JSON.serialize(testRequestItem);
		response=pkb_mobile_proxy.getRemoteAction(testRequestJson);
		system.assert(response.Contains('"isSuccess":true'));

		for(String option : pkb_mobile_proxy.validOperations){

			testRequestItem.operationType = option;
			testRequestJson = JSON.serialize(testRequestItem);
			response=pkb_mobile_proxy.getRemoteAction(testRequestJson);
		}


		Test.stopTest();
	}


	static testMethod void uploadTest() {
		//Split string 'file' in to two chunks, first chunk must be divisible by 3 for base64 encode with no padding
		Blob part1 = Blob.valueOf('This text re'); //length is 12
		Blob part2 = Blob.valueOf('presents a dummy file');

		String part1base64 = EncodingUtil.base64Encode(part1);
		String part2base64 = EncodingUtil.base64Encode(part2);

		//Create a test accound the 'file' can be attached to.
		Account acct = new Account(Name = 'test');
		insert acct;

		//Start the test
		Test.startTest();
		//Send first part of the file to be uploaded
		String attachmentId = pkb_mobile_proxy.postBlobContent((String)acct.Id,'','fileName','text',part1base64);

		//Send the second piece of the file to be uploaded
		pkb_mobile_proxy.postBlobContent(acct.Id,attachmentId,'fileName','text',part2base64);
		Test.stopTest();

		//Assert one file has been attached to the test account
		List<Attachment> attachments = [select Id, Body from Attachment where ParentId = :acct.Id];
		system.assert(attachments.size() == 1);

		//Assert the contents of the split file were recontructed correctly
		system.assert(attachments[0].Body.toString() == 'This text represents a dummy file');
	}


	/*******************************************************************
		MOBILE setup Test methods
	********************************************************************/

 	@isTest(SeeAllData=true)
	static void test_MobileConfigController(){
		PKB__c pkS = pkb_mobile_Test.populateSetup();

		List<String> kavNames = new List<String>(pkb_Controller.kavNames);
		if (kavNames.isEmpty()) return;
		objType = kavNames.get(0);

		pkb_Controller.DEFAULT_SITE_NAME =  siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();

		pkb_ka__c elm = new pkb_ka__c();
		elm.Name = '1234567890-112';
		elm.apiName__c = objType;
		elm.layout__c = 'Title,Summary';
		elm.pkb__c = pkS.Name;

		insert elm;

		Object ret = pkb_Mobile_ConfigController.getKnowledgeArticlesCustomSetting(pkS.Name);
		map<String,Object> r = (map<String,Object>) ret;
		system.assertEquals(r.get('size'),1);

		delete elm;

		ret = pkb_Mobile_ConfigController.getKnowledgeArticlesCustomSetting(pkS.Name);
		r = (map<String,Object>) ret;
		system.assertEquals(r.get('size'),0);

		Map<String,String> m = pkb_mobile_controller.getLangMap();

		String toSend = '';
		for ( String a : m.keySet() ){
			toSend = toSend+','+a;
		}

		Object kStructure = pkb_Mobile_ConfigController.getKAStructure( toSend );
		system.assertNotEquals(null,kStructure);

		pkb_Mobile_ConfigController newCT = new pkb_Mobile_ConfigController(new ApexPages.StandardController(new PKB__c()));


		Object res = pkb_Mobile_ConfigController.getKAStructure(null);
		String resStr = String.valueof(res);
		system.assert(resStr.contains('Fatal Error'));

	}


 	 	@isTest(SeeAllData=true)
	static void test_getArticleTypeLayout(){
		PKB__c pkS = pkb_mobile_Test.populateSetup();

		List<String> kavNames = new List<String>(pkb_Controller.kavNames);
		if (kavNames.isEmpty()) return;
		objType = kavNames.get(0);

		pkb_Controller.DEFAULT_SITE_NAME =  siteName;
		pkb_Controller pc = pkb_mobile_controller.setUp();
		pkb_ka__c elm = new pkb_ka__c();
		elm.Name = '1234567890-112';
		elm.apiName__c = objType;
		elm.layout__c = 'Title,Summary';
		elm.pkb__c = pkS.Name;

		insert elm;

		String l = pkb_Mobile_CustomSettingModel.getArticleTypeLayout(pkS.Name,objType);
		system.assertEquals(l,elm.layout__c);
	}

	static testMethod void testPageController() {

		PKB__c pkS = populateSetup();
		pkb_Controller.DEFAULT_SITE_NAME = siteName;
		pkb_mobile_proxy tmp = new pkb_mobile_proxy();
	}



	@isTest(SeeAllData=true)
	static void test_MobilePhoneCall(){
		PKB__c pkS = populateSetup();
		BusinessHours bH = [Select Id from BusinessHours where IsDefault = true limit 1];

		DateTime timeToSend = businesshours.addGmt(bH.id, system.now(), 1000 * 60);
		map<String,String> resp = (map<String,String>) pkb_mobile_controller.getPhoneCallAvailable(timeToSend);
		system.assertEquals( 'true', resp.get('available') );

	}


	public static PKB__c populateSetup() {
		// create custom settings collection based on siteName
		PKB__c pkb = new PKB__c();
		pkb.Name = siteName;
		pkb.MCategory_Group_1__c = 'group1';
		pkb.MCategory_Group_2__c = 'group2';
		pkb.MCategory_Group_3__c = 'group3';
		pkb.MRoot_Category_1__c = 'root1';
		pkb.MRoot_Category_2__c = 'root2';
		pkb.MRoot_Category_3__c = 'root3';

		pkb.Create_Contact_and_Account__c = false;
		pkb.Contact_Us_Available__c = false;
		pkb.Display_Article_Summary__c = true;
		pkb.Multi_Language_Enabled__c = true;
		pkb.Popular_Articles_Size__c = 2;
		pkb.Related_Articles_Size__c = 2;
		pkb.Results_Page_Size__c = 2;
		pkb.Selected_Languages__c = 'en_US';
		pkb.MEnableCall__c = true;
		pkb.MBusinessHours__c = 'testPkbMT';
		pkb.MPhoneNumber__c = '+59899501206';

		insert pkb;
		if (kavObj != null){

			//insert records on the KAV fields custom setting
			Id kavID = String.valueOf(kavObj.get('id'));
			Schema.SObjectType token = kavID.getSObjectType();
			Schema.DescribeSObjectResult dr = token.getDescribe();
			set<String> allFields = token.getDescribe().fields.getMap().keySet();
			list<String> listFields = new list<String>();
			listFields.addAll(allFields);
			String layout = String.join(listFields,',');
			Integer cutAt = layout.lastIndexOf(',', 50);
			pkb_Ka__c pkF = new pkb_Ka__c();
			pkF.layout__c = layout.substring(0,cutAt);
			pkF.apiName__c  =  objType;
			pkF.pkb__c = pkb.Id;
			pkF.Name ='RAMDOM_UNUSED_NAME';
			insert pkF;
		}


		system.debug(logginglevel.INFO,'\n\n\n=======\n pkb_mobile_Test populateSetup ['+siteName+'] \n >>>Contact_Us_Available__c : '+pkb.Contact_Us_Available__c);

		return pkb;
	}


	/**
	* @description populate kknowledge articles
 	*/
	public static void populateArticles(String artlang, Integer max){

		list<SObject> kavObjList = new list<SObject>();

		for (Integer i =0 ; i < max ; i++){

			kavObj = Schema.getGlobalDescribe().get(objType).newSObject();
			kavObj.put('Title','SAMPLE foo title!!!');
			kavObj.put('UrlName', 'url'+String.valueOf(Crypto.getRandomInteger()));
			kavObj.put('Summary', 'This is a summary!!! for the test article.');
			kavObj.put('Language', artlang);
			kavObj.put('IsVisibleInPkb', true);
			kavObjList.add( kavObj);

		}

		insert kavObjList;

	}

	/**
	* @description populate kknowledge articles
 	*/
	 static void populatePKB2Environment(){

		// create article of first type found in the objects that end with __kav , from pkb2 tests
		List<String> kavNames = new List<String>(pkb_Controller.kavNames);
		if (kavNames.isEmpty()) return;

		// set the controller's default pub status to draft so that the queries will find records
		pkb_Controller.DEFAULT_PUBLISH_STATUS = publishStatus;
		pkb_Controller.DEFAULT_SITE_NAME = siteName;

		//use KA to wich I have permissions
		Map<String,Boolean> checkACCESS = pkb_securityHandler.getKAVPermissions();
		for(String k : checkACCESS.keySet() ){
			 if (checkACCESS.get(k) == true )
			 	objType = k;
		}

		//remove the namespace
		objType = objType.replace(pkb_mobile_controller.getNamespace(),'');

		System.debug('\n TEST ENVIRONMENT PKB2 MOBILE - CUSTOM ARTICLE TYPE: ' +objType+ '\n=====publishStatus : '+publishStatus+'=================\n');

		kavObj = Schema.getGlobalDescribe().get(objType).newSObject();
		kavObj.put('Title','SAMPLE foo title!!!');
		kavObj.put('UrlName', 'url-foo-foo');
		kavObj.put('Summary', 'This is a summary!!! for the test article.');
		kavObj.put('Language', lang);
		insert kavObj;

		system.debug('\n\n===== created \n ');system.debug(kavObj.id);
		// requery the kavObj to get the KnowledgeArticleId on it that is created automatically
		String q = 'select ' +pkb_Controller.join(pkb_Controller.kavFields, ',')+ ' from KnowledgeArticleVersion where Id = \'' +kavObj.get('Id')+  '\' and PublishStatus = :publishStatus';


	system.debug('\n\n===== query ['+publishStatus+']\n '+q);
		kavObj = (KnowledgeArticleVersion)Database.query(q);

		// create featured record
		featured = new PKB_Featured__c(
			Article_Number__c = (String)kavObj.get('ArticleNumber'),
			Is_Keyword_Article__c = false,
			PKB_Name__c = siteName
		);
		insert featured;

		System.debug('\n pkb2 FEATURED RECORD JUST CREATED: ' +featured.Id+ '\n');
		System.debug(featured);

		// create keyword recommended record
		keyword = new PKB_Featured__c(
			Article_Number__c = (String)kavObj.get('ArticleNumber'),
			Is_Keyword_Article__c = true,
			Keyword__c = 'MAGIC',
			PKB_Name__c = siteName
		);
		insert keyword;

		System.debug('***** KEYWORD RECORD JUST CREATED: ' +keyword.Id+ ' *****');
		System.debug(keyword);

	}

	public static String getTestBusinessHourName(){
		BusinessHours bH = [Select Id,Name from BusinessHours where IsDefault = true limit 1];
		return bH.Name;
	}

	/** language labels**/
	static testMethod void test_LanguageLabels() {
		//check that we have defined all languages on the user locale picklist
		Map<String,String> langMap= pkb_mobile_controller.getLangMap();
		if (langMap.containsKey('da')){
			system.assertNotEquals(Label.pkb2_lang_da,'');
		}
		if (langMap.containsKey('it')){
			system.assertNotEquals(Label.pkb2_lang_it,'');
		}
		if (langMap.containsKey('pt_BR')){
			system.assertNotEquals(Label.pkb2_lang_pt_BR,'');
		}
		if (langMap.containsKey('en_US')){
			system.assertNotEquals(Label.pkb2_lang_en_US,'');
		}
		if (langMap.containsKey('ko')){
			system.assertNotEquals(Label.pkb2_lang_ko,'');
		}
		if (langMap.containsKey('zh_CN')){
			system.assertNotEquals(Label.pkb2_lang_zh_CN,'');
		}
		if (langMap.containsKey('th')){
			system.assertNotEquals(Label.pkb2_lang_th,'');
		}
		if (langMap.containsKey('de')){
			system.assertNotEquals(Label.pkb2_lang_de,'');
		}
		if (langMap.containsKey('fi')){
			system.assertNotEquals(Label.pkb2_lang_fi,'');
		}
		if (langMap.containsKey('zh_TW')){
			system.assertNotEquals(Label.pkb2_lang_zh_TW,'');
		}
		if (langMap.containsKey('fr')){
			system.assertNotEquals(Label.pkb2_lang_fr,'');
		}
		if (langMap.containsKey('sv')){
			system.assertNotEquals(Label.pkb2_lang_sv,'');
		}
		if (langMap.containsKey('ru')){
		system.assertNotEquals(Label.pkb2_lang_ru,'');
		}
		if (langMap.containsKey('es')){
			system.assertNotEquals(Label.pkb2_lang_es,'');
		}
		if (langMap.containsKey('nl_NL')){
			system.assertNotEquals(Label.pkb2_lang_nl_NL,'');
		}
		if (langMap.containsKey('ja')){
			system.assertNotEquals(Label.pkb2_lang_ja,'');
		}
		//extra labels
		system.assertNotEquals(Label.pkb2_lang_bs,'');
		system.assertNotEquals(Label.pkb2_lang_cy,'');
		system.assertNotEquals(Label.pkb2_lang_et,'');
		system.assertNotEquals(Label.pkb2_lang_eu,'');
		system.assertNotEquals(Label.pkb2_lang_ga,'');
		system.assertNotEquals(Label.pkb2_lang_hi,'');
		system.assertNotEquals(Label.pkb2_lang_hr,'');
		system.assertNotEquals(Label.pkb2_lang_hy,'');
		system.assertNotEquals(Label.pkb2_lang_is,'');
		system.assertNotEquals(Label.pkb2_lang_ka,'');
		system.assertNotEquals(Label.pkb2_lang_lb,'');
		system.assertNotEquals(Label.pkb2_lang_lt,'');
		system.assertNotEquals(Label.pkb2_lang_lv,'');
		system.assertNotEquals(Label.pkb2_lang_mk,'');
		system.assertNotEquals(Label.pkb2_lang_mt,'');
		system.assertNotEquals(Label.pkb2_lang_nl_NL,'');
		system.assertNotEquals(Label.pkb2_lang_pt_BR,'');
		system.assertNotEquals(Label.pkb2_lang_pt_PT,'');
		system.assertNotEquals(Label.pkb2_lang_ro_MD,'');
		system.assertNotEquals(Label.pkb2_lang_sh,'');
		system.assertNotEquals(Label.pkb2_lang_sk,'');
		system.assertNotEquals(Label.pkb2_lang_sl,'');
		system.assertNotEquals(Label.pkb2_lang_sq,'');
		system.assertNotEquals(Label.pkb2_lang_sr,'');
		system.assertNotEquals(Label.pkb2_lang_sv,'');
		system.assertNotEquals(Label.pkb2_lang_th,'');
		system.assertNotEquals(Label.pkb2_lang_tl,'');
		system.assertNotEquals(Label.pkb2_lang_ur,'');
	}

	}