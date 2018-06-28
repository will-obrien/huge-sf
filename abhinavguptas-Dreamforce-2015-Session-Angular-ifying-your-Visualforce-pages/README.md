# Dreamforce 2015 Session : "Angular-ifying your Visualforce pages"
Code Snippets from Dreamforce 2015 Session : Angular-ifying your Visualforce pages
## Session ##

A practical guide to being productive when using Angluar.js apps with Visualforce pages. We will demonstrate best practices for structuring Single Page Apps inside your Visualforce pages for static resources, mavensmate resource bundles and resource editing with Aside.io & the Welkin suite. By the end of the session you will understand the best way to use Angular.js for your projects.

[Link](https://success.salesforce.com/Ev_Sessions?eventId=a1Q30000000DHQlEAO#/session/a2q300000019BHHAA2) to Dreamforce Session listing. 


## Slides ##
Please find it in [this google presentation](https://docs.google.com/presentation/d/1BxclC0veJRXEmhP-aD_OlK08hNkgx9e52K65icFOXJU/edit?usp=sharing). 

*Note: I am not giving slideshare link as it messes up the gif animations added for better understanding.*

## Code Structure ##
Following is directory structure of code files, along with comments next to file and dir names.

    ├── **resource-bundles** *(kept exploded files in git, for ease in exploring code without requiring to clone or download the git repo)*
    │   ├── tabs_app_aside.resource _(exploded zipped static resource generated from aside)_
    │   
    │   └── tabs_app_mavens.resource _(exploded zipped static resource generated from mavensmate)_
    │    
    └── **src** *(standard salesforce project structure)*
        ├── classes
        │   ├── RemoteTKController.cls
        │   ├── RemoteTKController.cls-meta.xml
        │   ├── TestRemoteTKController.cls
        │   └── TestRemoteTKController.cls-meta.xml
        ├── components
        │   ├── RemoteTK.component
        │   └── RemoteTK.component-meta.xml
        ├── package.xml
        ├── pages
        │   ├── myapp_index_html.page *(Approach 1 index.html, supporting pages for this approach with prefix **myapp_** below)*
        │   ├── myapp_index_html.page-meta.xml
        │   ├── myapp_tab_dash_html.page
        │   ├── myapp_tab_dash_html.page-meta.xml
        │   ├── myapp_tab_events_html.page
        │   ├── myapp_tab_events_html.page-meta.xml
        │   ├── myapp_tab_tasks_html.page
        │   ├── myapp_tab_tasks_html.page-meta.xml
        │   ├── myapp_tabs_html.page
        │   ├── myapp_tabs_html.page-meta.xml
        │   ├── tabs_app_aside.page *(Aside index.html)*
        │   ├── tabs_app_aside.page-meta.xml
        │   ├── tabs_app_mavens.page *(mavensmate index.html)*
        │   └── tabs_app_mavens.page-meta.xml
        └── staticresources
            ├── ionic_old_lib.resource *(Approach 1 code depends on old version of Ionic)*
            ├── ionic_old_lib.resource-meta.xml
            ├── ioniclib.resource
            ├── ioniclib.resource-meta.xml
            ├ **[Approach 1 static resources]**        
            ├── myapp_app_js.resource
            ├── myapp_app_js.resource-meta.xml
            ├── myapp_controllers_js.resource
            ├── myapp_controllers_js.resource-meta.xml
            ├── myapp_services_js.resource
            ├── myapp_services_js.resource-meta.xml
            ├ **[Aside zipped static resource]**       
            ├── tabs_app_aside.resource
            ├── tabs_app_aside.resource-meta.xml
            ├ **[Mavensmate zipped static resource]**                
            ├── tabs_app_mavens.resource
            └── tabs_app_mavens.resource-meta.xml

