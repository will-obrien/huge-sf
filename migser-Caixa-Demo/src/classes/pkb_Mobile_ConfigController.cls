/**
 * @author Altimetrik
 * @description
 *		started at 2/12/2013
 *		Front Controller Config Page
 *	DELEGATES TO pkb_Mobile_CustomSettingModel Class
 **/
 global with sharing class pkb_Mobile_ConfigController {
 	
 	public pkb_Mobile_ConfigController(ApexPages.StandardController sc){
    }

    @RemoteAction
    global static Object getKnowledgeArticlesCustomSetting( String siteId ){
    	Object r;
    	try{
    		r=  pkb_Mobile_CustomSettingModel.getKnowledgeArticlesCustomSetting(siteId);
    	}catch(Exception e){
    		r = (Object)new map<String,Object>{ 'Status'=>'Fatal Error', 'Msg' => e.getMessage()};
    	}
    	return r;
    }
 	
 	@RemoteAction
 	global static Object getKAStructure(String d){
    	Object r;
 		try{
    		r=  pkb_Mobile_CustomSettingModel.getKnowledgeTypesAndFields(d);
 		}catch(Exception e){
    		r=  (Object)new map<String,Object>{ 'Status'=>'Fatal Error', 'Msg' => e.getMessage()};
 		}
    		return r;
 	}
}