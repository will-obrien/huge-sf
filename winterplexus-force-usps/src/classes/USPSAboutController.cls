/**
 *  USPS about controller class.
 *
 *  Copyright (c) 2014-17 Wiregrass Cloud Technology
 */
public with sharing class USPSAboutController { 
    public PageReference back() {
        PageReference redirect = new PageReference('/apex/USPS');
        redirect.setRedirect(true);
        return redirect;
    }
}