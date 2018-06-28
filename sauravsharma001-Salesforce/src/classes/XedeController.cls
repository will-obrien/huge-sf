public virtual with sharing class XedeController extends XedeObject {
    public class SimpleMessage
    {
        SimpleMessage(ApexPages.Message aMessage)
        {
            myMessage = aMessage;
        }
        
        public string getDetail() { return myMessage.getDetail(); }
        public string getSummary() { return myMessage.getSummary(); }
        public string getSeverity() { return '' + myMessage.getSeverity(); }
        
        ApexPages.Message myMessage;
    }
    
    protected PageReference currentPage() {
        PageReference aPage = ApexPages.currentPage();
        
        if (aPage != null)
            return aPage;
        
        return Page.blank;
    }
    
    public list<SimpleMessage> getApexMessages() {  
        boolean showInfoMessages = isDebugEnabled();
        
        list<SimpleMessage> messageList = new list<SimpleMessage>();
        for (ApexPages.Message each : ApexPages.getMessages())
        {
            if (each.getSeverity() == ApexPages.Severity.INFO)
                if (showInfoMessages == false)
                    continue;
                
            messageList.add(new SimpleMessage(each));
        }
        return messageList;
    }
    
    public boolean getHasMessages() {
        boolean showInfoMessages = isDebugEnabled();
        
        for (ApexPages.Message each : ApexPages.getMessages()) {
            if (each.getSeverity() == ApexPages.Severity.Info) {
                if (showInfoMessages)
                    return true;
                    
                continue;
            }
            else
                return true;
        }
        
        return false;
    }
    
    boolean isDebugEnabled()
    {
        Cookie aCookie;
        
        if (currentPage().getParameters().get('DEBUG') != null)
            return true;
        
        aCookie = currentPage().getCookies().get('DEBUG');
        if (aCookie != null)
            return true;
        
        return false;       
    }
    
    protected virtual void loadModelFromProxies() {}
    protected virtual void loadProxiesFromModel() {}
    
    public PageReference redrawCurrentPage() { return redrawCurrentPage(null); }
    public PageReference redrawCurrentPage(string anAnchor){
        if (getHasMessages())
            return null;
            
        PageReference currentPage = currentPage();
        String currentUrl = currentPage.getUrl();
        
        integer hookIndex = currentUrl.indexOf('?');
        String fixedUrl = hookIndex > 0 ? currentUrl.substring(0, hookIndex) : currentUrl;
        
        PageReference pg = new PageReference(fixedUrl);
        
        for (String each : pageParameters.keySet())
            if (each != 'anchor')
                pg.getParameters().put(each, pageParameters.get(each));
        
        if (anAnchor != null)
            pg.setAnchor(anAnchor);
    
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference setCookie(PageReference aPage, string name, string value)
    {
        Cookie aCookie = new Cookie(name, value, null, -1, false);
        aPage.setCookies(new Cookie[] { aCookie });
        aPage.setRedirect(true);
        return aPage;
    }
    
    public XedeController()
    {
        pageParameters = currentPage().getParameters().clone();
        pageAnchor = currentPage().getAnchor();
        pageHeaders = currentPage().getHeaders().clone();
    }
    
    public XedeController(object anObject) { super(); }
    
    protected map<string, string> pageHeaders { get; private set; } { pageHeaders = new map<string, string>(); }
    protected map<string, string> pageParameters { get; private set; } { pageParameters = new map<string, string>(); }
    protected string pageAnchor { get; private set; } { pageAnchor = ''; }
}