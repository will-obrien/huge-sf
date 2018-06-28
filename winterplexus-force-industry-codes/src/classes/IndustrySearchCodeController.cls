/**
 *  Industry codes search by code controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class IndustrySearchCodeController {

    public String NAICSCode { get; set; }
    public String NAICSDescription { get; set; }
    public String SICCode { get; set; }
    public String SICDescription { get; set; }
    public Boolean displayOutput { get; set; }

    public IndustrySearchCodeController() {
        GetParameters();
        GetNAICSCDescription();
        GetSICDescription();

        displayOutput = false;
        if (!String.isEmpty(SICCode)) {
            displayOutput = true;
        }
    }

    public List<SelectOption> getSICDescriptions() {
        if (NAICSCode == null) {
            return null;
        }

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','-------------------- select one -------------------'));

        List<NAICS__c> naics = [SELECT SIC_Code__c, SIC_Description__c FROM NAICS__c WHERE NAICS_Code_2007__c = :NAICSCode];

        for (Integer i = 0; i < naics.size(); i++) {
            NAICS__c naics_row = naics.get(i);
            options.add(new SelectOption(String.valueOf(naics_row.SIC_Code__c), naics_row.SIC_Description__c));
        }
        return options;
    }

    public PageReference searchNAICSDescription() {
        if (!ValidatePageValues()) {
            return null;
        }
        PageReference redirect = new PageReference('/apex/IndustrySearchCode');
        redirect.setRedirect(true);
        redirect.getParameters().put('nc',NAICSCode);
        return redirect;
    }

    public PageReference SICCodeSelected() {
        PageReference redirect = new PageReference('/apex/IndustrySearchCode');
        redirect.setRedirect(true);
        redirect.getParameters().put('nc',NAICSCode);
        redirect.getParameters().put('sc',SICCode);
        return redirect;
    }

    public PageReference back() {
        PageReference redirect = new PageReference('/apex/IndustryCodes');
        redirect.setRedirect(true);
        return redirect;
    }

    public PageReference clear() {
        NAICSCode = null;
        NAICSDescription = null;
        SICCode = null;
        SICDescription = null;
        displayOutput = false;
        return null;
    }

    private void GetParameters() {
        NAICSCode = System.currentPagereference().getParameters().get('nc');
        SICCode = System.currentPagereference().getParameters().get('sc');
    }

    private void GetNAICSCDescription() {
        List<NAICS__c> naics_list = [SELECT NAICS_Code_2007__c, NAICS_Description_2007__c FROM NAICS__c WHERE NAICS_Code_2007__c = :NAICSCode];
        if (naics_list.size() > 0) {
            NAICSDescription = naics_list.get(0).NAICS_Description_2007__c;
        }
    }

    private void GetSICDescription() {
        List<NAICS__c> naics_list = [SELECT SIC_Code__c, SIC_Description__c FROM NAICS__c WHERE SIC_Code__c = :SICCode];
        if (naics_list.size() > 0) {
            SICDescription = naics_list.get(0).SIC_Description__c;
        }
    }

    private Boolean ValidatePageValues() {
        if (String.isEmpty(NAICSCode)) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter a NAICS code.');
            ApexPages.addMessage(message);
            return false;
        }
        if (!NAICSCode.isNumeric()) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Entered NAICS code is not numeric.');
            ApexPages.addMessage(message);
            return false;
        }

        Integer count = 0;
        for (AggregateResult ar : [SELECT SIC_Code__c FROM NAICS__c WHERE NAICS_Code_2007__c = :NAICSCode GROUP BY SIC_Code__c]) {
            count++;
        }

        if (count < 1) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Entered NAICS code is not valid.');
            ApexPages.addMessage(message);
            return false;
        }
        return true;
    }
}