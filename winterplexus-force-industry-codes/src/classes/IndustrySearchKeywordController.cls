/**
 *  Industry codes search by keyword controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class IndustrySearchKeywordController {

    static final Integer LIMIT_SIZE = 5;

    public String keyword { get; set; }
    public String codeType { get; set; }
    public String codeId { get; set; }
    public String searchResultsCount { get; set; }
    public Boolean NAICSOutput { get; set; }
    public Boolean displayOutput { get; set; }

    public IndustrySearchKeywordController() {
        codeType = '1';
        NAICSOutput = true;
    }

    public PageReference searchKeyword() {
        if (!CheckRequiredFields()) {
            return null;
        }
        SetCodeType();
        GetRecordsCount();
        SetOutputParameters();
        return null;
    }

    public PageReference changeCodeType() {
        SetCodeType();
        GetRecordsCount();
        offsetSize = 0;
        SetOutputParameters();
        return null;
    }

    public List<naics__c> getNAICS() {
        if (!CheckRequiredFields()) {
            return null;
        }
        return GetRecords();
    }

    public void first() {
        offsetSize = 0;
    }

    public void previous() {
        offsetSize = offsetSize - LIMIT_SIZE;
    }

    public boolean getpreviousvalid() {
        if (offsetSize == 0) {
            return true;
        }
        else {
            return false;
        }
    }

    public void next() {
        offsetSize = offsetSize + LIMIT_SIZE;
    }

    public boolean getnextvalid() {
        if ((offsetSize + LIMIT_SIZE) >= totalRecordsCount) {
            return true;
        }
        else {
            return false;
        }
    }

    public void last() {
        offsetSize = totalRecordsCount - Math.mod(totalRecordsCount, LIMIT_SIZE);
    }

    public PageReference selectRow() {
        if (codeId == null || String.isEmpty(codeId)) {
            return null;
        }

        PageReference redirect = new PageReference('/apex/IndustrySearchCode?nc=' + GetNAICSCode());
        redirect.setRedirect(true);
        return redirect;
    }

    public PageReference back() {
        PageReference redirect = new PageReference('/apex/IndustryCodes');
        redirect.setRedirect(true);
        return redirect;
    }

    public PageReference clear() {
        keyword = '';
        codeType = '1';
        codeId = '';
        searchResultsCount = '';
        displayOutput = false;
        totalRecordsCount = 0;
        offsetSize = 0;
        return null;
    }

    private integer totalRecordsCount = 0;
    private integer offsetSize = 0;

    private void SetCodeType() {
        if (codeType.equals('1')) {
            NAICSOutput = true;
        }
        if (codeType.equals('2')) {
            NAICSOutput = false;
        }
     }

    private Boolean CheckRequiredFields() {
        Boolean valid = true;

        if (String.isEmpty(keyword)) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Keyword is either missing or non-existent.');
            ApexPages.addMessage(message);
            valid = false;
        }
        return valid;
    }

    private List<NAICS__c> GetRecords() {
        List<NAICS__c> naics;

        try {
            if (NAICSOutput == true) {
                naics = Database.Query('SELECT NAICS_Code_2007__c, SIC_Code__c, NAICS_Description_2007__c FROM naics__c WHERE NAICS_Description_2007__c LIKE \'%' + String.escapeSingleQuotes(keyword) + '%\' LIMIT :LIMIT_SIZE OFFSET :offsetSize');
            }
            if (NAICSOutput == false) {
                naics = Database.Query('SELECT NAICS_Code_2007__c, SIC_Code__c, SIC_Description__c FROM naics__c WHERE SIC_Description__c  LIKE \'%' + String.escapeSingleQuotes(keyword) + '%\' LIMIT :LIMIT_SIZE OFFSET :offsetSize');
            }
        }
        catch (System.Exception e) {
            System.debug(logginglevel.DEBUG, '# unable to get records: (NAICS output = ' + NAICSOutput + '): ' + e.getMessage());
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error: '+ e.getMessage());
            ApexPages.addMessage(message);
        }
        return naics;
    }

    private void GetRecordsCount() {
        List<NAICS__c> naics;

        try {
            if (NAICSOutput == true) {
                naics = Database.Query('SELECT NAICS_Code_2007__c, SIC_Code__c, NAICS_Description_2007__c FROM naics__c WHERE NAICS_Description_2007__c LIKE \'%' + String.escapeSingleQuotes(keyword) + '%\'');
            }
            if (NAICSOutput == false) {
                naics = Database.Query('SELECT NAICS_Code_2007__c, SIC_Code__c, SIC_Description__c FROM naics__c WHERE SIC_Description__c  LIKE \'%' + String.escapeSingleQuotes(keyword) + '%\'');
            }
        }
        catch (System.Exception e) {
            System.debug(logginglevel.DEBUG, '# unable to get records count: (NAICS output = ' + NAICSOutput + '): ' + e.getMessage());
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error: '+ e.getMessage());
            ApexPages.addMessage(message);
        }

        if (naics != null) {
            totalRecordsCount = naics.size();
        }
    }

    private String GetNAICSCode() {
        List<NAICS__c> naics;

        try {
            naics = Database.Query('SELECT NAICS_Code_2007__c FROM naics__c WHERE Id = \'' + String.escapeSingleQuotes(codeId) + '\'');
        }
        catch (System.Exception e) {
            System.debug(logginglevel.DEBUG, '# unable to get NAICS code (' + codeId + '): ' + e.getMessage());
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error: '+ e.getMessage());
            ApexPages.addMessage(message);
        }

        if (naics == null || naics.size() < 1) {
            return null;
        }
        return naics.get(0).NAICS_Code_2007__c;
    }

    private void SetOutputParameters() {
        searchResultsCount = String.valueOf(totalRecordsCount);
        displayOutput = true;
    }
}