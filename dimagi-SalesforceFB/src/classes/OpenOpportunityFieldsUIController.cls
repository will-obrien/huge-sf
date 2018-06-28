/**
 *
 * @author  Fernando Rodriguez (frodriguez@adooxen.com)
 * @date    01/16/2012
 *
 */
public with sharing class OpenOpportunityFieldsUIController {

    public OpenOpportunityListData stageContainer;
    public String stageName {get; set;}
    public String htmlTable {get; set;}

    public OpenOpportunityFieldsUIController() {}
    

    public void setStageContainer(OpenOpportunityListData value) {
        stageContainer = value;
        htmlTable = OpenOpportunityEmailUtils.buildEmailStageTable(stageName, stageContainer.opportunities, true);
    }

    public OpenOpportunityListData getStageContainer() {
        return stageContainer;
    }
}