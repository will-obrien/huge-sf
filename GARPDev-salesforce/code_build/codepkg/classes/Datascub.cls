public class Datascub
{
    Map<String,Exam_Attempt__c> mapExamAttempts = new Map<String,Exam_Attempt__c>();
    public string nameFile{get;set;}
    public List<missingWrapper> lstUnMatchedRecords{get;set;}
    public Blob contentFile{get;set;}
    public Datascub()
    {
       
        
    }
    public void checkForUnmatchingRecords(List<String> lstCsvContent)
    {
        mapExamAttempts = new Map<String,Exam_Attempt__c>();
        for(Exam_Attempt__c objEA : [select id,Candidate_ID__c,Garp_Id__c,Program__c,Exam_Site__r.Exam_Site_Code__c,Exam_Code__c from Exam_Attempt__c where Exam_Site__r.Exam__r.Exam_Group__r.Active__c =: true and Id =: 'a0Af000000KnX1k'])
        {
            String strUniqueKey = objEA.Garp_Id__c + objEA.Candidate_ID__c + objEA.Exam_Site__r.Exam_Site_Code__c + objEA.Exam_Code__c;
            mapExamAttempts.put(strUniqueKey,objEA);
        }
        Map<String,Integer> mapRowPositions = new Map<String,Integer>();
        Integer iCount;
        Integer iIterator = 0;
        lstUnMatchedRecords = new List<missingWrapper>();
        for (Integer i=0;i<lstCsvContent.size();i++)
        {
            String[] inputvalues = new String[]{};
            inputvalues = lstCsvContent[i].split(',');
            if(i == 0)
            {
                for(Integer iHeader=0;iHeader<inputvalues.size();iHeader++)
                mapRowPositions.put(inputvalues[iHeader].trim(),iHeader);
                
            }
            else
            {
                String strUniqueKey = inputvalues[mapRowPositions.get('GARP ID')].trim()+ inputvalues[mapRowPositions.get('Candidate ID')].trim() + inputvalues[mapRowPositions.get('Site')].trim() + inputvalues[mapRowPositions.get('Product')].trim();
           if(mapExamAttempts.get(strUniqueKey) == null)
                {
                    lstUnMatchedRecords.add(new missingWrapper(inputvalues[mapRowPositions.get('GARP ID')].trim(),inputvalues[mapRowPositions.get('Candidate ID')].trim(),inputvalues[mapRowPositions.get('Site')].trim(),inputvalues[mapRowPositions.get('Product')].trim()));
                    
                }}}}
    public class missingWrapper
    {
        public String strGarpId{get;set;}
        public String strCandId{get;set;}
        public String strSiteCode{get;set;}
        public String strProductCode{get;set;}
        
    public missingWrapper(String strGPID,String strCID,String strSCode,String strPCode)
        {
            strGarpId = strGPID;
            strCandId = strCID;
            strSiteCode = strSCode;
            strProductCode = strPCode;
        }}
    public pageReference compareData()
    {
        checkForUnmatchingRecords(contentFile.toString().split('\n'));
        return null;
    
    }}