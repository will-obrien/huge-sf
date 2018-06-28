public with sharing class pkb_mobile_controller {


	/* ***** DEFAULT SETTINGS TO BE USED ELSEWHERE IN APP WHEN CUSTOM SETTINGS FOR CURRENT SITE CANNOT BE FOUND ***** */
	public static Integer MAX_ARTICLES = 50;
	public static Integer MAX_QUERY_ROWS = 1000;
	public final static String MAX_ALLOWED_FILES_TO_UPLOAD = '1';
	public static String DEFAULT_LANGUAGE = 'en_US';


    /**
    * @description
    *       returns instance of original pkb_controller
    * @return pkb_Controller instance
    **/
    public  static pkb_Controller setUp(){

        pkb_Controller refCon = new pkb_Controller();

        PKB__c  pkbSetting  = getCurrentSiteSetting (refCon);
        MAX_ARTICLES =  (pkbSetting == null ? refCon.articlesPerPage : Integer.valueOf(pkbSetting.MResults_Page_Size__c));

        return refCon;
    }

    /*******************************************************************
        methods to handle PKB__c custom setting
    ********************************************************************/
    /**
    * @description
    *       return list with the root names of data categories
    * @param ref - PKB__c
    * @return string List
    **/
    public static Map<String,String> getGroupToRoot (PKB__c ref){
        Map<String,String> res = new Map<String,String>();

        if (ref.MCategory_Group_1__c != null && ref.MRoot_Category_1__c != null)
            res.put(ref.MCategory_Group_1__c, ref.MRoot_Category_1__c);
        if (ref.MCategory_Group_2__c  != null && ref.MRoot_Category_2__c != null)
            res.put(ref.MCategory_Group_2__c,ref.MRoot_Category_2__c);
        if (ref.MCategory_Group_3__c != null && ref.MRoot_Category_3__c != null)
            res.put(ref.MCategory_Group_3__c,ref.MRoot_Category_3__c);

        return res;
    }

    /**
    * @description
    *   returns list of Configured data categories
    * @param ref - PKB__c
    * @return list<pkb_mobile_proxy.PKBDataCategory>
    **/
    public static list<pkb_mobile_proxy.PKBDataCategory> getCategoryGroupData (PKB__c ref){
        list<pkb_mobile_proxy.PKBDataCategory> res = new list<pkb_mobile_proxy.PKBDataCategory>();

        if (ref.MCategory_Group_1__c != null && ref.MRoot_Category_1__c != null)
            res.add(new pkb_mobile_proxy.PKBDataCategory(ref.MCategory_Group_1__c, ref.MRoot_Category_1__c, System.Label.PKB2_Category_MGroup_Label_1));
        if (ref.MCategory_Group_2__c  != null && ref.MRoot_Category_2__c != null)
            res.add(new pkb_mobile_proxy.PKBDataCategory(ref.MCategory_Group_2__c, ref.MRoot_Category_2__c, System.Label.PKB2_Category_MGroup_Label_2));
        if (ref.MCategory_Group_3__c != null && ref.MRoot_Category_3__c != null)
            res.add(new pkb_mobile_proxy.PKBDataCategory(ref.MCategory_Group_3__c, ref.MRoot_Category_3__c, System.Label.PKB2_Category_MGroup_Label_3));

        return res;
    }
    /**
    * @description
    *       returns Customer setting with pkb2 configuration for current site
    * @param sitename - String
    * @return PKB__c record
    **/
    public static PKB__c  getCurrentSiteSetting (pkb_Controller refCon){

        PKB__c res = null;
        Map<String,PKB__c> settingsMap = PKB__c.getAll();
        if (settingsMap.containsKey(refCon.sitename)){
            res = settingsMap.get(refCon.sitename);
        }else{
            res = new PKB__c();
            res.Popular_Articles_Size__c = refCon.popularArticles;
            res.Related_Articles_Size__c = refCon.relatedArticles;
            res.Multi_Language_Enabled__c = refCon.multiLanguage;
            res.Selected_Languages__c = refCon.availableLanguages;
            res.MResults_Page_Size__c = 5;
        }
        return res;
    }

    /*******************************************************************
        methods to handle article lists
    ********************************************************************/
    /**
    * @description TODO
    *
    * @param dcString - String
    * @param p - pkb_Controller
    * @return String
    **/
    private static String dataCategoryFilter(String dcString,pkb_Controller p){

        String qDC = '';
        if (String.isNotBlank(dcString) ){
            p.selectedCategory = dcString;
            qDC = p.buildCategorySosl();
            qDC =  qDC.replace(' AT ', ' ABOVE_OR_BELOW ');//BELOW
            qDC = ' WITH DATA CATEGORY '+ qDC;
        }
        return qDC;
    }

    /**
    * @description
    *       converts datetime parameter into string expression of elapse time : day , month , year
    * @param Datetime - sourceTime
    * @return String
    **/
    public static String parseElapsedTime (Datetime sourceTime){
        String result ='';
        list<String> monthNames = new list<String>{
                                System.Label.PKB2_month_january,
                                System.Label.PKB2_month_february,
                                System.Label.PKB2_month_march,
                                System.Label.PKB2_month_april,
                                System.Label.PKB2_month_may,
                                System.Label.PKB2_month_june,
                                System.Label.PKB2_month_july,
                                System.Label.PKB2_month_august,
                                System.Label.PKB2_month_september,
                                System.Label.PKB2_month_october,
                                System.Label.PKB2_month_november,
                                System.Label.PKB2_month_december};


        Date sourceDate = sourceTime.Date();
        Date today = date.today();
        Date yesterday = today.addDays(-1);

        if (sourceDate.isSameDay(today)){
            result = System.Label.PKB2_today;
        }else
            if (sourceDate.isSameDay(yesterday)){
            result = System.Label.PKB2_yesterday;
            }
            else{
                result =  sourceTime.day() +' '+monthNames.get(sourceTime.month()-1) +' '+sourceTime.year();
        }
        return result;
    }

    /**
    * @description
    *
    * @param set <Id> - source
    * @return map <Id,Integer>
    **/
    private static map <Id,Integer> calculateViewStats (set <Id> source){

        Map<Id, Integer> viewStats = new Map<Id, Integer>();
        String qStr =   '   SELECT Id, ViewCount, Parent.Id  '+
                        '   FROM KnowledgeArticleViewStat where Channel = \'Pkb\''+
                        ' and Parent.Id in :source limit :MAX_QUERY_ROWS';

        for (KnowledgeArticleViewStat  lKStat : Database.query(qStr)){
            viewStats.put(lKStat.Parent.Id ,Integer.valueOf(lKStat.ViewCount) );
        }

        return viewStats;
    }
    /**
    * @description
    *
    * @param set <String> - source
    * @return map <Id,Integer>
    **/
    private static map <Id,Integer> calculateUsefulnesStats (set <Id> source){
        Map<Id, Integer> usefulStats = new Map<Id, Integer>();


        for ( AggregateResult elm : [   SELECT Article_ID__c, count(id)
                                        FROM PKB_Article_Feedback_Deflection__c
                                        WHERE Deflection__c = true and Article_ID__c in:source
                                        Group by Article_ID__c
                                        limit : MAX_QUERY_ROWS] ){
            usefulStats.put(String.valueOf(elm.get('Article_ID__c')),Integer.valueOf(elm.get('expr0')));
            source.remove(String.valueOf(elm.get('Article_ID__c')));

        }
        //for all the source ID that weren't references in the deflection set useful to 0
        for(Id i: source){
            usefulStats.put(i,0);
        }

        return usefulStats;
    }



    /**
    * @description
    *       converts KnowledgeArticleData items of the list into  mobileKnowledgeArticleData by adding elapsed time
    * @param list <pkb_Controller.KnowledgeArticleData> - source
    * @return list <pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    private static list <pkb_mobile_proxy.mobileKnowledgeArticleData> processForMobile (list <pkb_Controller.KnowledgeArticleData> source,Integer maxItems){

        Map<String,Boolean> checkACCESS = pkb_securityHandler.getKAVPermissions();

        set<Id> kaIds = new set<Id>();
        for ( pkb_Controller.KnowledgeArticleData ka : source ){
            kaIds.add(ka.Id);
        }

        Map<Id, Integer> viewStats = calculateViewStats(kaIds);
        Map<Id, Integer> useStats = calculateUsefulnesStats(kaIds);

        list <pkb_mobile_proxy.mobileKnowledgeArticleData> res = new list <pkb_mobile_proxy.mobileKnowledgeArticleData>();
        pkb_mobile_proxy.mobileKnowledgeArticleData tmp = null;
        for ( pkb_Controller.KnowledgeArticleData ka : source ){
             Id theKAId = ka.theAV.Id;
            if (  checkACCESS.get(theKAId.getSObjectType().getDescribe().getName()) &&
            ((maxItems == 0)  || (res.size() < maxItems) ) ) {
            tmp = new pkb_mobile_proxy.mobileKnowledgeArticleData (ka);
            String elap;
            if (Test.isRunningTest()){
                elap =  parseElapsedTime (ka.lastModifiedDate);
            }else{
                elap =  parseElapsedTime (ka.lastPublishedDate);
            }

            tmp.elapsed =  elap ;
            tmp.viewStat = viewStats.get(ka.Id);
            tmp.usefulStat = useStats.get(ka.Id);
            res.add(tmp);

            }
        }
        return res;
    }

    /**
    * @description
    *   returns list of featured articles calculated by pkb_mobile controller
    * @param pkb_mobile_proxy.RequestItem - req
    * @return pkb_mobile_proxy.ResponseItem
    **/
    public static pkb_mobile_proxy.ResponseItem getFeaturedArticles(pkb_mobile_proxy.RequestItem req){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try {
            pkb_Controller p = setUp();
            p.selectedLanguage  = getRequestedLanguage(req);
            p.buildFeaturedKads();
            resp.articles = processForMobile(p.featuredKads,0);
        } catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n'+ ex.getStackTraceString();
        }

        return resp;
    }

    /**
    * @description
    *   returns list of popular articles calculated
    * @param pkb_mobile_proxy.RequestItem - req
    * @return pkb_mobile_proxy.ResponseItem
    **/
    public static pkb_mobile_proxy.ResponseItem getPopularArticles(pkb_mobile_proxy.RequestItem req){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try {

            Map<String,Boolean> checkACCESS = pkb_securityHandler.getKAVPermissions();

            pkb_Controller p = setUp();
            PKB__c thisSetting =  getCurrentSiteSetting(p);

            Integer maxPopular = Integer.valueOf(thisSetting.Popular_Articles_Size__c);
            Integer maxKAVrecords = Limits.getLimitQueryRows() - Limits.getQueryRows() - 2 * maxPopular;

            list<String> kList = new list<String>();

            //build WITH DATA CATEGORY filter lines
            String qDC = dataCategoryFilter(req.dataCategories,p);

            /*

            SELECT Id,ParentId FROM KnowledgeArticleViewStat WHERE Channel = 'pkb'
            AND ParentId in
            (SELECT KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Language = 'en_US'  )
            ORDER BY NormalizedScore DESC NULLS FIRST

            first : obtain a candidate set of kav matching the data categories criteria and language

            */

            String KAVQ =   '   SELECT KnowledgeArticleId '+
                            '   FROM KnowledgeArticleVersion '+
                            '   WHERE PublishStatus =\''+pkb_Controller.DEFAULT_PUBLISH_STATUS +
                            '\' AND Language =\''+req.lang +'\' '
                            + qDC + ' LIMIT :maxKAVrecords ';

            list<String>  KAIds = new list<String>();
            for (KnowledgeArticleVersion  aId : Database.query(KAVQ)){
            	 Id theKAId = aId.Id;
            if (  checkACCESS.get(theKAId.getSObjectType().getDescribe().getName()) &&
             		(KAIds.size() < maxPopular)  ) {
                		KAIds.add(aId.KnowledgeArticleId);
                }
            }

            /*
                second: for those candidate sort them
            */
            String qStr =   '   SELECT Id, NormalizedScore, Parent.Id  '+
                            '   FROM KnowledgeArticleViewStat where Channel = \'Pkb\''+
                            '   AND ParentId in: KAIds  '+
                            '   ORDER BY NormalizedScore desc limit :maxPopular ';

            for (KnowledgeArticleViewStat  lKStat : Database.query(qStr)){
                kList.add(lKStat.Parent.Id);
            }

            list<pkb_Controller.KnowledgeArticleData> tmp = pkb_Controller.initFromListOfArticleIds(kList, req.lang);
            list<pkb_mobile_proxy.mobileKnowledgeArticleData> tmp2 = processForMobile(tmp,maxPopular);
            // KEEP THE SORTING!!!!!
            Map<Id,pkb_mobile_proxy.mobileKnowledgeArticleData> idToArt = new Map<Id,pkb_mobile_proxy.mobileKnowledgeArticleData>();
            //go over the list of kavs and create a map kavId to Kav
            for(pkb_mobile_proxy.mobileKnowledgeArticleData k : tmp2){
                idToArt.put(k.theAV.KnowledgeArticleId,k);
            }
            //use the list ordered by view stats to build the returned list
            resp.articles = new list<pkb_mobile_proxy.mobileKnowledgeArticleData>();
            for(Id i : kList){
                if (idToArt.containsKey(i)){
                    resp.articles.add(idToArt.get(i));
                }
            }

        } catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n'+ ex.getStackTraceString();
        }

        return resp;
    }


    /**
    * @description TODO
    *
    * @param pkb_mobile_proxy.RequestItem - req
    * @return pkb_mobile_proxy.ResponseItem
    **/
    public static pkb_mobile_proxy.ResponseItem getRecommendedArticles(pkb_mobile_proxy.RequestItem req){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try {
            pkb_Controller p = setUp();
            p.selectedLanguage  = getRequestedLanguage(req);
            p.theArticle = new KnowledgeArticle();
            resp.articles = getRecommendedArticlesByKeyword(p,req);

        }catch(System.SearchException sx){
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    =  sx.getMessage();
        }  catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n'+ ex.getStackTraceString();
        }

        return resp;
    }

    /**
    * @description
    *   returns list of recommended articles :
    *           - first we retrieve the list of matching keyword articles PKB_Featured__c
    *           - we build a result list
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    private static list<pkb_mobile_proxy.mobileKnowledgeArticleData> getRecommendedArticlesByKeyword(pkb_Controller p,  pkb_mobile_proxy.RequestItem req){

        list<list<sObject>> results = new list<list<sObject>>();
        list <pkb_mobile_proxy.mobileKnowledgeArticleData> res ;

        List<PKB_Featured__c> pkbfs;
        Set<String> anums = new Set<String>();
        String escapedQ = req.searchCriteria;
        if (String.isNotBlank(escapedQ))
            escapedQ = String.escapeSingleQuotes(req.searchCriteria);
        String orQuery;
        // split the escapedQ by spaces, trim by commas, periods, etc
        orQuery = pkb_Controller.buildOrQuery(escapedQ);//'\"\"\"\"\"\"*';//

        PKB__c current =  getCurrentSiteSetting (p);
        String sName = current.Name;

        // gather recommended article numbers based on keyword search from the PKB Featured object and put into set
        // recommended articles are records of the PKB_Feedback__c object that:
        // 1. have a keyword value
        // 2. have the Is_Keyword_Article__c box is checked
        // 3. the record Name field matches the name of the Site being viewed
        String q = '';
        q += 'FIND \'' + orQuery + '\' IN ALL FIELDS RETURNING ';
        q += getNamespace()+'PKB_Featured__c(Keyword__c, Article_Number__c where Is_Keyword_Article__c = true';
        q+= ' and PKB_Name__c = : sName';
        q+= ' ORDER BY Order__c ASC NULLS last)';

        List<List<SObject>> searchList = Search.query(q);
        pkbfs = (List<PKB_Featured__c>)searchList[0];
        for (PKB_Featured__c f : pkbfs) {
            anums.add(f.Article_Number__c);
        }

        list <pkb_Controller.KnowledgeArticleData> tmpResults = pkb_Controller.initFromListOfArticleNumbers(new List<String>(anums), getRequestedLanguage(req));
        return processForMobile(tmpResults,0);

    }

    /**
    * @description
    * @param pkb_mobile_proxy.RequestItem - req
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    public static pkb_mobile_proxy.ResponseItem searchString(pkb_mobile_proxy.RequestItem req){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try {
            pkb_Controller p = setUp();
            //
            p.theArticle = new KnowledgeArticle();
            resp.articles = getArticlesByFilter(p,req);
        }catch(System.SearchException sx){
            //Indicate that an SearchException error has occurred
            resp.isSuccess = false;
            resp.message    = System.Label.PKB2_Search_Invalid_Characters;//sx.getMessage();
        }
        catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage();
        }

        return resp;
    }

    /**
    * @description
    *   performs a SOSL search usign the keywords in the request
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    private static list<pkb_mobile_proxy.mobileKnowledgeArticleData> getArticlesByFilter(pkb_Controller p,  pkb_mobile_proxy.RequestItem req){

        list<list<sObject>> results = new list<list<sObject>>();
        list<pkb_mobile_proxy.mobileKnowledgeArticleData> res;
        //build WITH DATA CATEGORY filter lines
        String escapedDC = req.dataCategories;
        if (String.isNotBlank(escapedDC))
            escapedDC = String.escapeSingleQuotes(req.dataCategories);
        String qDC = dataCategoryFilter(escapedDC,p);
        String escapedQ = req.searchCriteria;
        if (String.isNotBlank(escapedQ))
            escapedQ = String.escapeSingleQuotes(req.searchCriteria);
        String escapedLang  = getRequestedLanguage(req);

        String soslQuery =  ' FIND \''+escapedQ +'*\' IN ALL FIELDS RETURNING '+
                             + 'KnowledgeArticleVersion ( '+
                            ' Id, KnowledgeArticleId '+
                            ' WHERE PublishStatus=\''+pkb_Controller.DEFAULT_PUBLISH_STATUS+'\' AND language =\'' +escapedLang+'\' '+
                             ') '+ qDC +
                            '  limit '+ MAX_ARTICLES +
                            ' UPDATE TRACKING';

        results = search.query(soslQuery);
        list<String> kList = new list<String>();
        for ( sObject q : results[0] ){
            kList.add(String.valueOf(q.get('KnowledgeArticleId')));
        }

        list<pkb_Controller.KnowledgeArticleData> tmpResults = pkb_Controller.initFromListOfArticleIds(kList, escapedLang);
        return processForMobile(tmpResults,0);

    }

    /**
    * @description
    *   returns details of the app caonfiguration
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    public static pkb_mobile_proxy.ResponseItem getCurrentSiteSetUp(){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try {

            pkb_Controller pc = setUp();
            PKB__c current =  getCurrentSiteSetting (pc);
            resp.setup = new map<String,String>();

            if (current!= null){
                resp.setup.put('Contact_Us_Available',String.valueOf(current.Contact_Us_Available__c));
            }else{
                resp.setup.put('Contact_Us_Available',String.valueOf(false));
            }

            String tmpStr = '';
            List<SelectOption> cT = pc.caseTypeOptions;
            for(SelectOption o : cT){
                tmpStr = tmpStr + ';'+o.getValue()+':'+o.getLabel();
            }
            resp.setup.put('caseType', tmpStr);
            //emoIcon options
            tmpStr = '';
            List<Schema.PicklistEntry>pl = Case.Customer_emoticon_value__c.getDescribe().getPickListValues();
            for(Schema.PicklistEntry p : pl){
                tmpStr = tmpStr + ';'+p.getLabel();
            }
            resp.setup.put('caseEmoIcons', tmpStr);
            //sessionCookieName
            resp.setup.put('sessionCookieName', 'apex__'+pkb_mobile_proxy.COOKIE_SESSION_NAME);
            //contactDetailsCookieName

            resp.setup.put('contactDetailsCookieName', 'apex__'+pkb_mobile_proxy.COOKIE_CONTACT_NAME);
            //LIVE AGENT SUPPORT SET UP
            resp.setup.put('LA_Enabled', String.valueOf(current.LiveAgent_ChatEnabled__c));//'true');
            if (String.isNotBlank(current.LiveAgent_DeploymentId__c) && String.isNotBlank(current.LiveAgent_ChatButtonId__c) &&
                String.isNotBlank(current.LiveAgent_ChatServerURL__c) && String.isNotBlank(current.LiveAgent_DeploymentURL__c) ){

                resp.setup.put('LA_deploymentId', String.valueOf(current.LiveAgent_DeploymentId__c));
                resp.setup.put('LA_chatButtonId', String.valueOf(current.LiveAgent_ChatButtonId__c));
                resp.setup.put('organizationId', UserInfo.getOrganizationId().substring(0,15));
                //setup urls
                resp.setup.put('LA_deploymentScriptURL', String.valueOf(current.LiveAgent_DeploymentURL__c));
                resp.setup.put('LA_chatServerURL', String.valueOf(current.LiveAgent_ChatServerURL__c));

            }else{
                resp.setup.put('LA_Enabled', 'false');
            }
            //CTI details
            if (current.Add_Case_Id__c && String.isNotBlank(current.CTI_configuration__c)){
                resp.setup.put('CTIDetails',current.CTI_configuration__c);
            }else{
                resp.setup.put('CTIDetails','');
            }

            //BUSINESS HOUR AND CALL FEATURE
            //First part, just let front end know if business hour should be taken into account

            list<Businesshours> elms = new list<Businesshours>();
            if ( current.MBusinessHours__c != null ) elms = [Select Id,Name from Businesshours where Name = :current.MBusinessHours__c limit 1];
            if ( current.MEnableCall__c == true && current.MPhoneNumber__c != null ){

                 Boolean isCallEnabled =  pkb_mobile_controller.isPhoneCallAvailable( system.now(),  current.MBusinessHours__c);
                if (isCallEnabled){
                    resp.setup.put('supportCallEnabled',String.valueOf(true));
                    resp.setup.put('phoneNumber',String.valueOf(current.MPhoneNumber__c));
                    if ( elms.size() < 1 )  resp.setup.put('businessHours','24/7');
                    else resp.setup.put('businessHours',String.valueOf(elms[0].Name));
                }else{
                    resp.setup.put('supportCallEnabled',String.valueOf(false));
                    resp.setup.put('phoneNumber','');
                    resp.setup.put('businessHours','');
                }
            }else{
                resp.setup.put('supportCallEnabled',String.valueOf(false));
                resp.setup.put('phoneNumber','');
                resp.setup.put('businessHours','');
            }

            //files to Upload
            if (current.Maximum_Attachment_Upload_Per_Case__c != null &&  current.Maximum_Attachment_Upload_Per_Case__c >0 ){
                resp.setup.put('maxAllowedFilesToUpload',String.valueOf(current.Maximum_Attachment_Upload_Per_Case__c));
            }else{
                resp.setup.put('maxAllowedFilesToUpload',MAX_ALLOWED_FILES_TO_UPLOAD);

            }
            //multi-language
            resp.setup.put('multiLanguageEnabled',String.valueOf( current.Multi_Language_Enabled__c ) );

            //maxResults for ContactUs flow
            resp.setup.put('contactUsMaxResults',String.valueOf( current.MCResults_Page_Size__c ) );
            //
            resp.setup.put('relatedArticleMaxResults',String.valueOf( current.Related_Articles_Size__c ) );


        } catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n=========\n'+ ex.getStackTraceString();
        }

        return resp;

    }

    /*******************************************************************
        methods to handle filter options
    ********************************************************************/
    /**
    * @description
    *   returns list of available languages
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    public static pkb_mobile_proxy.ResponseItem getLanguages(){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try {
            pkb_Controller pc = setUp();
            PKB__c current =  getCurrentSiteSetting (pc);
            resp.filterDC = getGroupToRoot (current);
            resp.lang = getLang (current);

        } catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n=========\n'+ ex.getStackTraceString();
        }

        return resp;
    }

    public static List<String> getLanguagesList(){

        list<String> res = new list<String>();

        pkb_Controller pc = setUp();
        if (pc.multiLanguage){
            PKB__c current =  getCurrentSiteSetting (pc);
            res = getLang (current);
        }else{
            res.add(pkb_SettingsController.DEFAULT_LANGUAGE);
        }

        return res;
    }


    private static List<String> getLang (PKB__c current){

        list<String> res = new list<String>();
        if ( String.isNotBlank(current.Selected_Languages__c))
            res = current.Selected_Languages__c.split(';');
        return res;
    }

    private static String getRequestedLanguage (pkb_mobile_proxy.RequestItem req){

        String language = pkb_mobile_proxy.DEFAULT_LANGUAGE;

        List<String> validLanguages = getLanguagesList();
        set<String> setOfLang = new set<String>();
        setOfLang.addAll(validLanguages);
        list<String> res = new list<String>();
        if ( String.isNotBlank(req.lang)){
            String escapedLang = String.escapeSingleQuotes(req.lang);
            if ( setOfLang.contains(escapedLang)) {
                language = escapedLang;
            }
        }
        return language;
    }

    /*******************************************************************
        CONTACT US  methods
    ********************************************************************/
    /**
    * @description
    *   validates new fields : geolocation, emoIcon
    *   delegates Case creation on pkb controller
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    public static pkb_mobile_proxy.ResponseItem processContactUs(pkb_mobile_proxy.RequestItem req){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();


        /* validate geolocalization data */
        Decimal user_lat = null;
        Decimal user_long = null;
        try{

            if (req.contactData.containsKey('latitude') != null && req.contactData.containsKey('longitude') != null){
                String tmpLatitude  = req.contactData.get('latitude') ;
                String tmpLongitude = req.contactData.get('longitude') ;
                if (String.isNotBlank(tmpLatitude) && String.isNotBlank(tmpLongitude)){
                    user_lat = Decimal.valueof(req.contactData.get('latitude'));
                    user_long = Decimal.valueof(req.contactData.get('longitude'));
                }
            }

        }catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = 'Error in the Geolocalization';
            return resp;
        }

        try {

            pkb_Controller p = setUp();
            PKB__c  pkbSetting  = getCurrentSiteSetting (p);
            //check create permissions
            pkb_SecurityHandler.canCreate(
                        new Schema.SObjectType[] {Case.sObjectType});

            if (pkbSetting.Create_Contact_and_Account__c){
            //check create permissions over Account and Contact
            pkb_SecurityHandler.canCreate(
                        new Schema.SObjectType[] {Account.sObjectType,Contact.sObjectType});
            }

            pkb_Controller.ContactUsData auxCD = new pkb_Controller.ContactUsData();

            if (    req.contactData.containsKey('firstName') &&
                    req.contactData.containsKey('lastName') &&
                    req.contactData.containsKey('email') &&
                    req.contactData.containsKey('reqType') &&
                    req.contactData.containsKey('questionBody')){

                auxCD.firstName = req.contactData.get('firstName');//
                auxCD.lastName = req.contactData.get('lastName');
                auxCD.email = req.contactData.get('email');
                auxCD.reqType = req.contactData.get('reqType');//'Other';

                String sanitized= req.contactData.get('questionBody');
                sanitized = EncodingUtil.urlDecode(sanitized, 'UTF-8');
                sanitized = sanitized.replaceAll('\n\r','\n').replaceAll('\r\n','\n');
                auxCD.query = sanitized;
                p.urlSearchQuery = sanitized;
                p.sessionId = String.escapeSingleQuotes(req.sessionId);

                //update emoIcon
                if (req.contactData.containsKey('emoIcon')){
                    String emoIcon = req.contactData.get('emoIcon');

                    Map<String,String> validEntries = pkb_controller.getActivePicklistOptions('Case','Customer_emoticon_value__c');

                    if ( String.isNotBlank(emoIcon ) && validEntries.containsKey(emoIcon)){
                        auxCD.User_Experience = emoIcon;
                    }
                }
                //update geolocation
                if (user_lat != null && user_long != null){
                    auxCD.location_Latitude = user_lat;
                    auxCD.location_Longitude = user_long;
                }

                p.theCud = auxCD;
                p.createCase();

                if (p.theCase != null  &&  ! String.isNotBlank(p.createCaseErrorMsg )){
                	resp.contactDetails = new map<string,string>();

                    resp.caseId = p.theCase.Id;
                    List<Case> caseDetails = [select Id, casenumber  from Case where id=:p.theCase.Id limit 1];
                    if (!caseDetails.isEmpty()){
                        Case tc = caseDetails[0];
                        resp.caseNumber = tc.caseNumber;
    					resp.contactDetails.put('CaseNumber',resp.caseNumber);
						resp.contactDetails.put('CaseId',resp.caseId);
                    }

                    if (p.theCase.ContactId != null){
                        List<Contact> lc = [select Id, Name, Email from Contact where id=:p.theCase.ContactId limit 1];
                        if (!lc.isEmpty()){
                            Contact c = lc[0];

                            resp.contactDetails.put('Id',c.Id);
                            resp.contactDetails.put('Email',c.Email);
                            resp.contactDetails.put('Name',c.Name);

                        }
                    }

                }else{
                    resp.isSuccess = false;
                    resp.message    = p.createCaseErrorMsg;
                }

            }else{
                    resp.isSuccess = false;
                    resp.message    = Label.PKB2_All_Fields_Required;
                }

        }catch(pkb_SecurityHandler.SecurityException sEx){
             //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message = sEx.getMessage() ;
        } catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n'+ ex.getStackTraceString();
        }

        return resp;
    }
    /**
    * @description
    *   returns list of article fields to be displayed in the article Detail page,
    *   the original list contains the fields specifiend in the custom setting
    *   the result list is that list with the inaccessible fields removed
    * @param String - fieldList
    * @param Map<String, SObjectField> - mapFields
    * @return String
    **/
    public static String filterArticleByFLS(String fieldList,Map<String, SObjectField> mapFields ){
	String finalText = fieldList;
	SObjectField k = null;
	for (String f : fieldList.split(',')){
			if (f.trim() != 'ArticleType' ){
				k = mapFields.get(f.trim());
				if (!pkb_securityHandler.isAccessible(k)){
					finalText = finalText.replace(','+k,'');

				}
			}
		}
		return finalText;
    }

    /**
    * @description
    *   returns article details according to custom setting fields,
    *   if no values where specifieds it will return title, lastmodifieddate, articlenumber and summary
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    public static pkb_mobile_proxy.ResponseItem getArticleDetail(pkb_mobile_proxy.RequestItem req){

        Map<String,Boolean> checkACCESS = pkb_securityHandler.getKAVPermissions();


        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try {
            String escapedLang  = getRequestedLanguage(req);
            String defaultPublishStatus = pkb_Controller.DEFAULT_PUBLISH_STATUS;
            String sq = String.escapeSingleQuotes(req.searchCriteria);
            String sqlQ;
            if (sq.length() == 18){
            	sqlQ = ' SELECT Id,KnowledgeArticleId FROM KnowledgeArticleVersion '+
                ' WHERE KnowledgeArticleId = :sq ' +
                ' AND PublishStatus = : defaultPublishStatus  AND Language = :escapedLang '+
                '  order by VersionNumber desc '+
                ' limit 1 UPDATE VIEWSTAT';
            }else{
            	sqlQ = ' SELECT Id,KnowledgeArticleId FROM KnowledgeArticleVersion '+
                ' WHERE UrlName = :sq ' +
                ' AND PublishStatus = : defaultPublishStatus  AND Language = :escapedLang '+
                '  order by lastPublishedDate desc '+
                ' limit 1 UPDATE VIEWSTAT';
            }
             KnowledgeArticleVersion kA  =  Database.query(sqlQ);

            Id kavID = kA.Id;
            Schema.SObjectType token = kavID.getSObjectType();

            pkb_securityHandler.canAccess(new Schema.SObjectType[] {token });


            Schema.DescribeSObjectResult dr = token.getDescribe();
            Map<String, SObjectField> mapFields =token.getDescribe().fields.getMap();

            pkb_Controller p = setUp();
            p.selectedLanguage  = getRequestedLanguage(req);
            String artFields = '';
			String fieldsOrder='';
            set<String> fieldSet = new set<String>();

            PKB__c  pkbSetting  = getCurrentSiteSetting (p);
            if (pkbSetting != null){
                artFields = pkb_Mobile_CustomSettingModel.getArticleTypeLayout( pkbSetting.Id, dr.getName());
                fieldsOrder = artFields;
				if (artFields.length() > 0)
                    fieldSet.addAll(artFields.tolowerCase().split(','));
            }

            if (!fieldSet.contains('title'))			artFields += ',title';
			if (!fieldSet.contains('lastmodifieddate'))	artFields += ',lastmodifieddate';
			if (!fieldSet.contains('articlenumber'))	artFields += ',articlenumber';
			if (!fieldSet.contains('summary'))			artFields += ',summary';
			if (!fieldSet.contains('knowledgearticleid'))	artFields += ',knowledgearticleid';

			if (artFields.startsWith(',')) artFields = artFields.substring(1);
			//artFields = artFields;
            String sql = '  Select  '+ artFields+
                        '   from '+dr.getName()+
                        '   WHERE Id = \''+kavID+'\'  '+
                        '   limit 1';

            list<Object> soqlResults = Database.query(sql);

            sObject article = (sObject)soqlResults[0];
            String responseBody='';

            Map<String,String> fieldValues = new Map<String,String>();
            String value='';
            String keyVal='';
            String richTextFields='';
            Schema.DescribeFieldResult fDescribe = null;
            Set<String> skipFields = new Set<String>{'title','lastmodifieddate','articlenumber', 'summary','knowledgearticleid'};
            String flsCheckedList = filterArticleByFLS(artFields,mapFields);
            for(String f : flsCheckedList.split(',')){
                keyVal = f.trim() ;

                if (! skipFields.contains(keyVal.toLowerCase())){
                if (mapFields.containsKey(keyVal) ){
                	fDescribe = mapFields.get(keyVal).getDescribe();
                    keyVal= fDescribe.getLabel() ;
                    if (fDescribe.getType() == Schema.DisplayType.TEXTAREA && fDescribe.isHtmlFormatted()) {
                    	richTextFields += ','+keyVal;
                    }
                }
                if ( article.get(f.trim()) != null){
                    responseBody +='<br/>'+f+' : <br/>'+String.valueOf(article.get(f.trim()));
                    value = String.valueOf(article.get(f.trim()));

                }else {
                    responseBody +='<br/>'+f+' : EMPTY';
                    value='n/a';
                }
                fieldValues.put(keyVal , value);
                fieldsOrder = fieldsOrder.replace(f,keyVal);
				}
            }
			fieldValues.put('fieldOrder',fieldsOrder);
			fieldValues.put('richTextFields',richTextFields);

            String id = String.valueOf(article.get('id'));
            pkb_mobile_proxy.ArticleDetail art = new pkb_mobile_proxy.ArticleDetail();

            art.fieldValues = fieldValues;

            art.id = String.valueOf(article.get('KnowledgeArticleId'));//id;
            art.title = String.valueOf(article.get('title'));
            //
            art.articleTypeName = pkb_controller.getKAVDescribeById(id).getLocalName();
            art.articleTypeLabel = pkb_controller.getKAVDescribeById(id).getLabel();
            art.articleNumber =  String.valueOf(article.get('ArticleNumber'));
            art.summary =  String.valueOf(article.get('Summary'));
            if (Test.isRunningTest()){
                art.elapsed =  parseElapsedTime (Datetime.now());
            }else{
                art.elapsed =  parseElapsedTime (Datetime.valueOf(article.get('LastModifiedDate')));
            }

            //check for already sent feedback
            List<PKB_Article_Feedback_Deflection__c> afds = [
                        select Id
                        from PKB_Article_Feedback_Deflection__c
                        where
                            Session_ID__c = : String.escapeSingleQuotes(req.sessionId) and
                            Article_Number__c = :art.articleNumber
                        ];
            art.feedbackGiven  = !afds.isEmpty();
            //viewStat & usefulness
            Id ka_ID = String.valueOf(article.get('KnowledgeArticleId'));
            Map<Id, Integer> viewStats = calculateViewStats(new set<Id>{ka_ID});
            Map<Id, Integer> useStats = calculateUsefulnesStats(new set<Id>{ka_ID});
            art.viewStat =viewStats.get(ka_ID);
            art.usefulStat =useStats.get(ka_ID);
            resp.articleData = art;

        }catch(pkb_SecurityHandler.SecurityException sEx){
             //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message = sEx.getMessage() ;

        } catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n'+ ex.getStackTraceString();
        }
        return resp;
    }

    /*******************************************************************
        Article Feedback
    ********************************************************************/
    /**
    * @description
    *   stores article feedback information
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    public static pkb_mobile_proxy.ResponseItem submitFeedBack(pkb_mobile_proxy.RequestItem req){

        pkb_mobile_proxy.ResponseItem resp = new pkb_mobile_proxy.ResponseItem();
        try{

            //check create permissions
            //pkb_SecurityHandler.canCreate(
            //          new Schema.SObjectType[] {PKB_Article_Feedback_Deflection__c.sObjectType});

            pkb_mobile_proxy.FeedBackDetails details =  req.articleFeedback;
            if (    String.isNotBlank(details.articleNumber) &&
                    String.isNotBlank(details.source)  &&
                    String.isNotBlank(details.title) &&
                    String.isNotBlank(details.kavId)
             ){
                //validate source
                if (details.source =='s')
                    details.source ='Search';
                if (details.source =='r')
                    details.source ='RelatedArticle';
                if (details.source =='c')
                    details.source ='ContactUs';

                Set<String> feedbackSourceOptions = pkb_controller.getActivePicklistOptions('PKB_Article_Feedback_Deflection__c', 'Feedback_Source__c').keySet();

                String fs = (feedbackSourceOptions.contains(details.source) ? details.source : null);

                PKB_Article_Feedback_Deflection__c afd = new PKB_Article_Feedback_Deflection__c(
                    Article_ID__c = details.kavId,
                    Article_Number__c = details.articleNumber,
                    Article_Title__c = details.title,
                    Feedback_Source__c = fs,
                    Comments__c = details.feedbackComments,
                    Session_ID__c = String.escapeSingleQuotes(req.sessionId),
                    Deflection__c = details.isDeferred,
                    Keyword_Searched__c = details.searchString,
                    Channel__c = 'mobile'
                );
                insert afd;

            }else{
                resp.isSuccess = false;
                resp.message    = 'Error processing feedback details';
                return resp;
            }
        }catch(pkb_SecurityHandler.SecurityException sEx){
             //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message = sEx.getMessage() ;

        } catch (Exception ex) {
            //Indicate that an error has occurred
            resp.isSuccess = false;
            resp.message    = ex.getMessage()+'\n'+ ex.getStackTraceString();
        }

        return resp;
    }



    /**
    * @description
    *       Languages Map (to get label -> value)
    * @param pkb_mobile_proxy.RequestItem - req
    * @param pkb_Controller - p
    * @return list<pkb_mobile_proxy.mobileKnowledgeArticleData>
    **/
    public static Map<String,String> getLangMap(){
        return pkb_Controller.getActivePicklistOptions('User', 'LanguageLocaleKey');
    }


/* editied starts */

     public static Boolean isPhoneCallAvailable(Datetime d, String businessHour){

        system.debug('\n\n==== isPhoneCallAvailable WILL TEST at : '+ d);

        Boolean result = false;
        //If no value, requirements defines a 24/7 service
        if ((!String.isNotBlank(businessHour)) || businessHour == '24/7'){
           result = true;

        }else{
            //Let's try to get businessHour record, if wrong, define NO SERVICE
            list<BusinessHours> l = [ Select Id
                                        from  BusinessHours b
                                        where b.isActive = true
                                        and   b.Name = :businessHour
                                        limit 1 ];


            if ( l.size() > 0 ){
                DateTime nextTime = businesshours.addGmt(l[0].id, d, 1);
                system.debug('\n\n==== isPhoneCallAvailable  nextTime : '+ nextTime);

                //If all values in GMT & using day/hour/minute as key equals system.now GMT day/hour/minute
                //it means service is active (it also covers Holiday Days)
                if ( nextTime.dayGmt()    == d.dayGmt() &&
                     nextTime.hourGmt()   == d.hourGmt() &&
                     nextTime.minuteGmt() == d.minuteGmt() ){

                     result = true;
                }

                Boolean isWithin= BusinessHours.isWithin(l[0].id, d);
                system.debug('\n\n====isPhoneCallAvailable  isWithin : '+ isWithin);

            }
        }
        return result;
    }


    //Bussines hours / call available
    public static Object getPhoneCallAvailable(DateTime d){
        map<String,String> ret = new map<String,String>();

        pkb_mobile_proxy.ResponseItem r = pkb_mobile_controller.getCurrentSiteSetUp();
        String businessHour = r.setup.get('businessHours');
        if ( Test.isRunningTest() ) businessHour = pkb_mobile_Test.getTestBusinessHourName();

        Boolean isCallEnabled =  pkb_mobile_controller.isPhoneCallAvailable( d,  businessHour);

        if (isCallEnabled){
             if ( r.setup.get('phoneNumber') != null ){
                ret.put('available',String.valueOf(true));
                ret.put('number',r.setup.get('phoneNumber'));
            }else{
                ret.put('available',String.valueOf(false));
            }
        }else{
            ret.put('available',String.valueOf(false));
        }
        return ret;
    }

/* edited ends */


    public static String getNamespace() {
        String tmp = '';

        String fullName = Schema.SObjectType.PKB_Article_Feedback_Deflection__c.fields.channel__c.getName();
        String[] pageNameParts = fullName.replaceAll('__c','').split('__');
        tmp =  (pageNameParts.size() > 1) ? pageNameParts[0]+'__' : '';

        return tmp;
    }

}