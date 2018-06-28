@IsTest
public class AssureClick_1394544983392_US383_02 {

	public static Venue__c venue_2 = null;
	public static Site__c site_1 = null;

	// Main test for the current user
	static testMethod void kehot_execute_test() {
		kehot_core_execution('', '', '', '');
	}

	public static void kehot_core_execution(String elsUsr, String elsProf, String elsRole, String elsPM) {
		Datetime   TstStart        = Datetime.now();
		kSecSett   kss = new kSecSett(); kss.us = elsUsr; kss.pr = elsProf; kss.rl = elsRole; kss.pm = elsPM;
		User TstExecUser = getUserForKSS(kss, TstStart);
		String     TstExecUserId   = TstExecUser.Id;

		// Call Start Element methods
		venue_2 = kehot_US383_02_2_Venue(TstExecUser);		// Start Element: Venue/Insert
		site_1 = kehot_US383_02_1_Site(TstExecUser);		// Start Element: Site/Insert

		try {
			insert site_1;		// Site/Insert
			addkPos('SE', 'a17e0000003WocqAAC');
		} catch (DmlException e) {
			erKDML er = new erKDML();
			er.elType = 'SE'; er.elId='a17e0000003WocqAAC';
			kehotDMLSEException ke = new kehotDMLSEException(er, e, kss);
			throw ke;
		} catch (Exception e) {
			erKDML er = new erKDML();
			er.elType = 'SE'; er.elId='a17e0000003WocqAAC';
			kehotDMLSEException ke = new kehotDMLSEException(er, e, kss);
			throw ke;
		}

		venue_2.Site__c = site_1.Id;
		try {
			insert venue_2;		// Venue/Insert
			addkPos('SE', 'a17e0000003WodFAAS');
		} catch (DmlException e) {
			erKDML er = new erKDML();
			er.elType = 'SE'; er.elId='a17e0000003WodFAAS';
			kehotDMLSEException ke = new kehotDMLSEException(er, e, kss);
			throw ke;
		} catch (Exception e) {
			erKDML er = new erKDML();
			er.elType = 'SE'; er.elId='a17e0000003WodFAAS';
			kehotDMLSEException ke = new kehotDMLSEException(er, e, kss);
			throw ke;
		}


		Test.startTest();
	System.runAs(TstExecUser) {


		// Updates for Input Element "Update Venue"
		venue_2.Name = 'VPRS Softech Solutions Pvt. ltd.';
		venue_2.Active__c = false;
		venue_2.Site__c = site_1.Id;	// Link to Start Element "Site/Insert"
		venue_2.Address2__c = 'Dr. V.P.R. Nagar,';
		venue_2.Address1__c = 'Dhanalakshmi College of Engineering,';

		try {
			update venue_2;		// Input Element: Update Venue
			addkPos('IE', 'a0ze0000000U6syAAC');
		} catch (DmlException e) {
			erKDML er = new erKDML();
			er.elType = 'IE'; er.elId='a0ze0000000U6syAAC';
			kehotDMLSEException ke = new kehotDMLSEException(er, e, kss);
			throw ke;
		} catch (Exception e) {
			erKDML er = new erKDML();
			er.elType = 'IE'; er.elId='a0ze0000000U6syAAC';
			kehotDMLSEException ke = new kehotDMLSEException(er, e, kss);
			throw ke;
		}


	}	// end runAs
		Test.stopTest();

		// Retrieve data for Start Element "Venue/Insert"
		list<Venue__c> lstVenue1 = [
			select	id
			from	Venue__c
			where	Id = :venue_2.Id
			];
		if (lstVenue1.size() == 0)
			throw new kehotNegException('a14e0000000OhXCAA0', 300+0, TstStart, kss);
		if (lstVenue1.size() > 1)
			throw new kehotNegException('a14e0000000OhXCAA0', 300+2, TstStart, kss);
		if (s_LstAssertsNotOk.size() > 0)
			throw new kehotNegException('a14e0000000OhXCAA0', 200, TstStart, kss);


		throw new kehotPosException(TstStart, kss);
	}
	// Create the Venue for Start Element "Venue/Insert"
	public static Venue__c kehot_US383_02_2_Venue(User TstExecUser) {
		Venue__c Venue = new Venue__c();
		Venue.Name = 'VPRS Softech Solutions Pvt. ltd.';
		Venue.Active__c = true;
		Venue.Address1__c = 'Dhanalakshmi College of Engineering,';
		Venue.Address2__c = 'Dr. V.P.R. Nagar,';
		return Venue;
	}

	// Create the Site for Start Element "Site/Insert"
	public static Site__c kehot_US383_02_1_Site(User TstExecUser) {
		Site__c Site = new Site__c();
		Site.Name = 'India, Bangalore';
		Site.Active__c = true;
		Site.Non_selectable__c = false;
		return Site;
	}


	// Main FLS test for the current user
	static testMethod void flsc_usr() {
		String flsCheckResult = kehot_core_flscheck('', '', '', '');
		if (flsCheckResult.length() > 0)
			throw new kehotFLSException(flsCheckResult);
	}

	public static String kehot_core_flscheck(String elsUsr, String elsProf, String elsRole, String elsPM) {
		Datetime   TstStart        = Datetime.now();
		kSecSett   kss = new kSecSett(); kss.us = elsUsr; kss.pr = elsProf; kss.rl = elsRole; kss.pm = elsPM;
		User TstExecUser = getUserForKSS(kss, TstStart);
		String     TstExecUserId   = TstExecUser.Id;

		String flsCheckResult = '';

		flsCheckResult = addFLDCheckUsrInfo(kss);
		System.runAs(TstExecUser) {
			Schema.SObjectType Venue_objType = Schema.getGlobalDescribe().get('Venue__c');
			Schema.DescribeSObjectResult Venue_objDescResult = Venue_objType.getDescribe();
			Map<String, Schema.SObjectField> Venue_mapFldName2sObjFld = Venue_objDescResult.fields.getMap();

			if (! Venue_objDescResult.isUpdateable()) {
				flsCheckResult += addObjectCheck('Venue__c', 'U');
			}
			if (Venue_objDescResult.isUpdateable()) {
				Schema.SObjectField f = null;
				f = Venue_mapFldName2sObjFld.get('Active__c');
				if (f != null && ! f.getDescribe().isUpdateable())
					flsCheckResult += addFLSCheck('a10e0000000fA8pAAE', 'U');	// Active__c
			}
		}
		return flsCheckResult;
	}


	private static String addFLDCheckUsrInfo(kSecSett kss) {
		return 'U|' + kss.us + '|' + kss.pr + '|' + kss.rl + '|' + kss.pm + ';';
	}
	private static String addFLSCheck(String id, String op) {
		return 'F|' + id + '|' + op + ';';
	}
	private static String addObjectCheck(String objApiName, String op) {
		return 'O|' + objApiName + '|' + op + ';';
	}
	private static String addFLSNTCCheck(String fvpId, String op, String ntcId) {
		return 'NTCF|' + fvpId + '|' + op + '|' + ntcId + ';';
	}
	private static String addObjectNTCCheck(String objApiName, String op, String ntcId) {
		return 'NTCO|' + objApiName + '|' + op + '|' + ntcId + ';';
	}
	public class kehotFLSException extends kehotGeneralException {
	}

	public virtual class kehotGeneralException extends Exception {}
	public class erOneDML {
		public String fldName          {get; set;}
		public String fldApiName       {get; set;}
		public String dmlMsg           {get; set;}
		public String dmlType          {get; set;}
		public erOneDML() {
			fldName=''; fldApiName='';dmlMsg='';dmlType='';
		}
	}
	public class erOneExcEntry {
		public String msg              {get; set;}
		public String typeName         {get; set;}
		public Integer nbr             {get; set;}
		public Integer nbrParent       {get; set;}
		public List<erOneDML>  dmls    {get; set;}
		public erOneExcEntry(Integer idx) {
			msg = ''; typeName = ''; nbr=idx; nbrParent=-1;dmls=new List<erOneDML>();
		}
	}
	public class erKDML {
		public String elType       {get; set;}
		public String elId         {get; set;}
		public String elName       {get; set;}
		public String elRefType    {get; set;}
		public String elRef        {get; set;}
		public String elsUsr       {get; set;}
		public String elsProf      {get; set;}
		public String elsRole      {get; set;}
		public String elsPM        {get; set;}
		public List<erOneExcEntry> excDtas {get; set;}
		public erKDML() {
			elType=''; elId='';elname='';elrefType='';elRef='';elsUsr='';elsProf='';elsRole='';elsPM='';excDtas = new List<erOneExcEntry>();
		}
	}
	public class kehotDMLSEException extends kehotGeneralException {
		public kehotDMLSEException(erKDML er, Exception e, kSecSett kss) {
			er.elsUsr = kss.us; er.elsProf = kss.pr; er.elsRole = kss.rl; er.elsPM = kss.pm;
			Integer idx = 0;
			erOneExcEntry oe = new erOneExcEntry(idx++);
			oe.msg = e.getMessage();
			oe.typeName = e.getTypeName();
			er.excDtas.add(oe);
			Exception p = e.getCause();
			while (p != null) {
				oe = new erOneExcEntry(idx++);
				oe.msg = p.getMessage();
				oe.typeName = p.getTypeName();
				if (oe.typeName.tolowercase() == 'dmlexception')
					cpyDmlData(oe, (DMLException) p);
				er.excDtas.add(oe);
				p = p.getCause();
			}
			this.setMessage(JSON.serialize(er));
		}
		public kehotDMLSEException(erKDML er, DMLException e, kSecSett kss) {
			er.elsUsr = kss.us; er.elsProf = kss.pr; er.elsRole = kss.rl; er.elsPM = kss.pm;
			Integer idx = 0;
			erOneExcEntry oe = new erOneExcEntry(idx++);
			oe.msg = e.getMessage();
			oe.typeName = e.getTypeName();
			cpyDmlData(oe, e);
			er.excDtas.add(oe);
			Exception p = e.getCause();
			while (p != null) {
				oe = new erOneExcEntry(idx++);
				oe.msg = p.getMessage();
				oe.typeName = p.getTypeName();
				if (oe.typeName.tolowercase() == 'dmlexception')
					cpyDmlData(oe, (DMLException) p);
				er.excDtas.add(oe);
				p = p.getCause();
			}
			this.setMessage(JSON.serialize(er));
		}
		private void cpyDmlData(erOneExcEntry oe, DMLException e) {
			for (Integer i=0; i < e.getNumDml(); i++) {
				erOneDML odml = new erOneDML();
				oe.dmls.add(odml);
				for (String fn : e.getDmlFieldNames(i))
					odml.fldName += fn + '|';
				if (e.getDmlFields(i) != null) {
					for (Schema.sObjectField sof : e.getDmlFields(i))
						odml.fldApiName += sof.getDescribe().getName() + '|';
				}
				odml.dmlMsg = e.getDmlMessage(i);
				if (e.getDmlType(i) != null)
					odml.dmlType = e.getDmlType(i).name();
			}
		}
	}
	public class kPositive {
		public String kpType           {get; set;}
		public String kpId             {get; set;}
		public kPositive(String tpe, String id) {
			this.kpType = tpe; this.kpId = id;
		}
	}
	public static List<kPositive> s_LstKPositive = new List<kPositive>();
	public static void addkPos(String tpe, String id) {
		s_LstKPositive.add(new kPositive(tpe, id));
	}
	public static void addkPosNTC(String ntcId, String tpe, String id, String dmlMsg) {
		String kpId = ntcId + '|' + id + '|' + dmlMsg.replace('|', '-');
		s_LstKPositive.add(new kPositive('NTC' + tpe, kpId));
	}
	public class kPositiveResult {
		public List<kPositive> LstKPositive        {get; set;}
		public Integer DMLRows                 {get; set;}
		public Integer DMLStmts                    {get; set;}
		public Integer HeapSize                    {get; set;}
		public Integer Qries                   {get; set;}
		public Integer QryRows                 {get; set;}
		public Integer ScrStmts                    {get; set;}
		public Long       TmInMs                   {get; set;}
		public String elsUsr       {get; set;}
		public String elsProf      {get; set;}
		public String elsRole      {get; set;}
		public String elsPM        {get; set;}
	}
	public class kehotPosException extends kehotGeneralException {
		public kehotPosException(datetime dtstart, kSecSett kss) {
			kPositiveResult kpr = new kPositiveResult();
			kpr.elsUsr = kss.us; kpr.elsProf = kss.pr; kpr.elsRole = kss.rl; kpr.elsPM = kss.pm;
			kpr.LstKPositive = s_LstKPositive;
			kpr.DMLRows = Limits.getDMLRows();
			kpr.DMLStmts = Limits.getDMLStatements();
			kpr.HeapSize = Limits.getHeapSize();
			kpr.Qries = Limits.getQueries();
			kpr.QryRows = Limits.getQueryRows();
			kpr.ScrStmts = Limits.getScriptStatements();
			kpr.TmInMs = Datetime.now().getTime() - dtstart.getTime();
			this.setMessage(JSON.serialize(kpr));
		}
	}
	public class kAssrt {
		public String  fvp                     {get; set;}
		public String  rv                      {get; set;}
	}
	public class kNegativeResult {
		public Integer errNumber               {get; set;}
		public String  REId                        {get; set;}
		public Long       TmInMs                   {get; set;}
		public List<String> LstKPosAss         {get; set;}
		public List<kAssrt> LstKNegAss         {get; set;}
		public String elsUsr       {get; set;}
		public String elsProf      {get; set;}
		public String elsRole      {get; set;}
		public String elsPM        {get; set;}
	}
	public static List<String> s_LstAssertsOk = new List<String>();
	public static List<kAssrt> s_LstAssertsNotOk = new List<kAssrt>();
	public static void addkAssrt(String fvpId, String realValue) {
		kAssrt ka = new kAssrt(); ka.fvp = fvpId; if (realValue == null) ka.rv = '<null>'; else ka.rv = realValue.abbreviate(50); s_LstAssertsNotOk.add(ka);
	}
	public static String kGetVal(String sIn) {
		if (sIn == null)
			return '<null>';
		return sIn.abbreviate(50);
	}
	public class kehotNegException extends kehotGeneralException {
		public kehotNegException(String REId, Integer errNumber, datetime dtstart, kSecSett kss) {
			kNegativeResult knr = new kNegativeResult();
			knr.elsUsr = kss.us; knr.elsProf = kss.pr; knr.elsRole = kss.rl; knr.elsPM = kss.pm;
			knr.TmInMs = Datetime.now().getTime() - dtstart.getTime();
			knr.errNumber = errNumber;
			knr.REId = REId;
			knr.LstKPosAss = s_LstAssertsOk;
			knr.LstKNegAss = s_LstAssertsNotOk;
			this.setMessage(JSON.serialize(knr));
		}
	}
	public class kehotUncNegTCException extends kehotGeneralException {
		public kehotUncNegTCException(erKDML er, kSecSett kss) {
			er.elsUsr = kss.us; er.elsProf = kss.pr; er.elsRole = kss.rl; er.elsPM = kss.pm;
			this.setMessage(JSON.serialize(er));
		}
	}
	public class kSecSett {
		public String us   {get; set;}
		public String pr   {get; set;}
		public String rl   {get; set;}
		public String pm   {get; set;}
	}
	public static User getUserForKSS(kSecSett kss, Datetime TstStart)
	{
		list<User> lstUsr = null;
		if (kss.us.length() == 0 && kss.pr.length() == 0 && kss.rl.length() == 0 && kss.pm.length() == 0) {
			lstUsr = [select id, name from User where isactive = true and id = :UserInfo.getUserId()]; 
		}
		else if (kss.us.length() > 0) {
			lstUsr = [select id, name from User where isactive = true and id = :kss.us];
		}
		if (lstUsr != null) {
			if (lstUsr.size() == 0)
				throw new kehotNegException('', 400+0, TstStart, kss);
			if (lstUsr.size() > 1)
				throw new kehotNegException('', 400+2, TstStart, kss);
			return lstUsr[0];
		}
		User usr = null;
		User currUser = [select id, name from User where isactive = true and id = :UserInfo.getUserId()];
		System.runAs(currUser) {	// avoid mixed_dml_operation error
			Double x = Math.random() * 10000;
			String rd = String.valueOf(Integer.valueOf(x));
			usr = new User();
			usr.FirstName = 'testfirstopmem';
			usr.LastName = 'testlastopmem';
			usr.EmailEncodingKey = 'ISO-8859-1';
			usr.Email = 'info@ext-it.com';
			usr.Alias = rd;
			usr.TimeZoneSidKey = 'America/New_York';
			usr.Username = 'somenam' + rd + '@ext-it.com';
			usr.LanguageLocaleKey = 'en_US';
			usr.LocaleSidKey = 'en_US';
			usr.CommunityNickname = 'somename' + rd;
			if (kss.pr.length() > 0)
				usr.ProfileId = kss.pr;
			if (kss.rl.length() > 0)
				usr.UserRoleId = kss.rl;
			insert usr;
			if (kss.pm.length() > 0) {
				PermissionSetAssignment psa = new PermissionSetAssignment();
				psa.AssigneeId = usr.Id;
				psa.PermissionSetId = kss.pm;
				insert psa;
			}
		}
		return usr;
	}
	private static Boolean kehot_UserIsInProfile(String userId, String profileId)
	{
		list<User> lstUsers = [select id, ProfileId from User where id = :userId and ProfileId = :profileId];
		return (lstUsers.size() == 1);
	}
	private static Boolean kehot_UserIsInRole(String userId, String roleId)
	{
		list<User> lstUsers = [select id, UserRoleId from User where id = :userId and UserRoleId = :roleId];
		return (lstUsers.size() == 1);
	}
}