public class EditCharges {
    
    
    public static void EditChargesTest(String quoteId,String ratePlanID) {
 
        List<zqu.zChargeGroup> chargeGroupList = zqu.zQuoteUtil.getChargeGroups(quoteId);
        
        for(Integer i =0 ; i < chargeGroupList.size() ; i++){
            zqu.zChargeGroup zchargeGrp = chargeGroupList.get(i);
            zqu.zChargeGroup deletedChargeGroup = null;
            deletedChargeGroup = zqu.ZQuoteUtil.deleteChargeGroup(zchargeGrp);
        }
        
        zqu.zChargeGroup chargeGroup = zqu.zQuoteUtil.getChargeGroup(quoteId, ratePlanID);
        chargeGroup = zqu.ZQuoteUtil.addChargeGroup(chargeGroup);
    }

}