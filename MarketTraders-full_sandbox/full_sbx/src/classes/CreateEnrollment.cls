public class CreateEnrollment{
    
    private Static Map<String, PB_Course__c> mcs = PB_Course__c.getAll();
    private static Map<String, Set<String>> mapCourseAccount = new Map<String, Set<String>>();
    
    private static Map<String, List<String>> mapAccIdCourses = new Map<String, List<String>>();
    private static Map<String, Account> strAcc = new Map<String, Account>();
    
    private static Set<String>  courseAPI = new Set<String>();
    
    private static Map<String, Set<String>> mapAccIdCoursesDisbable = new Map<String, Set<String>>();
    public static void onInsert(List<Account> lstAccount){
        //clearMaps();
        //filterAccountsInsert(lstAccount);
        //if(mapCourseAccount.size() != 0)  insertEnrollments();
        
        Map<String, PB_Course__c> mCourses = new Map<String, PB_Course__c>();
        
        for(String s:mcs.keySet())
        {
            if(!mCourses.containsKey(s.tolowercase())) 
            {
                mCourses.put(s.tolowercase(), mcs.get(s));
            }
        }
        
        Map<String, SobjectField> fieldMap = Account.getsObjectType().getDescribe().Fields.getMap(); 
        Set<String> fNames = fieldMap.keySet();

        for(Account a : lstAccount){
            for(String f: fNames)
            {
//                system.debug('Field Name:' + f);
                if ((f.startsWithIgnoreCase('PB') && mCourses.containsKey(f.tolowercase())) || f=='FirstName'  || f=='LastName' || f=='PersonEmail' || f=='LMS_Password__c')
                {                    
                    
                    if (a.get(f)==true){
                        a.LMS_Insert__c=true;
                        continue;
                    }
                }
            }
        }
    }  
    
    public static void onUpdate(Map<Id, Account> mapNewAccount, Map<Id, Account> mapOldAccount){
        //clearMaps();
        //filterAccountsUpdate(mapNewAccount, mapOldAccount);
        //if(mapCourseAccount.size() != 0)  insertEnrollments();
        //if(mapAccIdCoursesDisbable.size() != 0) disableEnrollment();

    Map<String, PB_Course__c> mCourses = new Map<String, PB_Course__c>();
        
        for(String s:mcs.keySet())
        {
            if(!mCourses.containsKey(s.tolowercase())) 
            {
                System.debug('@@@ putting to lower case: ' + s);
                mCourses.put(s.tolowercase(), mcs.get(s));
            }
        }
        
        Map<String, SobjectField> fieldMap = Account.getsObjectType().getDescribe().Fields.getMap(); 
        Set<String> fNames = fieldMap.keySet();
        for(Account a : mapNewAccount.values()){
            boolean isCourse=false;
            for(String f: fNames)
            {
                system.debug('Update Field Name:' + f);
                if ((f.startsWithIgnoreCase('PB') && mCourses.containsKey(f.tolowercase())) )
                {
                    system.debug(f + ':New:' + a.get(f));
                    system.debug(f + ':Old:' + mapOldAccount.get(a.id).get(f));                    
                    if(a.get(f)==true)
                    {
                        isCourse=true;
                    }
                    //if (mapOldAccount!= null && a.LMS_Insert__c==false && a.LMS_Insert__c == mapOldAccount.get(a.id).LMS_Insert__c)
                    if (mapOldAccount!= null && a.get(f) != mapOldAccount.get(a.id).get(f))
                    {
                        a.LMS_Insert__c=true;
                        continue;
                    }
                }                
                
            }
            if (isCourse==true && (a.get('LastName') != mapOldAccount.get(a.id).get('LastName') || a.get('FirstName') != mapOldAccount.get(a.id).get('FirstName') || a.get('LMS_Password__c') != mapOldAccount.get(a.id).get('LMS_Password__c') || a.get('PersonEmail') != mapOldAccount.get(a.id).get('PersonEmail')))
            {
                a.LMS_Insert__c=true;    
            }
        }
    }
        
    private static void filterAccountsInsert(List<Account> lstAccount){
        for(Account a : lstAccount){
            strAcc.put(a.Id, a);
            for(PB_Course__c pbCourse : mcs.values()){
                String strCourseName = pbCourse.Course_API_Name__c.trim();
                System.debug('strCourseName'+ strCourseName);
                if(strCourseName != 'PB_ScalpingClass_Summary_CLIENT__c' && strCourseName != 'PB_UTP_Summary_Client__c' 
                   && a.get(strCourseName) == True ){
                   System.debug('strCourseName'+ strCourseName);
                   courseAPI.add(strCourseName);
                   if(! mapAccIdCourses.containsKey(a.Id)) mapAccIdCourses.put(a.Id, new List<String>());
                   mapAccIdCourses.get(a.Id).add(strCourseName); 
                }else if ((strCourseName == 'PB_ScalpingClass_Summary_CLIENT__c' || strCourseName == 'PB_UTP_Summary_Client__c') 
                   && a.get(strCourseName) == 'Purchased'){
                   courseAPI.add(strCourseName); 
                    System.debug('strCourseName'+ strCourseName);
                   if(! mapAccIdCourses.containsKey(a.Id)) mapAccIdCourses.put(a.Id, new List<String>());
                   mapAccIdCourses.get(a.Id).add(strCourseName); 
                } 
                if(!mapCourseAccount.containsKey(strCourseName)) 
                    mapCourseAccount.put(strCourseName, new Set<String>());
                mapCourseAccount.get(strCourseName).add(a.Id);
                
                //if(mapAccIdCourses.containsKey(a.Id)) mapAccIdCourses.get(a.Id).add(strCourseName);        
            }
        }
    }
    
    private static void filterAccountsUpdate(Map<Id, Account> mapNewAccount, Map<Id, Account> mapOldAccount){
        for(Account a : mapNewAccount.values()){
            strAcc.put(a.Id, a);
            for(PB_Course__c pbCourse : mcs.values()){
                String strCourseName = pbCourse.Course_API_Name__c.trim();
                 if( (a.get(strCourseName) != mapOldAccount.get(a.Id).get(strCourseName)) ){
                    if(!mapAccIdCourses.containsKey(a.Id)){
                        mapAccIdCourses.put(a.Id, new List<String>());
                    }
                    if(!mapCourseAccount.containsKey(strCourseName)) 
                        mapCourseAccount.put(strCourseName, new Set<String>());
                    mapCourseAccount.get(strCourseName).add(a.Id);
                    if(mapAccIdCourses.containsKey(a.Id))
                        mapAccIdCourses.get(a.Id).add(strCourseName);
                    if(strCourseName != 'PB_ScalpingClass_Summary_CLIENT__c' && strCourseName != 'PB_UTP_Summary_Client__c'){
                        if (a.get(strCourseName) == True) courseAPI.add(strCourseName);
                        else{
                            if(! mapAccIdCoursesDisbable.containsKey(a.Id)) mapAccIdCoursesDisbable.put(a.Id, new Set<String>());
                            mapAccIdCoursesDisbable.get(a.Id).add(strCourseName);
                        }
                        
                    }
                    if ((strCourseName == 'PB_ScalpingClass_Summary_CLIENT__c' || strCourseName == 'PB_UTP_Summary_Client__c')){
                        if (a.get(strCourseName) == 'Purchased') courseAPI.add(strCourseName); 
                        else {
                            if(! mapAccIdCoursesDisbable.containsKey(a.Id)) mapAccIdCoursesDisbable.put(a.Id, new Set<String>());
                            mapAccIdCoursesDisbable.get(a.Id).add(strCourseName);
                        }
                    }     
                }
            }
        }
    }
    
    private static void insertEnrollments(){
        /*List<Enrollment__c> lstEnrollment = new List<Enrollment__c>();
        Map<String, String> mapCourseNameId = getMapCourseNameId();
        for(String strCourseKey : mapCourseAccount.keySet()){
            for(String s : mapCourseAccount.get(strCourseKey)){
                if(courseAPI.contains(strCourseKey)) {
                    lstEnrollment.add(new Enrollment__c (Account__c = s , Course__c = mapCourseNameId.get(strCourseKey),
                                                     Active__c = true));
                }
            }
        }
        if(lstEnrollment.size() != 0)
            insert lstEnrollment;                    
        
        for(String accId : mapAccIdCourses.keySet()){
            System.debug('###'+mapAccIdCourses.get(accId));
            MoodleCourse.courseAccess(accId, mapAccIdCourses.get(accId));
        }
        */
    }
    
    private static List<Course__c> getCourses(){
        return [SELECT Id, Course_API_Name__c FROM Course__c WHERE Course_API_Name__c IN : mapCourseAccount.keySet()];
    }
    
    private static Map<String, String> getMapCourseNameId(){
        Map<String, String> maptemp = new Map<String, String>();
        if(mapCourseAccount.size() != 0){
            for(Course__c course : getCourses()){
                maptemp.put(course.Course_API_Name__c , course.Id);
            }
        }
        return maptemp;
    }
    
    private static void clearMaps(){
        mapCourseAccount.clear(); 
        mapAccIdCourses.clear(); 
        strAcc.clear();
        courseAPI.clear();
    }
    
    private static void disableEnrollment(){
        List<Enrollment__c> lstEnrollDisable = new List<Enrollment__c>();
        for(Enrollment__c e : [SELECT Id, Course__c, Course__r.Course_API_Name__c, Account__c, Active__c 
                      FROM Enrollment__c WHERE Account__c IN: mapAccIdCoursesDisbable.keySet() AND Active__c = true]){
            if(mapAccIdCoursesDisbable.containsKey(e.Account__c) && 
                 mapAccIdCoursesDisbable.get(e.Account__c).contains(e.Course__r.Course_API_Name__c)){
                 e.Active__c = false;
                 lstEnrollDisable.add(e);      
            }    
        }
        update lstEnrollDisable;
    }
    
}