/**
 *  USPS address controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class USPSAddressController {

    public String inputFirmName { get; set; }
    public String inputAddress1 { get; set; }
    public String inputAddress2 { get; set; }
    public String inputCity { get; set; }
    public String inputState { get; set; }
    public String inputUrbanization { get; set; }
    public String inputZIP5 { get; set; }
    public String inputZIP4 { get; set; }
    public String outputFirmName { get; set; }
    public String outputAddress1 { get; set; }
    public String outputAddress2 { get; set; }
    public String outputCity { get; set; }
    public String outputState { get; set; }
    public String outputUrbanization { get; set; }
    public String outputZIP5 { get; set; }
    public String outputZIP4 { get; set; }
    public String outputMessage { get; set; }
    public Boolean displayOutput { get; set; }

    public USPSAddressController() {
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

    public PageReference verify() {
        if (!CheckRequiredFields()) {
            return null;
        }

        USPS.SubmittedAddress submitted = new USPS.SubmittedAddress();
        submitted.FirmName = inputFirmName;
        submitted.Address1 = inputAddress1;
        submitted.Address2 = inputAddress2;
        submitted.City = inputCity;
        submitted.State = inputState;
        submitted.Urbanization = inputUrbanization;
        submitted.ZIP5 = inputZIP5;
        submitted.ZIP4 = inputZIP4;

        USPS.ProcessedAddress processed = new USPS.ProcessedAddress();

        try {
            USPS.AddressStandardization standardization = new USPS.AddressStandardization();
            processed = standardization.standardize(submitted);
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
        outputUrbanization = processed.Urbanization;
        outputZIP5 = processed.ZIP5;
        outputZIP4 = processed.ZIP4;

        if (String.isEmpty(processed.ErrorDescription)) {
            outputMessage = 'Address Found.';
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
        inputUrbanization = '';
        inputZIP5 = '';
        inputZIP4 = '';
        outputFirmName = '';
        outputAddress1 = '';
        outputAddress2 = '';
        outputCity = '';
        outputState = '';
        outputUrbanization = '';
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
        if (String.isEmpty(inputZIP5)) {
            ApexPages.Message message = new ApexPages.Message(ApexPages.Severity.ERROR, 'ZIP5 is either missing or empty.');
            ApexPages.addMessage(message);
            valid = false;
        }
        return valid;
    }
}