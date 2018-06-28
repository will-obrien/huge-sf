/**
 *  Industry codes search by selection controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class IndustrySearchSelectionController {

    public String industrySector { get; set; }
    public String industrySubsector { get; set; }
    public String NAICSCode { get; set; }
    public String NAICSDescription { get; set; }
    public String SICCode { get; set; }
    public String SICDescription { get; set; }
    public Boolean displayOutput { get; set; }

    public IndustrySearchSelectionController() {
        GetParameters();
        GetNAICSCDescription();
        GetSICDescription();

        displayOutput = false;
        if (!String.isEmpty(SICCode)) {
            displayOutput = true;
        }
    }

    public List<SelectOption> getIndustrySectors() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','-------------------- select one -------------------'));

        try {
            Integer i = 0;
            for (AggregateResult ar : [SELECT Industry_Sector__c FROM NAICS__c GROUP BY Industry_Sector__c]) {
                if (ar.get('Industry_Sector__c') != null) {
                    options.add(new SelectOption(String.valueOf(++i), (String)ar.get('Industry_Sector__c')));
                }
            }
        }
        catch (System.Exception e) {
            System.debug(logginglevel.DEBUG, '# unable to industry sectors: ' + e.getMessage());
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error: '+ e.getMessage());
            ApexPages.addMessage(message);
        }
        return options;
    }

    public PageReference industrySectorSelected() {
        SICCode = null;
        NAICSCode = null;
        industrySubsector = null;

        PageReference redirect = new PageReference('/apex/IndustrySearchSelection');
        redirect.setRedirect(true);
        redirect.getParameters().put('is',industrySector);
        return redirect;
    }

    public List<SelectOption> getIndustrySubsectors() {
        if (industrySector == null) {
            return null;
        }

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','-------------------- select one -------------------'));

        try {
            Integer i = 0;
            for (AggregateResult ar : [SELECT Industry_Subsector__c FROM NAICS__c WHERE Industry_Sector__c = :GetIndustrySector() GROUP BY Industry_Subsector__c]) {
                if (ar.get('Industry_Subsector__c') != null) {
                    options.add(new SelectOption(String.valueOf(++i), (String)ar.get('Industry_Subsector__c')));
                }
            }
        }
        catch (System.Exception e) {
            System.debug(logginglevel.DEBUG, '# unable to industry subsectors: ' + e.getMessage());
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error: '+ e.getMessage());
            ApexPages.addMessage(message);
        }
        return options;
    }

    public PageReference industrySubsectorSelected() {
        SICCode = null;
        NAICSCode = null;

        PageReference redirect = new PageReference('/apex/IndustrySearchSelection');
        redirect.setRedirect(true);
        redirect.getParameters().put('is',industrySector);
        redirect.getParameters().put('ic',industrySubsector);
        return redirect;
    }

    public List<SelectOption> getNAICSDescriptions() {
        if (industrySubsector == null) {
            return null;
        }

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','-------------------- select one -------------------'));

        try {
            Integer i = 0;
            for (AggregateResult ar : [SELECT NAICS_Code_2007__c, NAICS_Description_2007__c FROM NAICS__c WHERE Industry_Subsector__c = :GetIndustrySubsector() GROUP BY NAICS_Description_2007__c, NAICS_Code_2007__c]) {
                if ((ar.get('NAICS_Code_2007__c') != null) && (ar.get('NAICS_Code_2007__c') != null) && (ar.get('NAICS_Description_2007__c') != null)) {
                    options.add(new SelectOption((String)ar.get('NAICS_Code_2007__c'), (String)ar.get('NAICS_Code_2007__c') + ' - ' + (String)ar.get('NAICS_Description_2007__c')));
                }
            }
            options.sort();
        }
        catch (System.Exception e) {
            System.debug(logginglevel.DEBUG, '# unable to NAICS descriptions: ' + e.getMessage());
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error: '+ e.getMessage());
            ApexPages.addMessage(message);
        }
        return options;
    }

    public PageReference NAICSCodeSelected() {
        SICCode = null;

        PageReference redirect = new PageReference('/apex/IndustrySearchSelection');
        redirect.setRedirect(true);
        redirect.getParameters().put('is',industrySector);
        redirect.getParameters().put('ic',industrySubsector);
        redirect.getParameters().put('nc',NAICSCode);
        return redirect;
    }

    public List<SelectOption> getSICDescriptions() {
        if (NAICSCode == null) {
            return null;
        }

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','-------------------- select one -------------------'));

        try {
            List<NAICS__c> naics = [SELECT SIC_Code__c, SIC_Description__c FROM NAICS__c WHERE NAICS_Code_2007__c = :NAICSCode];

            for (Integer i = 0; i < naics.size(); i++) {
                NAICS__c naics_row = naics.get(i);
                options.add(new SelectOption(String.valueOf(naics_row.SIC_Code__c), String.valueOf(naics_row.SIC_Code__c) + ' - ' + naics_row.SIC_Description__c));
            }
            options.sort();
        }
        catch (System.Exception e) {
            System.debug(logginglevel.DEBUG, '# unable to SIC descriptions: ' + e.getMessage());
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Unexpected error: '+ e.getMessage());
            ApexPages.addMessage(message);
        }
        return options;
    }

    public PageReference SICCodeSelected() {
        PageReference redirect = new PageReference('/apex/IndustrySearchSelection');
        redirect.setRedirect(true);
        redirect.getParameters().put('is',industrySector);
        redirect.getParameters().put('ic',industrySubsector);
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
        industrySector = null;
        industrySubsector = null;
        NAICSCode = null;
        NAICSDescription = null;
        SICCode = null;
        SICDescription = null;
        displayOutput = false;
        return null;
    }

    private void GetParameters() {
        industrySector = System.currentPagereference().getParameters().get('is');
        industrySubsector = System.currentPagereference().getParameters().get('ic');
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

    private String GetIndustrySector() {
        if (industrySector != null) {
            Integer index = Integer.valueOf(industrySector);
            Integer i = 0;
            for (AggregateResult ar : [SELECT Industry_Sector__c FROM NAICS__c GROUP BY Industry_Sector__c]) {
                if (index == ++i) {
                    String industrySectorValue = (String)ar.get('Industry_Sector__c');
                    System.debug(logginglevel.DEBUG, '# get industry subsector: industrySectorValue = ' + industrySectorValue);
                    return industrySectorValue;
                }
            }
        }
        return null;
    }

    private String GetIndustrySubsector() {
        if (industrySector != null) {
            Integer index = Integer.valueOf(industrySubsector);
            Integer i = 0;
            for (AggregateResult ar : [SELECT Industry_Subsector__c FROM NAICS__c WHERE Industry_Sector__c = :GetIndustrySector() GROUP BY Industry_Subsector__c]) {
                if (index == ++i) {
                    String industrySubsectorValue = (String)ar.get('Industry_Subsector__c');
                    System.debug(logginglevel.DEBUG, '# get industry subsector: industrySubsectorValue = ' + industrySubsectorValue);
                    return industrySubsectorValue;
                }
            }
        }
        return null;
    }
}