/**
 * Updates the Country_Text__c field in Project with the names of the Project Countries
 *
 * @author  Virginia Fernández
 * @date    04/12/2013
 */
public with sharing class ProjectCountryTrigger {
	
    public static void onUpdate(ProjectCountry__c[] newProjCountries) {
        Set<Id> projIds = new Set<Id>();
        
        for (ProjectCountry__c pci : newProjCountries) {
            projIds.add(pci.Project__c);
        }
        
        Map<Id, Project__c> mapProjects = new Map<Id, Project__c>();
        Set<Id> countriesIds = new Set<Id>();
        
        List<Project__c> projects = [select Id, Country_Text__c, 
                                            (select Country__c from Project_Countries__r)
                                     from Project__c 
                                     where id in :projIds];
                                  
        for (Project__c project : projects) {
            mapProjects.put(project.Id, project);
            for (ProjectCountry__c projCountry : project.Project_Countries__r) {
                countriesIds.add(projCountry.Country__c);
            }
                                                        
        }
                  
        Map<Id, String> countryNames = new Map<Id, String>();       
        for (Country__c country: [select Id, Name from Country__c where Id in :countriesIds]) {
            countryNames.put(country.Id, country.Name);
        }       
        
        for (Project__c project : projects) {
            project.Country_Text__c = '';
            for (ProjectCountry__c projCountry : project.Project_Countries__r) {
                
                if ((project.Country_Text__c != '') && (!project.Country_Text__c.endsWith('; '))) {
                    project.Country_Text__c += '; ';
                }
                project.Country_Text__c += countryNames.get(projCountry.Country__c);
            }
        }
        
        if (!projects.isEmpty() && TriggerContext.runTrigger) {
        	TriggerContext.runTrigger = false;
            update projects;
        }
    }
}