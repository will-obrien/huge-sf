/**
 *  USPS city/state search controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class USPSCityStateSearchController {

    public String inputZIP5 { get; set; }
    public String outputCity { get; set; }
    public String outputState { get; set; }
    public String outputZIP5 { get; set; }
    public String outputMessage { get; set; }
    public Boolean displayOutput { get; set; }

    public USPSCityStateSearchController() {
        displayOutput = false;
    }

    public List<SelectOption> getStates() {
        return USPSStaticData.getStates();
    }

    public PageReference back() {
        PageReference redirect = new PageReference('/apex/USPS');
        redirect.setRedirect(true);
        return redirect;
    }

    public PageReference search() {
        if (!CheckRequiredFields()) {
            return null;
        }

        USPS.SubmittedAddress submitted = new USPS.SubmittedAddress();
        submitted.ZIP5 = inputZIP5;

        USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

        try {
            USPS.CityStateSearch cityStateSearch = new USPS.CityStateSearch();
            processed = cityStateSearch.search(submitted);
        }
        catch (USPS.USPSException e) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(message);
            return null;
        }

        outputCity = processed.City;
        outputState = processed.State;
        outputZIP5 = processed.ZIP5;

        if (String.isEmpty(processed.ErrorDescription)) {
            outputMessage = 'City/State Found.';
        }
        else {
            outputMessage = processed.ErrorDescription;
        }

        displayOutput = true;
        return null;
    }

    public PageReference clear() {
        inputZIP5 = '';
        outputCity = '';
        outputState = '';
        outputZIP5 = '';
        outputMessage = '';
        displayOutput = false;
        return null;
    }

    private Boolean CheckRequiredFields() {
        Boolean valid = true;

        if (String.isEmpty(inputZIP5)) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP5 is either missing or empty.');
            ApexPages.addMessage(message);
            valid = false;
        }
        return valid;
    }
}