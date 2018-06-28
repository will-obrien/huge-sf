public class Datascub
{
    transient Map<String,Exam_Attempt__c> mapExamAttempts = new Map<String,Exam_Attempt__c>();
    public  string nameFile{get;set;}
    public  List<missingWrapper> lstUnMatchedRecords{get;set;}
    public transient Blob contentFile{get;set;}
    
    public Datascub()
    {
       
           
        
    }
    
    public pageReference getExportData()
    {
        return null;
    }

    public pageReference exportData()
    {
        pageReference pf = new pageReference('/apex/scrubExport?action=Export');
        return pf;

    }
    public  void checkForUnmatchingRecords(List<String> lstCsvContent)
    {
        mapExamAttempts = new Map<String,Exam_Attempt__c>();
        Set<String> setGarpIds = new Set<String>();
        Set<String> setCandidateIds = new Set<String>();
        Set<String> setSites = new Set<String>();
        Set<String> setProducts = new Set<String>();
       //for(Exam_Attempt__c objEA : [select id,Candidate_ID__c,Garp_Id__c,Program__c,Exam_Site__r.Exam_Site_Code__c,Exam_Code__c from Exam_Attempt__c where Exam_Site__r.Exam__r.Exam_Group__r.Active__c =: true and Id =: 'a0Af000000KnX1k'])
        //{
       for(Exam_Attempt__c objEA : [select id,Candidate_ID__c,Opportunity_StageName__c,Section__c,Garp_Id__c,Program__c,Exam_Site__r.Site_code__c,Candidate_Commitment__r.status,Cancelled__c,Exam_Code__c,Defered__c,Exam_Date__c from Exam_Attempt__c where  Cancelled__c != true and Defered__c !='pending' and Exam_Site__r.Exam__r.Exam_Group__r.Name=: Label.Group_Name and Opportunity_StageName__c ='closed'])
       {
            String strUniqueKey = objEA.Garp_Id__c + objEA.Candidate_ID__c + objEA.Exam_Site__r.Site_code__c;
            mapExamAttempts.put(strUniqueKey,objEA);
            setGarpIds.add(objEA.Garp_Id__c);
            setCandidateIds.add(String.valueOf(objEA.Candidate_ID__c));
            setSites.add(objEA.Exam_Site__r.Site_code__c);
            setProducts.add(objEA.Section__c);
        }
        Map<String,Integer> mapRowPositions = new Map<String,Integer>();
        Integer iCount;
        Integer iIterator = 0;
        lstUnMatchedRecords = new List<missingWrapper>();
        system.debug('lstCsvContent == '+lstCsvContent);
        system.debug('lstCsvContent Size== '+lstCsvContent.size());
        for (Integer i=0;i<lstCsvContent.size()-1;i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = lstCsvContent[i].split(',');
            system.debug('Iterator == '+i);
            if(i == 0)
            {
                for(Integer iHeader=0;iHeader<inputvalues.size();iHeader++)
                mapRowPositions.put(inputvalues[iHeader].trim(),iHeader);
                
            }
            else
            {
                system.debug('mapRowPositions == '+mapRowPositions);
                system.debug('inputvalues == '+inputvalues);

                String strUniqueKey = inputvalues[mapRowPositions.get('GARP ID')].trim()+ inputvalues[mapRowPositions.get('Candidate ID')].trim() + inputvalues[mapRowPositions.get('Site')].trim();// + inputvalues[mapRowPositions.get('Product')].trim();
                system.debug('strUniqueKey == '+strUniqueKey);
                String garpId =  inputvalues[mapRowPositions.get('GARP ID')].trim();
                String candId =  inputvalues[mapRowPositions.get('Candidate ID')].trim();
                String site =  inputvalues[mapRowPositions.get('Site')].trim();
                //String product =  inputvalues[mapRowPositions.get('Product')].trim();
                String section = '';
                system.debug('mapExamAttempts == '+mapExamAttempts.size());
                if(mapExamAttempts.size() <=0 || mapExamAttempts.get(strUniqueKey) == null)
                {
                    if(setGarpIds != null && !setGarpIds.contains(garpId))
                        section = garpId;
                    else  if(setCandidateIds != null && !setCandidateIds.contains(candId))
                        section = candId;
                    else  if(setSites != null && !setSites.contains(site))
                        section = site;
                   // else  if(setProducts != null && !setProducts.contains(product))
                       // section = garpId;
                    lstUnMatchedRecords.add(new missingWrapper(inputvalues[mapRowPositions.get('GARP ID')].trim(),inputvalues[mapRowPositions.get('Candidate ID')].trim(),inputvalues[mapRowPositions.get('Site')].trim(),section));
                    
                }}}}
   
    public pageReference compareData()
    {
        system.debug('contentFile == '+contentFile);
        checkForUnmatchingRecords(contentFile.toString().split('[\n\r]'));
        system.debug('lstUnMatchedRecords == '+lstUnMatchedRecords);
        return null;
    
    }
    public class missingWrapper
    {
        public String strGarpId{get;set;}
        public String strCandId{get;set;}
        public String strSiteCode{get;set;}
        public String strProductCode{get;set;}
        public String section{get;set;}
        
    public missingWrapper(String strGPID,String strCID,String strSCode,String sectionVal)
        {
            strGarpId = strGPID;
            strCandId = strCID;
            strSiteCode = strSCode;
            //strProductCode = strPCode;
            section = sectionVal;
        }}
    
    
    }