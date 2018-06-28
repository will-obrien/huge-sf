/**
 *  Industry codes menu controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class IndustryCodesController {

    public String method { get; set; }

    public IndustryCodesController() {
        method = '1';
    }

    public PageReference next() {
        PageReference redirect = null;
        if (method.Equals('1')) {
            redirect = new PageReference('/apex/IndustrySearchCode');
        }
        if (method.Equals('2')) {
            redirect = new PageReference('/apex/IndustrySearchSelection');
        }
        if (method.Equals('3')) {
            redirect = new PageReference('/apex/IndustrySearchKeyword');
        }
        if (method.Equals('4')) {
            redirect = new PageReference('/apex/IndustryAbout');
        }
        if (redirect != null) {
            redirect.setRedirect(true);
            return redirect;
        }
        return null;
    }
}