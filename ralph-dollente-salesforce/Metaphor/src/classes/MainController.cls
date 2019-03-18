public class MainController{

    /**************** AUTO SEARCH FUNCTION *******************/
    
    public String searchedRecordId { get; set; }
    public static list<ResultSet> searchedRecord {get;set;}
    
    /*********************************************************/     

    public List<ProfileClass> memberList {get; set;}
    public SharedOpenDataSummaryClass openAccessSummary {get; set;}
    public SharedOpenDataDetailClass openDataDetailClass {get; set;}
    public List<AmountClass> offerList {get; set;}    
    
    /******************* PRODUCT **************************/   
     
    public List<HolderClass> productShared {get; set;}
    public List<HolderClass> productPersonal {get; set;}
    public List<HolderClass> productBooster {get; set;}
    public List<HolderClass> productBigBytes {get; set;}
    
    /******************* BALANCES *************************/
    
    public List<SharedBalanceClass> sharedBalanceList {get; set;}
    public List<PersonalBalanceClass> personalOpenBalanceList {get; set;}
    public List<PersonalBoosterClass> personalBoosterBalanceList {get; set;}
    
    /************** AUTH0 PROFILE **************************/
    
    public MyUserProfile myUserInfo {get;set;}
    public String access_token {get;set;}
    
    
    /******************* INBOX MESSAGES *******************/ 
    public List<Records> messages {get;set;}
    
    
    
    /******************* OTHER VARIABLES *****************/ 
    
    public List<SharedOpenDataDetailClass> openDataDetailList {get; set;}
    public List<BalanceDetailClass> detailClass {get; set;}
    public ProfileClass profile {get; set;}
    public String searchValue {get; set;}
    public String parameterId {get; set;}   
    private Map<String, String> param;    
    public String user_id {get;set;}
    
    /****************************************************/ 
    
    
    public MainController(){
        param = new Map<String, String>();
        parameterId = ApexPages.currentPage().getParameters().get('id');        
        user_id = ApexPages.currentPage().getParameters().get('user_id');
        
        System.debug('*** USER ID *** ' + user_id);
        
        if (user_id != null){
            getUserInfo(user_id);        
        }
        
        if (parameterId != null && !parameterId.isNumeric()){
            if (isEmailPattern(parameterId)){
                parameterId = searchEmailAddress(parameterId);
            }else if (!isEmailPattern(parameterId)){
                parameterId = searchByName(parameterId);
            }        
        }                
    }       
    
    private String searchEmailAddress(String email){    
        List<Profile__c> profile = [SELECT MSISDN__c FROM Profile__c WHERE Email__c =: email LIMIT 1];
        if (profile.size() > 0){
            return profile.get(0).MSISDN__c;
        }        
        return '';
    }
    
    private String searchByName(String name){
        String queryString = 'SELECT MSISDN__c FROM Profile__c WHERE Full_Name__c LIKE \'%' + name + '%\'';    
        System.debug('*** SEARCH BY NAME *** ' +  queryString);

        List<Profile__c> profile = Database.query(queryString);
        if (profile.size() > 0){
            return profile.get(0).MSISDN__c;
        }    
        return '';    
    }
    
    private Boolean isEmailPattern(String parameter){
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';        
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(parameter);

        if (!MyMatcher.matches()){ 
            System.debug('*** NOT EMAIL PATTERN ***');
            return false;    
        }       
        System.debug('*** THIS IS EMAIL PATTERN ***'); 
        return true;
    }    
    
    public void init(){}
   
    private Boolean isProfileExist(){
        List<Profile__c> p = [SELECT Id FROM Profile__c WHERE MSISDN__c =: parameterId];
    
        if (p != null && p.size() > 0)
            return true;
    
        return false;
    }       
   
   
     public void initProfile(){    
      
        profile = new ProfileClass('','','','','','','','','', '', '');
        
        if (parameterId != null){   
        
            if (!isProfileExist()){
                new CilantroGatewayAccess().processData(parameterId, 'accounts', 'msisdn');
            }
        
            List<Profile__c> p1 = [SELECT Cilantro_ID__c, Picture_URL__c, Firstname__c, Lastname__c, Email__c, Load_Protected__c, Middlename__c, Activated__c, Role__c, Status__c, Peso_Balance__c, MSISDN__c, Service_Type__c 
                                   FROM Profile__c WHERE MSISDN__c =: parameterId];
                                   
            System.debug('*** PROFILE *** ' + p1);
            
            if (p1 != null && p1.size() > 0){
                profile = new ProfileClass(p1.get(0).Firstname__c, p1.get(0).Middlename__c, p1.get(0).Lastname__c, p1.get(0).MSISDN__c, p1.get(0).Role__c, 
                                           String.valueOf(p1.get(0).Activated__c), String.valueOf(p1.get(0).Load_Protected__c), 
                                           String.valueOf(p1.get(0).Peso_Balance__c), p1.get(0).Service_Type__c, p1.get(0).Email__c, p1.get(0).Picture_URL__c);            

                System.debug('*** PROFILE *** ' + profile.picture_url);                                           
                                           
            } 
            getProducts();     
            getOffer(); 
            getMessages();
            
        }
    }       
    
    
    public void getMembers(){
        if (parameterId != null){
            memberList = new List<ProfileClass>();
            
            List<Members__c> members = [SELECT Id, Role__c, MSISDN__c, Lastname__c, Firstname__c, Activated__c FROM Members__c Where Profile__r.MSISDN__c =: parameterId];
            if (members.size() > 0){
                for(Members__c m: members){
                    memberList.add(new ProfileClass(m.Firstname__c, '', m.Lastname__c, m.MSISDN__c, m.Role__c, '', '', '', '', '',''));
                }                
            }       
        }        
    }
    
    public void getMessages(){
        messages = new List<Records>();
        List<Message__c> messageList = new List<Message__c>();
        List<Message_Details__c> messageDetails = new List<Message_Details__c>();
        List<Peso> detailList; 
        
        try{
            messageList = [SELECT Message__c, Name__c, Reference_Number__c, Timestamp__c, Type__c FROM Message__c WHERE Profile__r.MSISDN__c =: parameterId ORDER BY Timestamp__c DESC];
            messageDetails = [SELECT Display__c, Message__c, Expiration__c, Type__c FROM Message_Details__c WHERE Message__r.Profile__r.MSISDN__c =: parameterId];
            
            if (messageList.size() > 0){
                for(Message__c m: messageList){
                    detailList = new List<Peso>();
                    for(Message_Details__c  m2: messageDetails){
                        if(m2.Message__c == m.Id){                     
                            detailList.add(new Peso(m2.Type__c, m2.Display__c, m2.Expiration__c));
                        }
                    } //for
                    messages.add(new Records(m.Name__c, m.Type__c, m.Message__c, detailList, m.Reference_Number__c, Date.valueOf(m.Timestamp__c)));                    
                }//for  
                
                System.debug('*** MESSAGES *** ' +  messages);
            }
        }catch(Exception e){
            System.debug('*** ERROR: GETMESSAGES *** ' +  e.getMessage());
        }
    }
   
    public void getUserBalance(){
        sharedBalanceList = new List<SharedBalanceClass>();
        personalOpenBalanceList = new List<PersonalBalanceClass>();        
        personalBoosterBalanceList = new List<PersonalBoosterClass>();
        
        System.debug('*** GET USER BALANCE *** ' +  parameterId);
        
        
        if (parameterId != null){
            // SHARED OPEN ACCESS
            List<Shared_Open_Data__c> sharedOpenDataList = [SELECT Balance_Display__c, Balance_Expiration__c FROM Shared_Open_Data__c WHERE Profile__r.MSISDN__c =: parameterId]; 
            for(Shared_Open_Data__c shared_open :sharedOpenDataList){
                sharedBalanceList.add(new SharedBalanceClass('Open', shared_open.Balance_Expiration__c, shared_open.Balance_Display__c));            
            }
            
            
            // SHARED SMARTLIFE ACCESS
            List<Shared_Smart_Life_Data__c> sharedSmartLifeDataList = [SELECT Balance_Display__c, Balance_Expiration__c FROM Shared_Smart_Life_Data__c WHERE Profile__r.MSISDN__c =: parameterId]; 
            for(Shared_Smart_Life_Data__c s:sharedSmartLifeDataList){
                sharedBalanceList.add(new SharedBalanceClass('SmartLife', s.Balance_Expiration__c, s.Balance_Display__c));                        
            }
            
            
            // PERSONAL OPEN ACCESS
            List<Personal_Open_Data__c> personalOpenData = [SELECT Balance_Display__c, Balance_Expiration__c FROM Personal_Open_Data__c WHERE Profile__r.MSISDN__c =: parameterId]; 
            for(Personal_Open_Data__c p :personalOpenData){
                personalOpenBalanceList.add(new PersonalBalanceClass('Open', p.Balance_Expiration__c, p.Balance_Display__c));                        
            }
                        
            // PERSONAL SMARTLIFE ACCESS
            List<Personal_SmartLife_Data__c> personalSmartLifeData = [SELECT Balance_Display__c, Balance_Expiration__c FROM Personal_SmartLife_Data__c WHERE Profile__r.MSISDN__c =: parameterId]; 
            for(Personal_SmartLife_Data__c p :personalSmartLifeData){
                personalOpenBalanceList.add(new PersonalBalanceClass('SmartLife', p.Balance_Expiration__c, p.Balance_Display__c));                        
            }
        
        
            // BOOSTER ACCESS
            List<Personal_Booster_Data__c> personalBoosterData = [SELECT Name__c, Balance_Display__c, Balance_Expiration__c FROM Personal_Booster_Data__c WHERE Profile__r.MSISDN__c =: parameterId]; 
            for(Personal_Booster_Data__c booster :personalBoosterData){
                personalBoosterBalanceList.add(new PersonalBoosterClass(booster.Name__c, booster.Balance_Expiration__c, booster.Balance_Display__c));                        
            }
        }   
    }
    
    public void getSharedBalance(){
        if (parameterId != null){
            openAccessSummary = new SharedOpenDataSummaryClass('', '', '', '', '', '', '', '', '', '');
        
            List<Shared_Open_Data__c> sharedOpenDataList = [SELECT Id, Balance_Date__c, Balance_Display__c, Balance_Expiration__c, Balance_Unit__c, Balance_Value__c,
                                                            Total_Date__c, Total_Display__c, Total_Expiration__c, Total_Unit__c, Total_Value__c 
                                                            FROM Shared_Open_Data__c WHERE Profile__r.MSISDN__c =: parameterId];
            
            System.debug('*** SHARE SUMMARY *** ' + sharedOpenDataList);
                                                            
            if (sharedOpenDataList.size() > 0){
                for(Shared_Open_Data__c open :sharedOpenDataList){
                    openAccessSummary = new SharedOpenDataSummaryClass(String.valueOf(open.Balance_Date__c), open.Balance_Display__c, open.Balance_Expiration__c, open.Balance_Unit__c, String.valueOf(open.Balance_Value__c), 
                                                                       String.valueOf(open.Total_Date__c), open.Total_Display__c,  open.Total_Expiration__c, open.Total_Unit__c, String.valueOf(open.Total_Value__c));                
                }            
            }                                                            
        }
    }
        
    public void getBalanceDetails(){
        if (parameterId != null){
            openDataDetailList = new List<SharedOpenDataDetailClass>();        
            List<Shared_Open_Transaction__c> transactionDetails = [SELECT Id, Date__c, Display__c, Member_Name__c, Role__c, Unit__c, Value__c FROM Shared_Open_Transaction__c WHERE Profile__r.MSISDN__c =: parameterId];
            for(Shared_Open_Transaction__c s :transactionDetails){            
                openDataDetailList.add(new SharedOpenDataDetailClass(s.Member_Name__c, String.valueOf(s.Date__c), String.valueOf(s.Value__c), s.Unit__c, s.Display__c)); 
            }
        }    
    }

    
    public void getOffer(){     
        offerList = new List<AmountClass>();
        
        List<Denomination__c> listProduct = [SELECT Id, Display__c, Unit__c, Value__c  FROM Denomination__c ORDER BY Value__c asc ];        
        if(listProduct.size() > 0){
            for(Denomination__c d: listProduct){  
                offerList.add(new AmountClass(d.Unit__c, string.valueof(d.Value__c), d.Display__c )); 
            }
        }
    
    }

    public void getProducts(){        
        productShared = new List<HolderClass>();
        productPersonal = new List<HolderClass>();
        productBooster = new List<HolderClass>();
               
        List<Product__c> listProduct = [SELECT Id, Id__c, Category_Id__c, Description__c, Image_Url__c, Name__c, 
                                        SmartLife_Data_Display__c, SmartLife_Data_Unit__c, Open_Access_Data_Allowance__c, Open_Access_Data_Validity__c,
                                        SmartLife_Data_Validity__c, SmartLife_Data_Value__c, Unit__c, Value__c FROM Product__c];
        
        if (listProduct.size() == 0){
            new CilantroGatewayAccess().processData('', 'catalog', 'products'); 
        }
        
        List<Categories__c> categoryList = [SELECT Id__c, Name__c FROM Categories__c];
        if (listProduct.size() > 0 && categoryList.size() > 0){
            for (Categories__c cat :categoryList){
                for(Product__c product: listProduct){                     
                    if (cat.Name__c.toLowerCase().contains('shared') && cat.Id__c == product.Category_Id__c){
                        productShared.add(new HolderClass(product.Name__c, String.valueOf(product.Value__c), product.Open_Access_Data_Allowance__c, 
                                                            product.Open_Access_Data_Validity__c, product.SmartLife_Data_Display__c, product.SmartLife_Data_Validity__c));                
                    
                    }else if (cat.Name__c.toLowerCase().contains('personal') && cat.Id__c == product.Category_Id__c){
                        productPersonal.add(new HolderClass(product.Name__c, String.valueOf(product.Value__c), product.Open_Access_Data_Allowance__c, 
                                                            product.Open_Access_Data_Validity__c, product.SmartLife_Data_Display__c, product.SmartLife_Data_Validity__c));                
                    
                    }else if (cat.Name__c.toLowerCase().contains('booster') && cat.Id__c == product.Category_Id__c){
                        productBooster.add(new HolderClass(product.Name__c, String.valueOf(product.Value__c), product.Open_Access_Data_Allowance__c, 
                                                           product.Open_Access_Data_Validity__c, product.SmartLife_Data_Display__c, product.SmartLife_Data_Validity__c));                                    
                    }                
                } // for product        
            }// for categories            
        }
    }
    
    /*********************************************** REMOTE ACTION SECTION *******************************************/
    
    @RemoteAction
    public static ResultSet[] getRecords(String searchText) {
        //sObject List
        searchedRecord = new list<ResultSet>();
        
        //SOSL Text should be more than one character
        System.debug('*** SEARCH TEXT *** ' + searchText);
        
        if(searchText.length() >0){
        
            //SOSL operation to retrive records of profile
            List<List<SObject>> searchList = [FIND :searchText+'*' IN ALL FIELDS RETURNING Profile__c(Id, Name, Email__c, Firstname__c, Lastname__c, MSISDN__c, Role__c, Full_Name__c, Peso_Balance__c, Status__c)];
            System.debug('*** SEARCH LIST *** ' + searchList);
            for(List<SObject> o:searchList){
                for(SObject s:o){
                    searchedRecord.add(new ResultSet(s));
                } 
            }
        }
        return searchedRecord;        
    }
    
    /*getGlobalDescribed*/
    public static list<Schema.SObjectType> gd{
        get{
            if(gd == null){
                gd = Schema.getGlobalDescribe().values();
            }
            return gd ;
        }set;
    }
    
     /*Record Wrapper*/
    public class ResultSet{
        public String Id {get;set;} 
        public String sObjectName {get;set;}
        
        public String Email {get; set;}
        public String Firstname {get;set;}
        public String Lastname {get; set;}
        public String MSISDN {get; set;}
        public String Fullname {get; set;}
        public String Role {get;set;}
        public String PesoBalance {get;set;}
        public String Status {get;set;}
        
        public ResultSet(sObject s){
            this.Id = s.Id;
            this.Email = String.valueOf(s.get('Email__c'));
            this.Firstname = String.valueOf(s.get('Firstname__c'));
            this.MSISDN = String.valueOf(s.get('MSISDN__c'));
            this.Fullname = String.valueOf(s.get('Full_Name__c'));
            this.Role = String.valueOf(s.get('Role__c'));
            this.Lastname = String.valueOf(s.get('Lastname__c'));
            this.PesoBalance = String.valueOf(s.get('Peso_Balance__c'));
            this.Status = String.valueOf(s.get('Status__c'));
            
            this.sObjectName = getsObjectNameById(Id);            
        }  
             
        public ResultSet(String Id, String Email, String Firstname, String Lastname, String MSISDN, String Fullname, String Role, String PesoBalance, String Status){
            this.Id = Id;
            this.Email = Email;
            this.Firstname = Firstname;   
            this.MSISDN = MSISDN;   
            this.Fullname = Fullname;      
            this.Role = Role;
            this.Lastname = Lastname;
            this.PesoBalance = PesoBalance;
            this.Status = Status;            
            this.sObjectName = getsObjectNameById(Id);            
        }
        
        /*To get object Name by Id*/
        private String getsObjectNameById(String sObjectId){            
            if(sObjectId != null && sObjectId.trim() != ''){
                for(Schema.SObjectType objectInstance : gd){
                    if(objectInstance.getDescribe().getKeyPrefix() == sObjectId.subString(0,3)){    
                        return objectInstance.getDescribe().getLabel();
                    }
                }
            }
            return null;
        }
    }
    
    
    @RemoteAction
    public static CategoryClass[] getUserDashboardData(String parameterId){
    
        System.debug('*** PARAMETER ID *** ' + parameterId);
    
        List<CategoryClass> resultSet = new List<CategoryClass>();
        
        Set<String> ids = new Set<String>();
        Set<String> type = new Set<String>();
        
        
        String queryString = 'SELECT Id, Category_Name__c FROM Personal_Categories__c WHERE Profile__r.MSISDN__c = \'' + parameterId + '\'';
        queryString += ' GROUP BY Category_Name__c, Id';
        
        System.debug('*** QUERY STRING *** ' + queryString);
        
        AggregateResult[] groupedResults = Database.query(queryString);

        for (AggregateResult ar : groupedResults)  {
            ids.add(String.valueOf(ar.get('Id')));
            type.add(String.valueOf(ar.get('Category_Name__c')));
        }

        queryString = 'SELECT Id, Category_Type__c, Date__c, Value__c FROM Personal_Category_Details__c ';
        queryString += 'WHERE Personal_Categories__c IN : ids ';
        queryString += 'ORDER BY Category_Type__c, Date__c';
        
        System.debug('*** QUERY STRING *** ' + queryString);
        
        List<Personal_Category_Details__c> details = Database.query(queryString);
        System.debug('*** CATEGORY DETAILS *** ' + details);
        
        String currentMonth = '';
        String currentDay = '';
        Decimal value = 0;
        
        
        for(Personal_Category_Details__c d :details){
            currentMonth = String.valueOf(DateTime.valueOf(d.Date__c).format('MMMM').subString(0, 3));
            currentDay = String.valueOf(DateTime.valueOf(d.Date__c).format('dd'));
            value = d.Value__c;
            resultSet.add(new CategoryClass(String.valueOf(currentMonth + ' ' + currentDay), String.valueOf(value.intValue()), String.valueOf(d.Category_Type__c)));
        }        
        return resultSet;
    }


    @RemoteAction
    public static GraphClass getUserDashboardByMonth(String parameterId, String startDate, String endDate){
        
        String[] d1 = startDate.split('/');
        String[] d2 = endDate.split('/');
        
        Set<String> ids = new Set<String>();
        Set<String> categoryType = new Set<String>();
        
        String queryString = 'SELECT Id, Category_Name__c FROM Personal_Categories__c WHERE Profile__r.MSISDN__c = \'' + parameterId + '\'';
        queryString += ' GROUP BY Category_Name__c, Id';
        
        AggregateResult[] groupedResults = Database.query(queryString);

        for (AggregateResult ar : groupedResults)  {
            ids.add(String.valueOf(ar.get('Id')));
            categoryType.add(String.valueOf(ar.get('Category_Name__c')));
        }
                
        Integer fromYear = Integer.valueOf(d1[2]);
        Integer toYear = Integer.valueOf(d2[2]);
        
        Integer currentMonth = Integer.valueOf(d1[0]);
        
        queryString = 'SELECT Category_Type__c, Calendar_Year(Date__c), Calendar_Month(Date__c), SUM(Value__c) FROM Personal_Category_Details__c ' +
                       'WHERE Profile__r.MSISDN__c= :parameterId AND (Calendar_Year(Date__c) = :fromYear OR Calendar_Year(Date__c) = :toYear) ' +
                       'GROUP BY Category_Type__c, Calendar_Year(Date__c), Calendar_Month(Date__c) ' + 
                       'ORDER BY Calendar_Month(Date__c), Calendar_Year(Date__c)';
    
        AggregateResult[] categoryDetailsResults = Database.query(queryString);        
        System.debug('*** categoryDetailsResults *** ' + categoryDetailsResults);
    
        String[] months = new String[]{'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'July', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'}; 
        String[] entertainment = new String[]{'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'}; 
        String[] ecommerce = new String[]{'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'};
        String[] travel = new String[]{'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'};
        String[] social = new String[]{'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'};
        String[] others = new String[]{'0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'};
        
        Integer arMonth = 0;
        for(AggregateResult ar : categoryDetailsResults){
            arMonth = Integer.valueOf(ar.get('expr1'))-1;
            if (String.valueOf(ar.get('Category_Type__c')).toLowerCase().equals('entertainment')){                
                entertainment[arMonth] = String.valueOf(Integer.valueOf(ar.get('expr2')));
            }else if (String.valueOf(ar.get('Category_Type__c')).toLowerCase().equals('ecommerce')){
                ecommerce[arMonth] = String.valueOf(Integer.valueOf(ar.get('expr2')));
            }else if (String.valueOf(ar.get('Category_Type__c')).toLowerCase().equals('travel')){
                travel[arMonth] = String.valueOf(Integer.valueOf(ar.get('expr2')));
            }else if (String.valueOf(ar.get('Category_Type__c')).toLowerCase().equals('social')){
                social[arMonth] = String.valueOf(Integer.valueOf(ar.get('expr2')));
            }else if (String.valueOf(ar.get('Category_Type__c')).toLowerCase().equals('others')){
                others[arMonth] = String.valueOf(Integer.valueOf(ar.get('expr2')));
            }
        }
        return new GraphClass(months, entertainment, ecommerce, travel, social, others);
    }


    @RemoteAction
    public static CategoryClass[] getUserDashboardDataByRange(String parameterId, String startDate, String endDate){
    
        System.debug('*** PARAMETER ID *** ' + parameterId);
        System.debug('*** START DATE *** ' + startDate);
        System.debug('*** END DATE *** ' + endDate);
        
        String[] d1 = startDate.split('/');
        String[] d2 = endDate.split('/');
        
        DateTime d3 = datetime.newInstance(Integer.valueOf(d1[2]), Integer.valueOf(d1[0]), Integer.valueOf(d1[1]));
        DateTime d4 = datetime.newInstance(Integer.valueOf(d2[2]), Integer.valueOf(d2[0]), Integer.valueOf(d2[1]));
       
        String formattedDt1 = d3.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        String formattedDt2 = d4.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
    
        System.debug('*** formattedDt1 *** ' + formattedDt1);
        System.debug('*** formattedDt2 *** ' + formattedDt2); 
    
        List<CategoryClass> resultSet = new List<CategoryClass>();
        
        Set<String> ids = new Set<String>();
        Set<String> type = new Set<String>();
        
        
        String queryString = 'SELECT Id, Category_Name__c FROM Personal_Categories__c WHERE Profile__r.MSISDN__c = \'' + parameterId + '\'';
        queryString += ' GROUP BY Category_Name__c, Id';
        
        System.debug('*** QUERY STRING BY DATE RANGE *** ' + queryString);
        
        AggregateResult[] groupedResults = Database.query(queryString);

        for (AggregateResult ar : groupedResults)  {
            ids.add(String.valueOf(ar.get('Id')));
            type.add(String.valueOf(ar.get('Category_Name__c')));
        }

        queryString = 'SELECT Id, Category_Type__c, Date__c, Value__c FROM Personal_Category_Details__c ';
        queryString += 'WHERE Personal_Categories__c IN : ids ';
        queryString += 'AND (Date__c >= ' + formattedDt1;
        queryString += ' AND Date__c <= ' + formattedDt2 + ') ';
        queryString += 'ORDER BY Category_Type__c, Date__c';
                
        System.debug('*** QUERY STRING BY DATE RANGE *** ' + queryString);
        
        List<Personal_Category_Details__c> details = Database.query(queryString);
        System.debug('*** CATEGORY DETAILS *** ' + details);
        
        String currentMonth = '';
        String currentDay = '';
        Decimal value = 0;
        
        
        for(Personal_Category_Details__c d :details){
            currentMonth = String.valueOf(DateTime.valueOf(d.Date__c).format('MMMM').subString(0, 3));
            currentDay = String.valueOf(DateTime.valueOf(d.Date__c).format('dd'));
            value = d.Value__c;
            resultSet.add(new CategoryClass(String.valueOf(currentMonth + ' ' + currentDay), String.valueOf(value.intValue()), String.valueOf(d.Category_Type__c)));
        }        
        return resultSet;
    }

    @RemoteAction
    public static BalanceClass[] getUserDashboardUsageBalances(String parameterId){
        List<BalanceClass> resultSet = new List<BalanceClass>();

        String queryString = 'SELECT Balance_Expiration__c, Balance_Display__c FROM Shared_Open_Data__c ';
        queryString += 'WHERE Profile__r.MSISDN__c =: parameterId';
        List<Shared_Open_Data__c> sharedOpenData = Database.query(queryString);
                
        queryString = 'SELECT Balance_Expiration__c, Balance_Display__c FROM Shared_Smart_Life_Data__c ';
        queryString += 'WHERE Profile__r.MSISDN__c =: parameterId';        
        List<Shared_Smart_Life_Data__c> sharedSmartLifeData = Database.query(queryString);
        
        
        queryString = 'SELECT Balance_Expiration__c, Balance_Display__c FROM Personal_Open_Data__c ';
        queryString += 'WHERE Profile__r.MSISDN__c =: parameterId';
        List<Personal_Open_Data__c> personalOpenData = Database.query(queryString);
        
        
        queryString = 'SELECT Balance_Expiration__c, Balance_Display__c FROM Personal_SmartLife_Data__c ';
        queryString += 'WHERE Profile__r.MSISDN__c =: parameterId';
        List<Personal_SmartLife_Data__c> personalSmartLifeData = Database.query(queryString);
        
        resultSet.add(new BalanceClass(sharedOpenData.get(0).Balance_Expiration__c, 
                                       sharedOpenData.get(0).Balance_Display__c,
                                       sharedSmartLifeData.get(0).Balance_Expiration__c, 
                                       sharedSmartLifeData.get(0).Balance_Display__c,
                                       personalOpenData.get(0).Balance_Expiration__c, 
                                       personalOpenData.get(0).Balance_Display__c,
                                       personalSmartLifeData.get(0).Balance_Expiration__c, 
                                       personalSmartLifeData.get(0).Balance_Display__c));
    
        return resultSet;    
    }

    public class GraphClass{
        public String[] months {get;set;}
        public String[] entertainment {get;set;}
        public String[] ecommerce {get;set;}
        public String[] travel {get;set;}
        public String[] social {get;set;}
        public String[] others {get;set;}
        
        public GraphClass(String[] months, String[] entertainment, String[] ecommerce, String[] travel, String[] social, String[] others){
            this.months = months;
            this.entertainment = entertainment;
            this.ecommerce = ecommerce;
            this.travel = travel;
            this.social = social;
            this.others = others;
        }
    }

    public class CategoryClass{
    
        public String currentDate {get;set;}
        public String value {get;set;}
        public String categoryType {get;set;}
    
        public CategoryClass(String currentDate, String value, String categoryType){
            this.currentDate = currentDate;
            this.value = value;
            this.categoryType = categoryType;
        }
    }


    public class BalanceClass{
        
        public String shared_open_remaining_days {get;set;}
        public String shared_open_remaining_bytes {get;set;}
        
        public String shared_smartlife_remaining_days {get;set;}
        public String shared_smartlife_remaining_bytes {get;set;}
        
        public String personal_open_remaining_days {get;set;}
        public String personal_open_remaining_bytes {get;set;}
        
        public String personal_smartlife_remaining_days {get;set;}
        public String personal_smartlife_remaining_bytes {get;set;}
    
        public BalanceClass(String shared_open_remaining_days, 
                            String shared_open_remaining_bytes,
                            String shared_smartlife_remaining_days, 
                            String shared_smartlife_remaining_bytes,                            
                            String personal_open_remaining_days, 
                            String personal_open_remaining_bytes,
                            String personal_smartlife_remaining_days, 
                            String personal_smartlife_remaining_bytes){  
                                  
            this.shared_open_remaining_days = shared_open_remaining_days;
            this.shared_open_remaining_bytes = shared_open_remaining_bytes;
            this.shared_smartlife_remaining_days = shared_smartlife_remaining_days;
            this.shared_smartlife_remaining_bytes = shared_smartlife_remaining_bytes;       
            
            this.personal_open_remaining_days = personal_open_remaining_days;       
            this.personal_open_remaining_bytes = personal_open_remaining_bytes;       
            this.personal_smartlife_remaining_days = personal_smartlife_remaining_days;       
            this.personal_smartlife_remaining_bytes = personal_smartlife_remaining_bytes;       
             
        }
    
    }

    /*********************************************** END REMOTE ACTION SECTION *******************************************/
    
    
     public String getUserInfo(String token){    
        
        String static_profile_url = System.label.Auth0_User_Info;
        
        String response = '';   
        HttpRequest req = new HttpRequest(); 
        req.setMethod('GET');
        req.setHeader('Authorization' , 'Bearer ' + token);        
        req.setEndPoint(static_profile_url);
        req.setTimeout(99999);
        
        try {        
            if (!Test.isRunningTest()){

                //Execute web service call here  
                Http http = new Http();                   
                HTTPResponse res = http.send(req);  
                
                //Helpful debug messages
                System.debug('*** STATUS *** ' + res.getStatus());
                System.debug('*** STATUS_CODE *** '+ res.getStatusCode());
                
                if (res.getStatusCode() == 404){
                    ErrorHandler e = new ErrorHandler(new ErrorClass('404', 'Not Found', ''));
                    response = JSON.serialize(e);
                }else{
                    response = res.getBody();                    
                    setUserInfo(response);
                }
            }
        } catch(System.CalloutException e) {
            System.debug('*** ERROR **** ' + e.getMessage());
        }            
        return response;
    }
    
    
    public void setUserInfo(String response){
        JSONParser parser = JSON.createParser(response);
    
        while(parser.nextToken() != null){
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                myUserInfo = (MyUserProfile)JSON.deserialize(response, MyUserProfile.class);
                parser.skipChildren();
            }
        }
    
        if (myUserInfo.identities[0] != null && myUserInfo.identities[0].access_token != null){
            this.access_token = myUserInfo.identities[0].access_token;
        }
    
        System.debug('*** MyUserInfo *** ' + myUserInfo);        
        System.debug('*** Access Token *** ' + myUserInfo.identities[0].access_token);    
    }
    
    
    public class ProductClass{        
        public String categoryId {get; set;}
        public String description {get; set;}
        public String imageUrl {get; set;}
        public String name {get; set;}
        public String smartLifeDataDisplay {get; set;}
        public String smartLifeDataUnit {get; set;}
        public String smartLifeDataValidity{get; set;}        
        public String smartLifeDataValue {get; set;}        
        public String unit {get; set;}        
        public String value {get; set;}
                
        public ProductClass(String categoryId, String description, String imageUrl, String name, String smartLifeDataDisplay, 
                            String smartLifeDataUnit, String smartLifeDataValidity, 
                            String smartLifeDataValue, String unit, String value){
            this.categoryId = categoryId;
            this.description = description;
            this.imageUrl = imageUrl;
            this.name = name;
            this.smartLifeDataDisplay = smartLifeDataDisplay;
            this.smartLifeDataUnit = smartLifeDataUnit;
            this.smartLifeDataValidity = smartLifeDataValidity;
            this.smartLifeDataValue = smartLifeDataValue;
            this.unit = unit;
            this.value = value;
        }    
    }    
    
    public class HolderClass{        
        public String name {get; set;}
        public String amount {get; set;} 
        public String openAccessDataAllowance {get; set;}
        public String openAccessDataValidity {get; set;}
        public String smartLifeDataAllowance {get; set;}
        public String smartLifeDataValidity {get; set;}    
        public HolderClass(String name, String amount, String openAccessDataAllowance, String openAccessDataValidity, String smartLifeDataAllowance, String smartLifeDataValidity){
            this.name = name;
            this.amount = amount;
            this.openAccessDataAllowance = openAccessDataAllowance;
            this.openAccessDataValidity = openAccessDataValidity;
            this.smartLifeDataAllowance = smartLifeDataAllowance;
            this.smartLifeDataValidity = smartLifeDataValidity;
        }    
    }
    
    public class SharedBalanceClass{    
        public String access_type {get; set;} //open or smartlife
        public String days_remain {get; set;} // balance expiration 
        public String bytes_remain {get; set;} // balance display            
        public SharedBalanceClass(String access_type, String days_remain, String bytes_remain){
            this.access_type = access_type;
            this.days_remain = days_remain;
            this.bytes_remain = bytes_remain;            
        }    
    }
    
    public class PersonalBalanceClass{    
        public String access_type {get; set;} 
        public String days_remain {get; set;}
        public String bytes_remain {get; set;}    
        public PersonalBalanceClass(String access_type, String days_remain, String bytes_remain){
            this.access_type = access_type;
            this.days_remain = days_remain;
            this.bytes_remain = bytes_remain;            
        }    
    }
    
    public class PersonalBoosterClass{    
        public String name {get; set;}
        public String days_remain {get; set;}
        public String bytes_remain {get; set;}    
        public PersonalBoosterClass(String name, String days_remain, String bytes_remain){
            this.name = name;
            this.days_remain = days_remain;
            this.bytes_remain = bytes_remain;  
        }
    }
    
    public class Records{        
        public String name {get;set;} 
        public String type_Z {get;set;}         
        public String message {get;set;} 
        public List<Peso> details {get;set;} 
        public String reference_number {get;set;} 
        public Date timestamp {get;set;}             
        public Records(String name, String type_z, String message, List<Peso> details, String reference_number, Date timestamp){
            this.name = name;
            this.message = message;
            this.type_z = type_z;
            this.details = details;
            this.reference_number = reference_number;
            this.timestamp = timestamp;        
        }
    }
    
    public class Details{
        public Peso peso {get;set;}
        public Peso open_data {get;set;} 
        public Peso smart_life_data {get;set;}        
        public Details(Peso peso, Peso open_data, Peso smart_life_data){
            this.peso = peso;
            this.open_data = open_data;
            this.smart_life_data = smart_life_data;
        }
    }
        
    public class Peso{
        public String type {get;set;}
        public String display {get;set;} 
        public String expiration {get;set;}     
        
        public Peso(String type, String display, String expiration){
            this.type = type;
            this.display = display;
            this.expiration = expiration;
        }        
    }
    
    public class UserProfileClass{        
        public String first_name {get; set;}
        public String middle_name {get; set;}
        public String last_name {get; set;}
        public String msisdn {get; set;}
        public String role {get; set;}
        public String activated {get; set;}
        public String load_protected {get; set;}
        public String pesoBalance {get; set;}
        public String serviceType {get; set;}
        public String email {get; set;}
    
        public UserProfileClass(SObject o){
            this.first_name = String.valueOf(o.get('Firstname__c'));
            this.middle_name = String.valueOf(o.get('Middlename__c'));
            this.last_name = String.valueOf(o.get('Lastname__c'));
            this.email = String.valueOf(o.get('Email__c'));
            this.msisdn = String.valueOf(o.get('MSISDN__c'));
            this.role = String.valueOf(o.get('Role__c'));
            this.activated = String.valueOf(o.get('Activated__c'));
            this.load_protected = String.valueOf(o.get('Load_Protected__c'));
            this.pesoBalance = String.valueOf(o.get('Peso_Balance__c'));   
            this.serviceType = String.valueOf(o.get('Service_Type__c'));         
        }
    
    }
}