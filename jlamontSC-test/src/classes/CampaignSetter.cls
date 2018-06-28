// *************************************************************************/
// CampaignSetter Interface
//
// Interface that can be implemented by Controllers that need to interact
// with CampaignSearch component.
//           
//  7/2016 Mark Maslow Original
// *************************************************************************/
public interface CampaignSetter {
	CampaignSetter getThis();
	void setSelectedCampaign(Campaign camp);
	void setCampSearchController(CampaignSearchController controller);
}