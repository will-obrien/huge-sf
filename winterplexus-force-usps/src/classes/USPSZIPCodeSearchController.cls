/**
 *  USPS ZIP code search controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class USPSZIPCodeSearchController {

    public String inputFirmName { get; set; }
    public String inputAddress1 { get; set; }
    public String inputAddress2 { get; set; }
    public String inputCity { get; set; }
    public String inputState { get; set; }
    public String outputFirmName { get; set; }
    public String outputAddress1 { get; set; }
    public String outputAddress2 { get; set; }
    public String outputCity { get; set; }
    public String outputState { get; set; }
    public String outputZIP5 { get; set; }
    public String outputZIP4 { get; set; }
    public String outputMessage { get; set; }
    public Boolean displayOutput { get; set; }

    public USPSZIPCodeSearchController() {
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
        submitted.FirmName = inputFirmName;
        submitted.Address1 = inputAddress1;
        submitted.Address2 = inputAddress2;
        submitted.City = inputCity;
        submitted.State = inputState;

        USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

        try {
            USPS.ZIPCodeSearch codeSearch = new USPS.ZIPCodeSearch();
            processed = codeSearch.search(submitted);
        }
        catch (USPS.USPSException e) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
            ApexPages.addMessage(message);
            return null;
        }

        outputFirmName = processed.FirmName;
        outputAddress1 = processed.Address1;
        outputAddress2 = processed.Address2;
        outputCity = processed.City;
        outputState = processed.State;
        outputZIP5 = processed.ZIP5;
        outputZIP4 = processed.ZIP4;

        if (String.isEmpty(processed.ErrorDescription)) {
            outputMessage = 'ZIP Code Found.';
        }
        else {
            outputMessage = processed.ErrorDescription;
        }

        displayOutput = true;
        return null;
    }

    public PageReference clear() {
        inputFirmName = '';
        inputAddress1 = '';
        inputAddress2 = '';
        inputCity = '';
        inputState = '';
        outputFirmName = '';
        outputAddress1 = '';
        outputAddress2 = '';
        outputCity = '';
        outputState = '';
        outputZIP5 = '';
        outputZIP4 = '';
        outputMessage = '';
        displayOutput = false;
        return null;
    }

    private Boolean CheckRequiredFields() {
        Boolean valid = true;

        if (String.isEmpty(inputAddress2)) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'Address line 2 is either missing or empty.');
            ApexPages.addMessage(message);
            valid = false;
        }
        if (String.isEmpty(inputCity)) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'City is either missing or empty.');
            ApexPages.addMessage(message);
            valid = false;
        }
        if (String.isEmpty(inputState)) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'State is either missing or empty.');
            ApexPages.addMessage(message);
            valid = false;
        }
        return valid;
    }
}