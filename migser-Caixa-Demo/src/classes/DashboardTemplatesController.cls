public class DashboardTemplatesController {

    private String org;
    private String sid; // TODO: sid: set first time, and pass back to controller via cookie or parameter    
    private String organizationId;
    private String dashboardId = '';
    private String dashboardColorPalette; // array of colors used in dashboard
    private String dashboardColorWidgetPalette; // 
    private String dashboardWidgetOrigColor;
    private String folders;
    
    // Think of a better way to ID, especially if multiple image replacements needed
    private String dashboardLogoBoxToken = 'Logo_box'; 
    private boolean dashboardLogoBoxExists;
    private Blob dashboardLogo; // just one for now
    private String dashboardLogoName;
    private String dashboardLogoId;    

    public String   getOrg()                            		{ return org; }
    public void     setOrg(String o)                   			{ org = o; }
    public String   getSid()                           			{ return sid; }
    public void     setSid(String id)                  			{ sid = id; }    
    public String   getDashboardId()                            { return dashboardId; }
    public void     setDashboardId(String id)                   { dashboardId = id; }              
    public String   getOrganizationId()                         { return organizationId; }
    public void     setOrganizationId(String id)                { organizationId = id; }                  
    public String   getDashboardColorPalette()                  { return dashboardColorPalette; }
    public void     setDashboardColorPalette(String color)      { dashboardColorPalette = color; }     
    public String   getDashboardColorWidgetPalette()            { return dashboardColorWidgetPalette; }
    public void     setDashboardColorWidgetPalette(String color){ dashboardColorWidgetPalette = color; }     
    public String   getDashboardWidgetOrigColor()               { return dashboardWidgetOrigColor; }
    public void     setDashboardWidgetOrigColor(String color)   { dashboardWidgetOrigColor = color; }    
    public String   getFolders()                        	    { return folders; }
    public void     setFolders(String f)  		                { folders = f; }     
    public boolean  getDashboardLogoBoxExists()                 { return dashboardLogoBoxExists; }
    public void     setDashboardLogoBoxExists(boolean exists)   { dashboardLogoBoxExists = exists; } 
    public Blob     getDashboardLogo()                          { return dashboardLogo; }
    public void     setDashboardLogo(Blob logo)                 { dashboardLogo = logo; } 
    public String   getDashboardLogoName()                      { return dashboardLogoName; }
    public void     setDashboardLogoName(String logoName)       { dashboardLogoName = logoName; } 
    public String   getDashboardLogoId()                        { return dashboardLogoId; }
    public void     setDashboardLogoId(String id)               { dashboardLogoId = id; }      

    private String URL_LENS_API = '/insights/internal_api/v1.0/esObject/lens';        
    private String URL_LENS_APEX = '/analytics/wave/web/lens.apexp';
    private String URL_FOLDERS_API = '/services/data/v36.0/wave/folders';        
    private String URL_TOKEN_DASHBOARD_ID = 'dashboardId';
    private String URL_TOKEN_LOGO_ID = 'logoId';
    private String IMAGE_FOLDER_LOCATION = 'Shared Documents';
    private List<String> widgetColorParams = new List<String> {'textColor', 'borderColor', 'backgroundColor'};

    public DashboardTemplatesController() {
        String forwardedHeader = ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
        org = 'https://' + ((forwardedHeader == null) ? ApexPages.currentPage().getHeaders().get('host') : forwardedHeader);        
        sid = UserInfo.getSessionId();
        
        if(!test.isRunningTest()) {
            folders = getFolders(sid); // OK to use this one for public REST API            
            sid = getSessionIdFromLensApex(); 
        }
        
        dashboardId = Apexpages.currentPage().getParameters().get(URL_TOKEN_DASHBOARD_ID);
        dashboardLogoId = Apexpages.currentPage().getParameters().get(URL_TOKEN_LOGO_ID);
        organizationId = UserInfo.getOrganizationId();
    }
    
    // This is a bit of a hack. Remove once dashboard public API is available
    // lens.apexp contains the OAuth token
    // UserInfo.getSessionId() is not a first-class token in unmanaged packages
    // so it will fail for the /insights... "private" API calls    
    public String getSessionIdFromLensApex() {
        String homeContent;
        PageReference home = new PageReference(org + URL_LENS_APEX);

        if(test.isRunningTest()) {
            homeContent = 'Some random string';
        } else {
        	blob homeblob = home.getContent();            
            homeContent = homeblob.toString();
        }
        Matcher m = Pattern.compile('\"OAuth \" [+] \"([\\w!.]+)').matcher(homeContent);
        
        if(m.find()) {
            return m.group(1);
        } else {
            return UserInfo.getSessionId();
        }
    }
    
    public String getFolders(String sid) {
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res;
        String resp;
        
        // Get dashboard definition
        req.setMethod('GET');
        req.setEndpoint(org + URL_FOLDERS_API);
        req.setHeader('Authorization', 'Bearer ' + sid);
        
        if(test.isRunningTest()) {
            resp = '{"folders" : [{"applicationStatus" : "newstatus","createdBy" : {"id" : "005B00000000000000","name" : "Analytics Cloud","profilePhotoUrl" : "https://c.gus.content.force.com/profilephoto/123456789/T"},"createdDate" : "2015-10-25T00:42:35.000Z","icon" : {"alias" : "16.png","id" : "00lB00000000000000","url" : "https://gs0.salesforce.com/analytics/wave/web/proto/images/app/icons/16.png"},"id" : "00lB00000000000000","label" : "Trending Dashboards","lastAccessedDate" : "2015-11-05T21:17:04.000Z","lastModifiedBy" : {"id" : "005B00000000000000","name" : "Analytics Cloud","profilePhotoUrl" : "https://c.gus.content.force.com/profilephoto/123456789/T"},"lastModifiedDate" : "2015-10-25T00:42:35.000Z","name" : "Trending_Dashboards","permissions" : {},"shares" : [],"type" : "folder","url" : "/services/data/v35.0/wave/folders/00lB00000000000000"}],"nextPageUrl" : "/services/data/v35.0/wave/folders?page=eyJwYWdlU2l6ZSI6MjUsInNvcnRPcmRlciI6Ik1SVSIsImxhc3RJZCI6IjAySUIwMDAwMDAwNHRSRk1BWSIsImxhc3ROYW1lIjoiYXNkZiIsImxhc3RUaW1lIjoxNDQxOTI2NjkyMDAwfQ%3D%3D","totalSize" : 1,"url" : "/services/data/v35.0/wave/folders"}';
        } else {
            res = http.send(req);
            resp = res.getBody();            
        }   
        
        List<Object> folders = new List<Object> {};
        Map<String, Object> folderJSON = (Map<String, Object>)JSON.deserializeUntyped(resp);
        for(Object aFolder : (List<Object>)folderJSON.get('folders')) { 
            String fId = (String)((Map<String, Object>)aFolder).get('id');
            String fName = (String)((Map<String, Object>)aFolder).get('name'); 
            folders.add(new Map<String, Object> { 'id' => fId, 'name' => fName });
        }		        
        return JSON.serialize(folders);
    }
    
    public void startNew() {}
    
    public void createDashboard() {                     
        String strJson = Apexpages.currentPage().getParameters().get('json'); 
        Map<String, Object> templateJson = (Map<String, Object>)JSON.deserializeUntyped(strJson);
        Map<String, Object> jsonObj = new Map<String, Object> {};
        jsonObj.put('_type', 'dashboard');
        jsonObj.put('description', 'Created from template');
        jsonObj.put('name', Apexpages.currentPage().getParameters().get('name'));
        jsonObj.put('state', templateJson);
        
        Map<String, String> folderMap = new Map<String, String> {};
        folderMap.put('_type', 'folder');
        folderMap.put('_uid', Apexpages.currentPage().getParameters().get('folder'));
        jsonObj.put('folder', folderMap);
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res;
        String response;
        
        req.setMethod('POST');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(org + URL_LENS_API); 
        req.setHeader('Authorization', 'OAuth ' + sid);  
        req.setBody(JSON.serialize(jsonObj));
     
        if(test.isRunningTest()) {
            response = '{"result": [{"_type": "dashboard","description": "Created from template","folder": {"_type": "folder","name": "Templates","_uid": "00lB00000000000000"},"name": "test","state": {"widgets": {"Logo_box": {"params": {"borderColor": "rgba(0, 0, 0, 0)","backgroundColor": "rgba(132, 132, 132, 0.39)"},"type": "BoxWidget","pos": {"w": 130,"zIndex": 17,"y": 10,"h": 80,"x": 60}}}},"_uid": "0FKB00000000000000","edgemarts": {}}]}';
        } else {
            res = http.send(req);
            response = res.getBody();
        }       
        
        Map<String, Object> respObj = (Map<String, Object>)JSON.deserializeUntyped(response);
        for(Object respJson : (List<Object>)respObj.get('result')) { 
            Map<String, Object> resultMap = (Map<String, Object>)respJson;
            dashboardId = (String)resultMap.get('_uid');
        }
        
        // Store key JSON metadata in cookies to persist across page refreshes. Is there no SessionStorage-like construct?
        analyzeJson(templateJson);
    }
    
    private void analyzeJson(Map<String, Object> dashJson) {        
        Set<String> colors = new Set<String> {};
        Map<String, Object> colorWidgetMap = new Map<String, Object> {}; // [color] -> { widgetList: Set, currColor: String }    
        Map<String, Object> widgets = (Map<String, Object>)(dashJson.get('widgets'));
        
        for(String widget : widgets.keySet()) {
            Map<String, Object> widgetJSON = (Map<String, Object>)(widgets.get(widget));
            Map<String, Object> widgetParams = (Map<String, Object>)(widgetJSON.get('params'));           
            
            for(String param : (List<String>)widgetColorParams) { 
                if(widgetParams.get(param) != null) {
                    String colorKey = (String)widgetParams.get(param);
                    
                    Map<String, Object> colorMap = (Map<String, Object>)colorWidgetMap.get(colorKey);
                    if(colorMap == null) {
                        colorMap = new Map<String, Object> { 'widgetList' => new Set<String>{}, 'currColor' => colorKey };
                        colorWidgetMap.put(colorKey, colorMap);
                    }
                    Set<String> widgetList = (Set<String>)colorMap.get('widgetList');
                    widgetList.add(widget);
                    
                    colors.add(colorKey);                
                }
            }
        }               
        dashboardLogoBoxExists = (widgets.get(dashboardLogoBoxToken) != null);
        dashboardColorPalette = JSON.serialize(colors);
        dashboardColorWidgetPalette = JSON.serialize(colorWidgetMap);
    }
    
    public void deleteDashboard() {        
        if(dashboardId == null) return;
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res;
        
        req.setMethod('DELETE');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(org + URL_LENS_API  + '/' + dashboardId + '/json'); 
        req.setHeader('Authorization', 'Bearer ' + sid);
          
        if(!test.isRunningTest()) res = http.send(req);
        dashboardId = '';
    }

    public void updateColor() {             
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res;
        String resp;
        
        // Get dashboard definition
        req.setMethod('GET');
        req.setEndpoint(org + URL_LENS_API + '/' + dashboardId + '/json');
        req.setHeader('Authorization', 'Bearer ' + sid);
        
        if(test.isRunningTest()) {
            resp = '{"result": [{"_type": "dashboard","description": "Created from template","folder": {"_type": "folder","name": "Templates","_uid": "00lB00000000000000"},"name": "test","state": {"widgets": {"Logo_box": {"params": {"borderColor": "rgba(0, 0, 0, 0)","backgroundColor": "rgba(132, 132, 132, 0.39)"},"type": "BoxWidget","pos": {"w": 130,"zIndex": 17,"y": 10,"h": 80,"x": 60}}}},"_uid": "0FKB00000000000000","edgemarts": {}}]}';
        } else {
            res = http.send(req);
            resp = res.getBody();            
        }
        
        String strColorMap = Apexpages.currentPage().getParameters().get('colorMap');
        if(strColorMap == null || strColorMap.length() == 0) return;
        Map<String, Object> colorMap = (Map<String, Object>)JSON.deserializeUntyped(strColorMap);
        
        String strWidgetOrigColor = Apexpages.currentPage().getParameters().get('widgetOrigColorMap');
        Map<String, Object> widgetOrigColor = new Map<String, Object> {};
        if(strWidgetOrigColor != null && strWidgetOrigColor.length() > 0) {
            widgetOrigColor = (Map<String, Object>)JSON.deserializeUntyped(strWidgetOrigColor);
        }

        // Got response -- can tweak stuff here
        Map<String, Object> respObj = (Map<String, Object>)JSON.deserializeUntyped(resp);
        for(Object respJson : (List<Object>)respObj.get('result')) { 
            Map<String, Object> resultMap = (Map<String, Object>)respJson;
            if(resultMap != null) {
                Map<String, Object> state = (Map<String, Object>)(resultMap.get('state'));
                Map<String, Object> widgets = (Map<String, Object>)(state.get('widgets'));
                for(String widget : widgets.keySet()) {
                    Map<String, Object> widgetJSON = (Map<String, Object>)(widgets.get(widget));
                    Map<String, Object> widgetParams = (Map<String, Object>)(widgetJSON.get('params'));

                    for(String param : (List<String>)widgetColorParams) { 
                        processWidgetColor(widget, widgetParams, param, colorMap, widgetOrigColor);
                    }                
                }
            }
        }
        
        // Post back the definition
        req.setMethod('PUT');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(org + URL_LENS_API + '/' + dashboardId + '/json'); 
        req.setHeader('Authorization', 'Bearer ' + sid);  
        req.setBody(JSON.serialize(((List<Object>)respObj.get('result')).get(0)));
        
        if(!test.isRunningTest()) res = http.send(req);
        dashboardWidgetOrigColor = JSON.serialize(widgetOrigColor);
    }    
    
    // widgetOrigColor is used for subsequent page refreshes:
    // The color map is [orig color] --> [new color], however, the dashboard JSON
    // no longer contains the orig color. Therefore, for any color swap, store the 
    // widget's orig color so we can do the mapping
    public void processWidgetColor(String widget, Map<String, Object> widgetParams, String param, Map<String, Object> colorMap, Map<String, Object> widgetOrigColor) {

        String colorKey = (String)widgetParams.get(param);
        if(colorKey != null) {
            
            // On subsequent loads, set to orig color
            if(widgetOrigColor.get(widget) != null) {
                Map<String, Object> origParams = (Map<String, Object>)widgetOrigColor.get(widget);
                if(origParams.get(param) != null) {
                    colorKey = (String)origParams.get(param);
                }
            }
            
            if(colorMap.get(colorKey) != null) {
                widgetParams.put(param, (String)colorMap.get(colorKey));
                
                if(widgetOrigColor.get(widget) != null) {
                    Map<String, Object> existing = (Map<String, Object>)widgetOrigColor.get(widget);
                    existing.put(param, colorKey);
                } else {
                    widgetOrigColor.put(widget, new Map<String, Object> {param => colorKey});
                }
            }
        }
    }    
    
    public PageReference uploadLogo() {        
        String currUrl = Apexpages.currentPage().getUrl();
        if(currUrl.indexOf('?') > -1) {
            currUrl = currUrl.substring(0, currUrl.indexOf('?'));
        }        
        
        // Get Shared folder
        List<Folder> queryResult = Database.query('SELECT Id FROM Folder where Name=\'' + IMAGE_FOLDER_LOCATION + '\'');
        if (queryResult.size() == 0) {
	        System.debug(LoggingLevel.ERROR, 'Could not find documents folder [' + IMAGE_FOLDER_LOCATION + ']');            
            PageReference pageRef = new PageReference(currUrl + '?' + URL_TOKEN_DASHBOARD_ID + '=' + dashboardId);
            pageRef.setRedirect(true);
            return pageRef;
        }
             
        Document d = new Document();
        d.name = dashboardId + '_logo';
        d.body = dashboardLogo; // body field in document object which holds the file.
        d.folderid= ((Folder)queryResult.get(0)).Id;
        d.IsPublic = true;
        insert d;  
        
        PageReference pageRef = new PageReference(currUrl + '?' + URL_TOKEN_DASHBOARD_ID + '=' + dashboardId + '&' + URL_TOKEN_LOGO_ID + '=' + d.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void refreshDashboardLogo() {
        
        if(dashboardLogoId == null || dashboardLogoId.length() == 0) return;
        
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        HTTPResponse res;
        String resp;
        
        // Get dashboard definition
        req.setMethod('GET');
        req.setEndpoint(org + URL_LENS_API + '/' + dashboardId + '/json');
        req.setHeader('Authorization', 'Bearer ' + sid);

        if(test.isRunningTest()) {
            resp = '{"result": [{"_type": "dashboard","description": "Created from template","folder": {"_type": "folder","name": "Templates","_uid": "00lB00000000000000"},"name": "test","state": {"widgets": {"Logo_box": {"params": {"borderColor": "rgba(0, 0, 0, 0)","backgroundColor": "rgba(132, 132, 132, 0.39)"},"type": "BoxWidget","pos": {"w": 130,"zIndex": 17,"y": 10,"h": 80,"x": 60}}}},"_uid": "0FKB00000000000000","edgemarts": {}}]}';
        } else {
            res = http.send(req);
            resp = res.getBody();
        }       
        
        Map<String, Object> respObj = (Map<String, Object>)JSON.deserializeUntyped(resp);
        for(Object respJson : (List<Object>)respObj.get('result')) { 
            Map<String, Object> resultMap = (Map<String, Object>)respJson;
            if(resultMap != null) {
                Map<String, Object> state = (Map<String, Object>)(resultMap.get('state'));
                Map<String, Object> widgets = (Map<String, Object>)(state.get('widgets'));
                
                if(widgets.get(dashboardLogoBoxToken) != null) {
                    Map<String, Object> widgetJSON = (Map<String, Object>)(widgets.get(dashboardLogoBoxToken));
                    Map<String, Object> widgetParams = (Map<String, Object>)(widgetJSON.get('params'));
                    widgetParams.put('imgUrl', dashboardLogoId);                   
                }
            }
        }
        
        // Post back the definition
        req.setMethod('PUT');
        req.setHeader('content-type', 'application/json');
        req.setEndpoint(org + URL_LENS_API + '/' + dashboardId + '/json'); 
        req.setHeader('Authorization', 'Bearer ' + sid);  
        req.setBody(JSON.serialize(((List<Object>)respObj.get('result')).get(0)));      
 
        if(!test.isRunningTest()) res = http.send(req);
    }
}