public with sharing class pkb_SettingsController {

  /* ***** DEFAULT SETTINGS TO BE USED ELSEWHERE IN APP WHEN CUSTOM SETTINGS FOR CURRENT SITE CANNOT BE FOUND ***** */
  public final static Boolean DEFAULT_DISPLAY_SUMMARY = true;
  public final static Boolean DEFAULT_ACTIVATE_CONTACT_US = true;
  public final static Integer DEFAULT_RESULTS_SIZE = 10;
  public final static Integer DEFAULT_POPULAR_SIZE = 3;
  public final static Integer DEFAULT_RELATED_SIZE = 3;
  public final static Boolean DEFAULT_MULTI_LANGUAGE = false;
  public final static Boolean DEFAULT_CREATE_ACCOUNT_CONTACT = false;
  public final static String DEFAULT_LANGUAGE = 'en_US';

  /* ***** URL PARAM CONSTANTS AND GETTERS ***** */
  private final static String CREATE_SETTINGS_PARAM = 'createSettings';
  private final static String CREATE_SETTINGS_VALUE = '1';
  public String createSettingsParam { get { return CREATE_SETTINGS_PARAM; } }
  public String createSettingsValue { get { return CREATE_SETTINGS_VALUE; } }

  /* ***** STANDARD CONSTRUCTOR (not currently used) ***** */
  public pkb_SettingsController() { }

  /* ***** CONSTRUCTOR FOR USE AS VF CONTROLLER EXTENSION ***** */
  public pkb_SettingsController(ApexPages.StandardController sc) {
    theSC = sc;
    theSettings = (PKB__c)theSC.getRecord();
    selectedSettings = theSC.getRecord().Id;

    // if creating new settings, set the defaults for the article size fields
    if (theSettings.Id == null) {
    	theSettings.Popular_Articles_Size__c = DEFAULT_POPULAR_SIZE;
    	theSettings.Related_Articles_Size__c = DEFAULT_RELATED_SIZE;
    	theSettings.Results_Page_Size__c = DEFAULT_RESULTS_SIZE;
    	theSettings.MResults_Page_Size__c = DEFAULT_RESULTS_SIZE;
    	theSettings.Contact_Us_Available__c = DEFAULT_ACTIVATE_CONTACT_US;
    }

    if (!isBlank(theSettings.Selected_Languages__c)) selectedLanguages = theSettings.Selected_Languages__c.split(';');
  }

  /* ***** STANDARD CONTROLLER AND RECORD PROPS ***** */
  public ApexPages.StandardController theSC  { get; set; }
  public PKB__c theSettings                  { get; set; }


  /* Knowledge Articles Custom Settings Management */
  public String kaTypes {get;set;}
  public void dummySet(){}

  /* ***** GENERAL DISPLAY AND PROCESSING CONDITIONALS ***** */

  public Boolean settingsPicked { get { return selectedSettings != null; } }
  public Boolean settingsExist { get { return !settingsMap.isEmpty(); } }

  // whenever the CREATE_SETTINGS_PARAM has any value, that indicates that the new settings form should be displayed
  public Boolean creatingSettings {
    set;
    get {
      if (creatingSettings == null)  {
        creatingSettings = !isBlank(ApexPages.currentPage().getParameters().get(CREATE_SETTINGS_PARAM));
      }
      return creatingSettings;
    }
  }



  /* ***** PROPS AND METHODS FOR SETTINGS CREATION AND EDITING PROCESSING ***** */

  // stores the selection from the settings options picklist on the page, valid values are values of the Name field for any PKB__c settings collection
  public String selectedSettings { get; set; }

  public PageReference saveSettings() {
	if (getMatchingSite(theSettings.Name) == null) {
      theSettings.Name.addError('The Site Name you entered does not match the name of any existing Site.');
    	return null;
    }
    //validate CTI integration keywords
    if (theSettings.Add_Case_Id__c && String.isNotBlank(theSettings.CTI_configuration__c)){
		String emailRegex = '(((\\[)(P|W|CN)(\\]))|[a-zA-Z]|[0-9])*';
		Pattern MyPattern = Pattern.compile(emailRegex);
		Matcher MyMatcher = MyPattern.matcher(theSettings.CTI_configuration__c);
		if (!MyMatcher.matches()) {
		// invalid, do something
			theSettings.CTI_configuration__c = '';
			theSettings.Add_Case_Id__c = false;
		}
	}else{
		theSettings.CTI_configuration__c = '';
	}

    theSettings.Selected_Languages__c = pkb_Controller.join(selectedLanguages, ';');
    theSC.save();
    PageReference p = Page.pkb_Settings;
    p.getParameters().put('id', theSC.getRecord().Id);
    p.setRedirect(true);

    try{
    	this.saveKaElements();
    }catch(Exception e){
    	theSettings.Name.addError(e.getMessage());
    }
    return p;
  }

  /* Altimetrik Team, method added to save KA Elements (custom setting) */
  private void saveKaElements(){
  	if (  !String.isNotBlank(this.kaTypes) ) return;
  	//check create permissions
	pkb_SecurityHandler.canCreate(new Schema.SObjectType[] {pkb_ka__c.sObjectType});
	//check delete permissions
	pkb_SecurityHandler.canDelete( new Schema.SObjectType[] {pkb_ka__c.sObjectType} );
  	Integer maxRows = Limits.getLimitDmlRows() - Limits.getDmlRows();
  	map<Id,pkb_ka__c> currentElementsInDb = new map<Id,pkb_ka__c>([Select Id,Name,apiName__c,layout__c,pkb__c
  																	From pkb_ka__c
  																	Where pkb__c = :this.theSettings.Id limit :maxRows]);

  	list<Object> listOfKas = (list<Object>) JSON.deserializeUntyped(this.kaTypes);

  	if ( listOfKas.size() > 0 ){
  		list<pkb_ka__c> elementsToSave = new list<pkb_ka__c>();
  		list<pkb__c> parentId = [Select Id from pkb__c where Name = :this.theSettings.Name limit 1];

  		for ( Object obj : listOfKas ){
  			map<String,Object> element = (map<String,Object>) obj;
  			if ( element.get('Id') == null ){
  				//new KA
  				pkb_ka__c n 	= new pkb_ka__c();
  				n.Name 			= String.valueOf(Datetime.now().getTime())+'-'+String.valueOf( Integer.valueOf(Math.random()*10000) );
  				n.apiName__c 	= String.valueOf( element.get('apiName__c') );
  				n.layout__c		= String.valueOf( element.get('layout__c') );
  				n.pkb__c		= parentId[0].Id;
  				elementsToSave.add(n);
  			}else{
  				pkb_ka__c n 	= currentElementsInDb.get( String.valueOf( element.get('Id') ) );
  				if ( n != null ){
  					n.apiName__c 	= String.valueOf( element.get('apiName__c') );
  					n.layout__c		= String.valueOf( element.get('layout__c') );
  					elementsToSave.add(n);
  					//Remove it from map cuz map values will be deleted at the end of algorithm
  					currentElementsInDb.remove( String.valueOf( element.get('Id')) );
  				}
  			}
  		}
  		if ( elementsToSave.size() > 0 ) upsert elementsToSave;
  	}
  	if ( currentElementsInDb.values().size() > 0 ) delete currentElementsInDb.values();
  }

  // map of all settings collections of type PKB__c, note that the key of this map is the value of the Name field for that collection
  private Map<String,PKB__c> settingsMap {
    get {
      if (settingsMap == null) settingsMap = PKB__c.getAll();
      return settingsMap;
    }
    private set;
  }

  // produces set of picklist options from the settingsMap, uses Id as value and Name as label
  public List<SelectOption> settingsOptions {
    get {
      settingsOptions = new List<SelectOption>();
      settingsOptions.add(new SelectOption('', '---None---'));
      for (String s : settingsMap.keySet()) {
        settingsOptions.add(new SelectOption(settingsMap.get(s).Id, s));
      }
      return settingsOptions;
    }
    private set;
  }

  public List<String> selectedLanguages { get; set; }
  public String selectedLanguageStr { get; set; }
  public Integer allLanguageOptionsSize { get { return allLanguageOptions.size(); } }

  public List<SelectOption> allLanguageOptions {
    get {
      if (allLanguageOptions == null) {
          allLanguageOptions = new List<SelectOption>();
          Map<String,String> optionsMap = pkb_Controller.getActivePicklistOptions('User', 'LanguageLocaleKey');
          String label;
          for (SelectOption so : pkb_Controller.allLanguageOptions) {
                  if (optionsMap.containsKey(so.getValue()))
                    label = optionsMap.get(so.getValue());
                  else
                    label = so.getLabel();

                  allLanguageOptions.add(new SelectOption(so.getValue(),label));

          }

        }
        return allLanguageOptions;



        //return pkb_Controller.allLanguageOptions;
    }
    set;

  }

  public PageReference setSelLanguages(){

system.debug('\n================= '+selectedLanguageStr);
    selectedLanguages = selectedLanguageStr.split(',');
system.debug('\n================= '+selectedLanguages);

    return null;
  }

  public static Boolean isBlank(String s) {
    return (s == null || s == '');
  }

  public static Site getMatchingSite(String name) {
    List<Site> sites = [select Id, Name from Site where Name = :name];
    if (!sites.isEmpty()) return sites[0];
    if (sites.isEmpty() && !isRunningTest) return null;
    return new Site();
  }

  public static Boolean isRunningTest {
  	set;
  	get {
  		if (isRunningTest == null) isRunningTest = false;
  		return isRunningTest;
  	}
  }
}