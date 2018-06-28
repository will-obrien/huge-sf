public with sharing class pkb_SiteMap {
	/**
	* @description this list declares all ArticleTypes in the org
	**/
	public list<String> availableArticleTypes { get; private set;}
	/**
	* @description this list declares all available languages
	**/
	public list<String> availableLanguages { get; private set;}

	public static Integer MAX_ARTICLES = 50;
	public static String DEFAULT_PUBLISH_STATUS = 'online';

	public String lang {get; set;}
	public Integer offset {get; set;}

	public pkb_SiteMap() {

		init();
		//populate offset for queries
		this.offset = 0;
		String tmpOffset = ApexPages.currentPage().getParameters().get('offset');
		if (String.isNotBlank(tmpOffset) && tmpOffset.isNumeric()){
			tmpOffset = String.escapeSingleQuotes(tmpOffset);
			this.offset = Integer.valueOf(tmpOffset);
		}
		//populate language option
		this.lang = String.valueOf(ApexPages.currentPage().getParameters().get('lang'));
		if ( String.isNotBlank(this.lang)){
			this.lang  = String.escapeSingleQuotes(this.lang );
		}else{
			this.lang = availableLanguages.get(0);
		}
	}

	/**
	* @description populates available articles and languages
	* using the schema of the KnowledgeArticleVersion object
	**/
	private void init(){

		availableArticleTypes = new List<String>();
		for (Schema.PicklistEntry a : KnowledgeArticleVersion.ArticleType.getDescribe().getPickListValues()){
			availableArticleTypes.add( a.getValue());
		}

		availableLanguages = new List<String>();
		for (Schema.PicklistEntry a : KnowledgeArticleVersion.Language.getDescribe().getPickListValues()){
			availableLanguages.add( a.getValue());
		}

	}

	// A property to return the proper Sites URL, used to build our full URL later
	public string siteUrl{
		get{
			String surl = site.getcustomwebaddress();
			if ( !String.isNotBlank(surl) ) {
				surl = site.getcurrentsiteurl();
				String pref = site.getPrefix();
				if (pref != null && String.isNotBlank(pref) )
					surl = surl.removeEndIgnoreCase(site.getPrefix()+'/');
				else
					surl = surl.removeEndIgnoreCase('/');
			}
			return surl;//.substring(0, (surl.length()-1));
		}
		set;
	}

	public  list<KAWrapper> getDocumentationList(){

		list< KAWrapper> results = new list<KAWrapper>();

		Integer offs =  this.offset;
		String qry =	' SELECT  id, knowledgearticleid, lastpublisheddate , title , UrlName , LastModifiedDate '+
					'   FROM KnowledgeArticleVersion'+
					'   WHERE '+
					'   (PublishStatus = \''+DEFAULT_PUBLISH_STATUS+'\' AND IsVisibleInPkb = true AND Language=\''+this.lang+'\' ) '+
					'   ORDER BY LastPublishedDate DESC '+
					'   LIMIT: MAX_ARTICLES  '+
					'   OFFSET : offs';

		for( sObject iK : database.query(qry)){
			results.add( new KAWrapper( iK));
		}
		return results;
	}


	public list<SMWrapper> getSiteMapsList(){

		list< SMWrapper> results = new list<SMWrapper>();
		list< SMWrapper> tmp;
		for( String l : availableLanguages){
			tmp =getSiteMapsList(l);
			if (!tmp.isEmpty())
				results.addAll( tmp);
		}
		return results;
	}

	/**
	* @description returns list of
	**/
	public list<SMWrapper> getSiteMapsList(String lang){

		list< SMWrapper> results = new list<SMWrapper>();
		String q = ' SELECT  count() ' +
						' FROM KnowledgeArticleVersion ' +
						' WHERE ' +
						' (PublishStatus = \''+DEFAULT_PUBLISH_STATUS+'\' AND IsVisibleInPkb = true AND Language=\''+ lang+'\' )  ' +
						' LIMIT '+ Limits.getLimitQueryRows();
		Integer max  =  Database.countQuery(q);
		Long l = Math.mod( max,MAX_ARTICLES);
		Double numPages = Math.floor(max/MAX_ARTICLES);
		if (  l>0){
			numPages = numPages+ 1;
		}

		for( Integer i=0 ; i< numPages ; i++){
			results.add( new SMWrapper( lang, (i* MAX_ARTICLES ) ));
		}
		return results;
	}

	public with sharing  class KAWrapper {
		public Id id					{ get; set; } // note this is the ID of the KnowledgeArticle record, not the ID of the KAV record
		public Id knowledgearticleid	{ get; set; }
		public String lastpublisheddate	 { get; set; }
		public String aType				 { get; set; }
		public String UrlName				   { get; set; }


		public KAWrapper(sObject ka) {
			this.knowledgearticleid	 = String.valueOf(ka.get('id')); //CHANGE THIS
			Datetime aux;
			if (!Test.isRunningTest()){
				aux = Datetime.valueOf(ka.get('LastModifiedDate'));
			}else{
				aux = Datetime.now();
			}

			this.lastpublisheddate	  = aux.format('yyyy-MM-dd');

			Schema.SObjectType token = this.knowledgearticleid.getSObjectType();
			// Using the token, do a describe
			// and construct a query dynamically.
			Schema.DescribeSObjectResult dr = token.getDescribe();
			this.aType  = dr.getName().replace('__kav','');

			this.UrlName = String.valueOf(ka.get('UrlName'));
		}
	}

	public with sharing  class SMWrapper {
		public Integer offset	   { get; set; }
		public String lastModDate   { get; set; }
		public String lang			  { get; set; }

		public SMWrapper(String l , Integer o) {
			this.offset = o;
			Datetime aux = Datetime.now();
			this.lastModDate	= aux.format('yyyy-MM-dd');
			this.lang = l;
		}
	}

}