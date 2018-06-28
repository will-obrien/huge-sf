public with sharing class AddUPRedirect {
    public PageReference redirect() {
        PageReference newPageRef = new PageReference('https://www.addup.org');
        return newPageRef;
    }
}