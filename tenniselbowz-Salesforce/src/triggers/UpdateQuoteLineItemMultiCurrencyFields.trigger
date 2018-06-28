trigger UpdateQuoteLineItemMultiCurrencyFields on QuoteLineItem (after update, after delete) {
    List<sObject> QuoteRecordsToUpdate = new List<Quote>();
    List<String> quoteRecordsToQuery = new List<String>();
     
       if(trigger.isupdate){ 
        for(QuoteLineItem qline: trigger.new){                     //Returns a list of the new versions of the sObject records.
            quoteRecordsToQuery.add(qline.QuoteId);
        }
    }
    
    if(trigger.isDelete){
        for(QuoteLineItem qline : trigger.old){                    //Returns a list of the old versions of the sObject records.
            quoteRecordsToQuery.add(qline.QuoteId);
        }
  }
    
     //update aggregate fields
       
      Quote[] QI = [Select Equipment_With_F_L__c,Local_Equipment_With_F_L__c,Total_Domestic_Freight__c,Total_Logistics_Add_On__c,Total_Outsource_Add_On__c,Total_Start_up_Add_On__c,Total_Service_Add_On__c,Total_Equipment_Price_FOB__c,Total_Base_Equipment_Cost__c,Total_Domestic_Freight_Pct_Amt__c,Total_Domestic_Freight_Amt__c,Logistics_Contingency__c,Logistics_COP_Reserve__c,Logistics_Contractor_Markup__c,Logistics_Extended_Warranty__c,Logistics_Inspection__c,Logistics_Labor_Hours__c,Logistics_Maintenance_Visits__c,Logistics_Marketing__c,Logistics_Standard_Warranty__c,Logistics_Training_Factory__c,Logistics_Training_On_Site__c,Logistics_Travel_Expenses__c,Logistics_Warranty_Reserve__c,Logistics_Witness_Test__c
                    From Quote 
                    where Id In :quoteRecordsToQuery];
       
      for(Quote qr: QI){ 
       
      AggregateResult[] qRes = [SELECT count(Id)cnt,SUM(Equipment_With_F_L__c)tot,SUM(Local_Equipment_With_F_L__c)locTot,SUM(Total_Domestic_Freight__c)totDomesticFreight,SUM(Total_Logistics_Add_On__c)totExportFreight,SUM(Total_Outsource_Add_On__c)totCommission,SUM(Total_Start_up_Add_On__c)totStartup,SUM(Total_Service_Add_On__c)totService,SUM(Total_Equipment_Price_FOB__c)totEquipmentPrice,SUM(Total_Base_Equipment_Cost__c)totBaseEquipmentPrice,SUM(Total_Domestic_Freight_Pct_Amt__c)totDomesticFreightPctAmt,SUM(Total_Domestic_Freight_Amt__c)totDomesticFreightAddAmt,SUM(Logistics_Contingency__c)totContingency, SUM(Logistics_COP_Reserve__c)totCOPReserve,SUM(Logistics_Contractor_Markup__c)totContractorMarkup,SUM(Logistics_Extended_Warranty__c)totExtendedWarranty,SUM(Logistics_Inspection__c)totInspection,SUM(Logistics_Labor_Hours__c)totLaborHours,SUM(Logistics_Maintenance_Visits__c)TotMaintenanceVisits,SUM(Logistics_Marketing__c)totMarketing,SUM(Logistics_Standard_Warranty__c)totStandardWarranty,SUM(Logistics_Training_Factory__c)totTrainingFactory,SUM(Logistics_Training_On_Site__c)totTrainingOnSite,SUM(Logistics_Travel_Expenses__c)totTravelExpenses,SUM(Logistics_Warranty_Reserve__c)totWarrantyReserve,SUM(Logistics_Witness_Test__c)totWitnessTest
                                From QuoteLineItem where QuoteId = :qr.Id];
                                     
      Decimal equipmentWithFreightLogistics = 0;
      Decimal localEquipmentWithFreightLogistics = 0;
      Decimal totalDomesticFreight = 0;
      Decimal totalExportFreight = 0;
      Decimal totalCommission = 0;
      Decimal totalStartup = 0;
      Decimal totalService = 0;
      Decimal totalEquipmentCost = 0;
      Decimal totalBaseEquipmentCost = 0;
      Decimal totalDomesticFreightPctAmt = 0;
      Decimal totalDomesticFreightAddAmt = 0;
      Decimal totalContingency = 0;
      Decimal totalCOPReserve = 0;
      Decimal totalContractorMarkup = 0;
      Decimal totalExtendedWarranty = 0;
      Decimal totalInspection = 0;
      Decimal totalLaborHours = 0;
      Decimal totalMaintenanceVisits = 0;
      Decimal totalMarketing = 0;
      Decimal totalStandardWarranty = 0;
      Decimal totalTrainingFactory = 0;
      Decimal totalTrainingOnSite = 0;
      Decimal totalTravelExpenses = 0;
      Decimal totalWarrantyReserve = 0;
      Decimal totalWitnessTest = 0;
            
      Integer cnt = (Integer)qRes[0].get('cnt');
      If (cnt > 0) {
          equipmentWithFreightLogistics = ((Decimal)qRes[0].get('tot')).setScale(2);
          localEquipmentWithFreightLogistics = ((Decimal)qRes[0].get('locTot')).setScale(2);
          totalDomesticFreight = ((Decimal)qRes[0].get('totDomesticFreight')).setScale(2);
          totalExportFreight = ((Decimal)qRes[0].get('totExportFreight')).setScale(2);
          totalCommission = ((Decimal)qRes[0].get('totCommission')).setScale(2);
          totalStartup = ((Decimal)qRes[0].get('totStartup')).setScale(2);
          totalService = ((Decimal)qRes[0].get('totService')).setScale(2);
          totalEquipmentCost = ((Decimal)qRes[0].get('totEquipmentPrice')).setScale(2);
          totalBaseEquipmentCost = ((Decimal)qRes[0].get('totBaseEquipmentPrice')).setScale(2);
          totalDomesticFreightPctAmt = ((Decimal)qRes[0].get('totDomesticFreightPctAmt')).setScale(2);
          totalDomesticFreightAddAmt = ((Decimal)qRes[0].get('totDomesticFreightAddAmt')).setScale(2);
          totalContingency = ((Decimal)qRes[0].get('totContingency')).setScale(2);
          totalCOPReserve = ((Decimal)qRes[0].get('totCOPReserve')).setScale(2);          
          totalContractorMarkup = ((Decimal)qRes[0].get('totContractorMarkup')).setScale(2);
          totalExtendedWarranty = ((Decimal)qRes[0].get('totExtendedWarranty')).setScale(2);
          totalInspection = ((Decimal)qRes[0].get('totInspection')).setScale(2);
          totalLaborHours = ((Decimal)qRes[0].get('totLaborHours')).setScale(2);
          totalMaintenanceVisits = ((Decimal)qRes[0].get('totMaintenanceVisits')).setScale(2);
          totalMarketing = ((Decimal)qRes[0].get('totMarketing')).setScale(2);
          totalStandardWarranty = ((Decimal)qRes[0].get('totStandardWarranty')).setScale(2);
          totalTrainingFactory = ((Decimal)qRes[0].get('totTrainingFactory')).setScale(2);
          totalTrainingOnSite = ((Decimal)qRes[0].get('totTrainingOnSite')).setScale(2);
          totalTravelExpenses = ((Decimal)qRes[0].get('totTravelExpenses')).setScale(2);
          totalWarrantyReserve = ((Decimal)qRes[0].get('totWarrantyReserve')).setScale(2);
          totalWitnessTest = ((Decimal)qRes[0].get('totWitnessTest')).setScale(2);
          
              qr.Equipment_With_F_L__c = equipmentWithFreightLogistics;
              qr.Local_Equipment_With_F_L__c = localEquipmentWithFreightLogistics;
              qr.Total_Domestic_Freight__c = totalDomesticFreight;
              qr.Total_Logistics_Add_On__c = totalExportFreight;
              qr.Total_Outsource_Add_On__c = totalCommission;
              qr.Total_Start_up_Add_On__c = totalStartup;
              qr.Total_Service_Add_On__c = totalService;
              qr.Total_Equipment_Price_FOB__c = totalEquipmentCost;
              qr.Total_Base_Equipment_Cost__c = totalBaseEquipmentCost;
              qr.Total_Domestic_Freight_Pct_Amt__c = totalDomesticFreightPctAmt;
              qr.Total_Domestic_Freight_Amt__c = totalDomesticFreightAddAmt;
              qr.Logistics_Contingency__c = totalContingency;
              qr.Logistics_COP_Reserve__c= totalCOPReserve;
              qr.Logistics_Contractor_Markup__c = totalContractorMarkup;
              qr.Logistics_Extended_Warranty__c = totalExtendedWarranty;
              qr.Logistics_Inspection__c = totalInspection;
              qr.Logistics_Labor_Hours__c = totalLaborHours;
              qr.Logistics_Maintenance_Visits__c = totalMaintenanceVisits;
              qr.Logistics_Marketing__c = totalMarketing;
              qr.Logistics_Standard_Warranty__c = totalStandardWarranty;
              qr.Logistics_Training_Factory__c = totalTrainingFactory;
              qr.Logistics_Training_On_Site__c = totalTrainingOnSite;
              qr.Logistics_Travel_Expenses__c = totalTravelExpenses;
              qr.Logistics_Warranty_Reserve__c = totalWarrantyReserve;
              qr.Logistics_Witness_Test__c = totalWitnessTest;
              
              QuoteRecordsToUpdate.add(qr);
      }                               
                   
         }
             if (QuoteRecordsToUpdate.size() > 0){
                   Update QuoteRecordsToUpdate;
             }
         
}