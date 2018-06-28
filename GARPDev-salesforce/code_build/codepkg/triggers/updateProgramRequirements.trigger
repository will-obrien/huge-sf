trigger updateProgramRequirements on Exam_Attempt__c (before insert,before update) {
/*
      thsi is only requried when we are loading data*/
    /* 
    List<Id> lstContracts = new List<Id>();
    for(Exam_Attempt__c obj : trigger.new)
    {
        system.debug('EA : '+obj.Section__c);
        lstContracts.add(obj.Candidate_Commitment__c);
        
    }
    
    Map<String,Candidate_Requirement__c> mapProgRequirements = new Map<String,Candidate_Requirement__c>();
    for(Candidate_Requirement__c objCR : [select id,name,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__c in: lstContracts])
    {
        mapProgRequirements.put(objCR.Name+'&'+objCR.Candidate_Commitment__c,objCR);
    }
    system.debug('mapProgRequirements == '+mapProgRequirements);
    for(Exam_Attempt__c obj : trigger.new)
    {   
        String strSection = '';
        if(obj.Section__c == 'FRM Part 1')
            strSection = 'FRM PART 1';
        else if(obj.Section__c == 'FRM Part 2')
            strSection = 'FRM PART 2';
        else if(obj.Section__c == 'ERP')
            strSection = 'PASS ERP';
        else if(obj.Section__c == 'Icbrr Part I')
            strSection = 'PASS ICBRR';
        else if(obj.Section__c == 'Icbrr Part II')
            strSection = 'PASS ICBRR';
        else if(obj.Section__c == 'ICBRR')
            strSection = 'PASS ICBRR';
       
        system.debug('strSection == '+strSection);
        try
        {
            if(obj.Cancelled__c)
            {
                if(mapProgRequirements.containsKey('FRM FULL'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('FRM FULL'+'&'+obj.Candidate_Commitment__c).Id;
                else if(mapProgRequirements.containsKey('FRM Part 1'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('FRM Part 1'+'&'+obj.Candidate_Commitment__c).Id;
                else if(mapProgRequirements.containsKey('FRM PART 2'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('FRM PART 2'+'&'+obj.Candidate_Commitment__c).Id;
                else if(mapProgRequirements.containsKey('PASS ERP'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('PASS ERP'+'&'+obj.Candidate_Commitment__c).Id;
            }
            else
            {
                if(obj.Section__c == 'FRM FULL Program' && mapProgRequirements.containsKey('FRM FULL'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('FRM FULL'+'&'+obj.Candidate_Commitment__c).Id;
                else if(obj.Section__c == 'FRM FULL Program' && mapProgRequirements.containsKey('FRM PART 1'+'&'+obj.Candidate_Commitment__c))
                    obj.Candidate_Requirement__c = mapProgRequirements.get('FRM PART 1'+'&'+obj.Candidate_Commitment__c).Id;
                else
                    obj.Candidate_Requirement__c = mapProgRequirements.get(strSection+'&'+obj.Candidate_Commitment__c).Id;
            }
        }
        catch(exception ex)
        {
            obj.addError(ex.getMessage());
        }
    }
    
*/
}