/**
 *  Industry codes about controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class IndustryAboutController {
    public PageReference back() {
        PageReference redirect = new PageReference('/apex/IndustryCodes');
        redirect.setRedirect(true);
        return redirect;
    }
}