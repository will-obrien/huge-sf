/*
Developer      : Keerthi Chandra
Date           : 5-20-2016
Status         : Developed
Description    : Success Page.
*/
public with sharing class SuccessPageCntrlr {

   // To hold the recordId
   public String strRec {get; set;}
   
    ///<OBJECTIVE>
    /// page redirect to home page.
    ///</OBJECTIVE>
    public PageReference bckToHm() {
        PageReference pageRef = new PageReference(system.label.HomePageURL);
        pageRef.setRedirect(false);
        return pageRef;  
    }

    ///<OBJECTIVE>
    /// page redirect to record detail page.
    ///</OBJECTIVE>
    public PageReference goToRcrd() {
    strRec = ApexPages.currentPage().getParameters().get('Id');
        PageReference pageRef = new PageReference(System.Label.RecordUrl+strRec);
        pageRef.setRedirect(false);
        return pageRef;  
    }

}