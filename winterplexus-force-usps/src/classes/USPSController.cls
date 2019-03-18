/**
 *  USPS controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class USPSController {

    public String option { get; set; }

    public USPSController() {
        System.LoggingLevel level = LoggingLevel.DEBUG;
        option = '1';
    }

    public PageReference next() {
        PageReference redirect = null;
        if (option.Equals('1')) {
            redirect = new PageReference('/apex/USPSAddress');
        }
        if (option.Equals('2')) {
            redirect = new PageReference('/apex/USPSZIPCodeSearch');
        }
        if (option.Equals('3')) {
            redirect = new PageReference('/apex/USPSCityStateSearch');
        }
        if (option.Equals('4')) {
            redirect = new PageReference('/apex/USPSAbout');
        }
        if (redirect != null) {
            redirect.setRedirect(true);
            return redirect;
        }
        return null;
    }
}