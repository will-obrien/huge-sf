trigger UpdateQuoteMultiCurrencyFields on Quote (after update) {
     for(Quote q: trigger.new){ 
       
      String quoteId = q.Id;
      Quote[] QI = [Select Selling_Total_Equip_Price_FOB__c, Local_Selling_Total_Equip_Price_FOB__c, Total_Freight__c, Local_Total_Freight__c, Grand_Total_E_D_F_T__c, Local_Grand_Total_E_D_F_T__c, Local_Currency__c, m_Grand_Total_E_F_D_T__c, m_Selling_Total_Equip_Price_FOB__c, m_Total_Freight__c
                    From Quote 
                    where Id = :quoteId];
                    
      /*
      AggregateResult[] qRes = [SELECT count(Id)cnt,SUM(Equipment_With_F_L__c)tot,SUM(Local_Equipment_With_F_L__c)locTot,SUM(Total_Domestic_Freight__c)totDomesticFreight,SUM(Total_Logistics_Add_On__c)totExportFreight,SUM(Total_Outsource_Add_On__c)totCommission,SUM(Total_Start_up_Add_On__c)totStartup,SUM(Total_Service_Add_On__c)totService,SUM(Total_Equipment_Price_FOB__c)totEquipmentPrice,SUM(Total_Base_Equipment_Cost__c)totBaseEquipmentPrice,SUM(Total_Domestic_Freight_Pct_Amt__c)totDomesticFreightPctAmt,SUM(Total_Domestic_Freight_Amt__c)totDomesticFreightAddAmt,SUM(Logistics_Contingency__c)totContingency,SUM(Logistics_Contractor_Markup__c)totContractorMarkup,SUM(Logistics_Extended_Warranty__c)totExtendedWarranty,SUM(Logistics_Inspection__c)totInspection,SUM(Logistics_Labor_Hours__c)totLaborHours,SUM(Logistics_Maintenance_Visits__c)TotMaintenanceVisits,SUM(Logistics_Marketing__c)totMarketing,SUM(Logistics_Standard_Warranty__c)totStandardWarranty,SUM(Logistics_Training_Factory__c)totTrainingFactory,SUM(Logistics_Training_On_Site__c)totTrainingOnSite,SUM(Logistics_Travel_Expenses__c)totTravelExpenses,SUM(Logistics_Warranty_Reserve__c)totWarrantyReserve,SUM(Logistics_Witness_Test__c)totWitnessTest
                                From QuoteLineItem where QuoteId = :quoteId];
                                     
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
      }         
      */                      
                    
         for(Quote qr: QI){
         
              Decimal SubTotalUSD = qr.Selling_Total_Equip_Price_FOB__c;
              Decimal SubTotalLocal = qr.Local_Selling_Total_Equip_Price_FOB__c;
              Decimal TotalFreightUSD = qr.Total_Freight__c;
              Decimal TotalFreightLocal = qr.Local_Total_Freight__c;
              Decimal GrandTotalUSD = qr.Grand_Total_E_D_F_T__c;  
              Decimal GrandTotalLocal = qr.Local_Grand_Total_E_D_F_T__c;

              String strSubTotalUSD = String.valueOf(SubTotalUSD);
              String strSubTotalLocal = String.valueOf(SubTotalLocal);      
              String strTotalFreightUSD = String.valueOf(TotalFreightUSD);
              String strTotalFreightLocal = String.valueOf(TotalFreightLocal);      
              String strGrandTotalUSD = String.valueOf(GrandTotalUSD);  
              String strGrandTotalLocal = String.valueOf(GrandTotalLocal);

              String strSubTotalUSDResult = '';              
              String strSubTotalLocalResult = '';      
              String strTotalFreightUSDResult = '';
              String strTotalFreightLocalResult = '';      
              String strGrandTotalUSDResult = '';  
              String strGrandTotalLocalResult = '';

              Decimal numberValue = SubTotalUSD;
              String theNumberAsString = strSubTotalUSD;
              Integer stringLength = 0;
              String formattedString = '';
              String strLocalCurrency = qr.Local_Currency__c;
              
              //SubTotalUSD
              numberValue = SubTotalUSD;
              theNumberAsString = strSubTotalUSD;
              stringLength = theNumberAsString.length();
              formattedString = '';
              
              if (!theNumberAsString.contains('.')){
                    theNumberAsString += '.00';
              }else if (theNumberAsString.right(2).left(1).equals('.')){
                    theNumberAsString += '0';
              } 
              if(numberValue>=1000000000){           
                    formattedString += theNumberAsString.substring(0,stringLength-12)+ ',' + theNumberAsString.substring(stringLength-12,stringLength-12+3) + ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);
              } else if(numberValue>=1000000){         
                    formattedString += theNumberAsString.substring(0,stringLength-9)+ ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);       
              } else if(numberValue>=1000){            
                    formattedString += theNumberAsString.substring(0,stringLength-6)+ ',' + theNumberAsString.substring(stringLength-6,stringLength);      
              } else {            
                    formattedString += theNumberAsString;      
              } 
                           
              strSubTotalUSDResult = formattedString;
              //SubTotalUSD
      
              //SubTotalLocal
              numberValue = SubTotalLocal;
              theNumberAsString = strSubTotalLocal;
              stringLength = theNumberAsString.length();
              formattedString = '';
              
              if (!theNumberAsString.contains('.')){
                    theNumberAsString += '.00';
              }else if (theNumberAsString.right(2).left(1).equals('.')){
                    theNumberAsString += '0';
              }
              if(numberValue>=1000000000){           
                    formattedString += theNumberAsString.substring(0,stringLength-12)+ ',' + theNumberAsString.substring(stringLength-12,stringLength-12+3) + ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);
              } else if(numberValue>=1000000){         
                    formattedString += theNumberAsString.substring(0,stringLength-9)+ ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);       
              } else if(numberValue>=1000){            
                    formattedString += theNumberAsString.substring(0,stringLength-6)+ ',' + theNumberAsString.substring(stringLength-6,stringLength);      
              } else {            
                    formattedString += theNumberAsString;      
              }           
              
              strSubTotalLocalResult = formattedString;
              //SubTotalLocal
              qr.m_Selling_Total_Equip_Price_FOB__c = '$' + strSubTotalUSDResult + ' (' + strSubTotalLocalResult + ' ' + strLocalCurrency + ')';
      
              //TotalFreightUSD
              numberValue = TotalFreightUSD;
              theNumberAsString = strTotalFreightUSD;
              stringLength = theNumberAsString.length();
              formattedString = '';
              
              if (!theNumberAsString.contains('.')){
                    theNumberAsString += '.00';
              }else if (theNumberAsString.right(2).left(1).equals('.')){
                    theNumberAsString += '0';
              }
              if(numberValue>=1000000000){           
                    formattedString += theNumberAsString.substring(0,stringLength-12)+ ',' + theNumberAsString.substring(stringLength-12,stringLength-12+3) + ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);
              } else if(numberValue>=1000000){         
                    formattedString += theNumberAsString.substring(0,stringLength-9)+ ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);       
              } else if(numberValue>=1000){            
                    formattedString += theNumberAsString.substring(0,stringLength-6)+ ',' + theNumberAsString.substring(stringLength-6,stringLength);      
              } else {            
                    formattedString += theNumberAsString;      
              }               
           
              strTotalFreightUSDResult = formattedString;
              //TotalFreightUSD
                    
              //TotalFreightLocal
              numberValue = TotalFreightLocal;
              theNumberAsString = strTotalFreightLocal;
              stringLength = theNumberAsString.length();
              formattedString = '';
              
              if (!theNumberAsString.contains('.')){
                    theNumberAsString += '.00';
              }else if (theNumberAsString.right(2).left(1).equals('.')){
                    theNumberAsString += '0';
              }
              if(numberValue>=1000000000){           
                    formattedString += theNumberAsString.substring(0,stringLength-12)+ ',' + theNumberAsString.substring(stringLength-12,stringLength-12+3) + ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);
              } else if(numberValue>=1000000){         
                    formattedString += theNumberAsString.substring(0,stringLength-9)+ ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);       
              } else if(numberValue>=1000){            
                    formattedString += theNumberAsString.substring(0,stringLength-6)+ ',' + theNumberAsString.substring(stringLength-6,stringLength);      
              } else {            
                    formattedString += theNumberAsString;      
              }              
              
              strTotalFreightLocalResult = formattedString;
              //TotalFreightLocal
              qr.m_Total_Freight__c = '$' + strTotalFreightUSDResult + ' (' + strTotalFreightLocalResult + ' ' + strLocalCurrency + ')';
      
              //GrandTotalUSD
              numberValue = GrandTotalUSD;
              theNumberAsString = strGrandTotalUSD;
              stringLength = theNumberAsString.length();
              formattedString = '';
              
              if (!theNumberAsString.contains('.')){
                    theNumberAsString += '.00';
              }else if (theNumberAsString.right(2).left(1).equals('.')){
                    theNumberAsString += '0';
              }              
              if(numberValue>=1000000000){           
                    formattedString += theNumberAsString.substring(0,stringLength-12)+ ',' + theNumberAsString.substring(stringLength-12,stringLength-12+3) + ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);
              } else if(numberValue>=1000000){         
                    formattedString += theNumberAsString.substring(0,stringLength-9)+ ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);       
              } else if(numberValue>=1000){            
                    formattedString += theNumberAsString.substring(0,stringLength-6)+ ',' + theNumberAsString.substring(stringLength-6,stringLength);      
              } else {            
                    formattedString += theNumberAsString;      
              }           
           
              strGrandTotalUSDResult = formattedString;
              //GrandTotalUSD
      
              //GrandTotalLocal
              numberValue = GrandTotalLocal;
              theNumberAsString = strGrandTotalLocal;
              stringLength = theNumberAsString.length();
              formattedString = '';
              
              if (!theNumberAsString.contains('.')){
                    theNumberAsString += '.00';
              }else if (theNumberAsString.right(2).left(1).equals('.')){
                    theNumberAsString += '0';
              }
              if(numberValue>=1000000000){           
                    formattedString += theNumberAsString.substring(0,stringLength-12)+ ',' + theNumberAsString.substring(stringLength-12,stringLength-12+3) + ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);
              } else if(numberValue>=1000000){         
                    formattedString += theNumberAsString.substring(0,stringLength-9)+ ',' + theNumberAsString.substring(stringLength-9,stringLength-9+3) + ',' + theNumberAsString.substring(stringLength-6,stringLength);       
              } else if(numberValue>=1000){            
                    formattedString += theNumberAsString.substring(0,stringLength-6)+ ',' + theNumberAsString.substring(stringLength-6,stringLength);      
              } else {            
                    formattedString += theNumberAsString;      
              }              
              
              strGrandTotalLocalResult = formattedString;
              //GrandTotalLocal
              qr.m_Grand_Total_E_F_D_T__c = '$' + strGrandTotalUSDResult + ' (' + strGrandTotalLocalResult + ' ' + strLocalCurrency + ')';
              
              /*
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
              */
              
              if (trigger.IsInsert){
                  update QI;
              } else if (trigger.IsUpdate){
                  if (trigger.oldMap.get(quoteId).m_Grand_Total_E_F_D_T__c != qr.m_Grand_Total_E_F_D_T__c ||
                      trigger.oldMap.get(quoteId).m_Selling_Total_Equip_Price_FOB__c != qr.m_Selling_Total_Equip_Price_FOB__c ||
                      trigger.oldMap.get(quoteId).m_Total_Freight__c != qr.m_Total_Freight__c /*||
                      trigger.oldMap.get(quoteId).Equipment_With_F_L__c != qr.Equipment_With_F_L__c ||
                      trigger.oldMap.get(quoteId).Total_Domestic_Freight__c != qr.Total_Domestic_Freight__c ||
                      trigger.oldMap.get(quoteId).Total_Logistics_Add_On__c != qr.Total_Logistics_Add_On__c ||
                      trigger.oldMap.get(quoteId).Total_Outsource_Add_On__c != qr.Total_Outsource_Add_On__c ||
                      trigger.oldMap.get(quoteId).Total_Start_up_Add_On__c != qr.Total_Start_up_Add_On__c ||
                      trigger.oldMap.get(quoteId).Total_Service_Add_On__c != qr.Total_Service_Add_On__c ||
                      trigger.oldMap.get(quoteId).Total_Equipment_Price_FOB__c != qr.Total_Equipment_Price_FOB__c ||
                      trigger.oldMap.get(quoteId).Total_Base_Equipment_Cost__c != qr.Total_Base_Equipment_Cost__c ||
                      trigger.oldMap.get(quoteId).Total_Domestic_Freight_Pct_Amt__c != qr.Total_Domestic_Freight_Pct_Amt__c ||
                      trigger.oldMap.get(quoteId).Total_Domestic_Freight_Amt__c != qr.Total_Domestic_Freight_Amt__c ||
                      trigger.oldMap.get(quoteId).Logistics_Contingency__c != qr.Logistics_Contingency__c ||
                      trigger.oldMap.get(quoteId).Logistics_Contractor_Markup__c != qr.Logistics_Contractor_Markup__c ||
                      trigger.oldMap.get(quoteId).Logistics_Extended_Warranty__c != qr.Logistics_Extended_Warranty__c ||
                      trigger.oldMap.get(quoteId).Logistics_Inspection__c != qr.Logistics_Inspection__c ||
                      trigger.oldMap.get(quoteId).Logistics_Labor_Hours__c != qr.Logistics_Labor_Hours__c ||
                      trigger.oldMap.get(quoteId).Logistics_Maintenance_Visits__c != qr.Logistics_Maintenance_Visits__c ||
                      trigger.oldMap.get(quoteId).Logistics_Marketing__c != qr.Logistics_Marketing__c ||
                      trigger.oldMap.get(quoteId).Logistics_Standard_Warranty__c != qr.Logistics_Standard_Warranty__c ||
                      trigger.oldMap.get(quoteId).Logistics_Training_Factory__c != qr.Logistics_Training_Factory__c ||
                      trigger.oldMap.get(quoteId).Logistics_Training_On_Site__c != qr.Logistics_Training_On_Site__c ||
                      trigger.oldMap.get(quoteId).Logistics_Travel_Expenses__c != qr.Logistics_Travel_Expenses__c ||
                      trigger.oldMap.get(quoteId).Logistics_Warranty_Reserve__c != qr.Logistics_Warranty_Reserve__c ||
                      trigger.oldMap.get(quoteId).Logistics_Witness_Test__c != qr.Logistics_Witness_Test__c*/){
                      update QI;
                  }
              }
         }
    }
}