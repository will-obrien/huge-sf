trigger UpdateQuoteLineItemMultiCurrencyFieldsBeforeInsert on QuoteLineItem (before insert, before update) {
     for(QuoteLineItem qli: trigger.new){ 
     
              Decimal FreightUSD = qli.Selling_Unitary_Freight_Logistic__c;
              Decimal FreightLocal = qli.Local_Selling_Unitary_Freight_Logistic__c;
              Decimal UnitPriceNUSD = qli.Unitary_Selling_Price_w_Log_Disc__c;
              Decimal UnitPriceNLocal = qli.Local_Unitary_Selling_Price_w_Log_Disc__c;
              Decimal TotalPriceNUSD = qli.Total_Selling_Price_w_Log_Disc__c;
              Decimal TotalPriceNLocal = qli.Local_Total_Selling_Price_w_Log_Disc__c;
              Decimal UnitPriceFUSD = qli.Selling_Unitary_Equipment_Price_FOB__c;
              Decimal UnitPriceFLocal = qli.LocalSelling_Unitary_Equipment_Price_FOB__c;
              Decimal TotalPriceFUSD = qli.Selling_Total_Equip_Price_FOB__c;
              Decimal TotalPriceFLocal = qli.Local_Selling_Total_Equip_Price_FOB__c;
              
              
              if (qli.Selling_Unitary_Freight_Logistic__c == null)
                  FreightUSD = 0;
              if (qli.Local_Selling_Unitary_Freight_Logistic__c == null)
                  FreightLocal = 0;
              if (qli.Unitary_Selling_Price_w_Log_Disc__c == null)
                  UnitPriceNUSD = 0;
              if (qli.Local_Unitary_Selling_Price_w_Log_Disc__c == null)
                  UnitPriceNLocal = 0;
              if (qli.Total_Selling_Price_w_Log_Disc__c == null)
                  TotalPriceNUSD = 0;
              if (qli.Local_Total_Selling_Price_w_Log_Disc__c == null)
                  TotalPriceNLocal = 0;
              if (qli.Selling_Unitary_Equipment_Price_FOB__c == null)
                  UnitPriceFUSD = 0;
              if (qli.LocalSelling_Unitary_Equipment_Price_FOB__c == null)
                  UnitPriceFLocal = 0;
              if (qli.Selling_Total_Equip_Price_FOB__c == null)
                  TotalPriceFUSD = 0;
              if (qli.Local_Selling_Total_Equip_Price_FOB__c == null)
                  TotalPriceFLocal = 0;
              
              String strFreightUSD = String.valueOf(FreightUSD);
              String strFreightLocal = String.valueOf(FreightLocal);
              String strUnitPriceNUSD = String.valueOf(UnitPriceNUSD);
              String strUnitPriceNLocal = String.valueOf(UnitPriceNLocal);      
              String strTotalPriceNUSD = String.valueOf(TotalPriceNUSD);  
              String strTotalPriceNLocal = String.valueOf(TotalPriceNLocal);
              String strUnitPriceFUSD = String.valueOf(UnitPriceFUSD);
              String strUnitPriceFLocal = String.valueOf(UnitPriceFLocal);      
              String strTotalPriceFUSD = String.valueOf(TotalPriceFUSD);  
              String strTotalPriceFLocal = String.valueOf(TotalPriceFLocal);

              String strFreightUSDResult = '';
              String strFreightLocalResult = ''; 
              String strUnitPriceNUSDResult = '';              
              String strUnitPriceNLocalResult = '';      
              String strTotalPriceNUSDResult = '';  
              String strTotalPriceNLocalResult = '';
              String strUnitPriceFUSDResult = '';              
              String strUnitPriceFLocalResult = '';      
              String strTotalPriceFUSDResult = '';  
              String strTotalPriceFLocalResult = '';


              Decimal numberValue = FreightUSD;
              String theNumberAsString = strFreightUSD;
              Integer stringLength = 0;
              String formattedString = '';
              String strLocalCurrency = qli.Local_Currency__c;
              
              //FreightUSD
              numberValue = FreightUSD;
              theNumberAsString = strFreightUSD;
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
                           
              strFreightUSDResult = formattedString;
              //FreightUSD
      
              //FreightLocal
              numberValue = FreightLocal;
              theNumberAsString = strFreightLocal;
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
              
              strFreightLocalResult = formattedString;
              //FreightLocal
              qli.m_Selling_Unitary_Freight_Logistic__c = '$' + strFreightUSDResult + ' (' + strFreightLocalResult + ' ' + strLocalCurrency + ')';
      
              //UnitPriceNUSD
              numberValue = UnitPriceNUSD;
              theNumberAsString = strUnitPriceNUSD;
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
           
              strUnitPriceNUSDResult = formattedString;
              //UnitPriceNUSD
                    
              //UnitPriceNLocal
              numberValue = UnitPriceNLocal;
              theNumberAsString = strUnitPriceNLocal;
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
              
              strUnitPriceNLocalResult = formattedString;
              //UnitPriceNLocal
              qli.Unitary_Selling_Price_w_Logistics_Disc__c = '$' + strUnitPriceNUSDResult + ' (' + strUnitPriceNLocalResult + ' ' + strLocalCurrency + ')';
      
              //TotalPriceNUSD
              numberValue = TotalPriceNUSD;
              theNumberAsString = strTotalPriceNUSD;
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
           
              strTotalPriceNUSDResult = formattedString;
              //TotalPriceNUSD
      
              //TotalPriceNLocal
              numberValue = TotalPriceNLocal;
              theNumberAsString = strTotalPriceNLocal;
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
              
              strTotalPriceNLocalResult = formattedString;
              //TotalPriceNLocal
              qli.Total_Selling_Price_w_Logistics_Disc__c = '$' + strTotalPriceNUSDResult + ' (' + strTotalPriceNLocalResult + ' ' + strLocalCurrency + ')';
              
              //UnitPriceFUSD
              numberValue = UnitPriceFUSD;
              theNumberAsString = strUnitPriceFUSD;
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
           
              strUnitPriceFUSDResult = formattedString;
              //UnitPriceFUSD
                    
              //UnitPriceFLocal
              numberValue = UnitPriceFLocal;
              theNumberAsString = strUnitPriceFLocal;
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
              
              strUnitPriceFLocalResult = formattedString;
              //UnitPriceFLocal
              qli.m_Selling_Unitary_Equipment_Price_FOB__c = '$' + strUnitPriceFUSDResult + ' (' + strUnitPriceFLocalResult + ' ' + strLocalCurrency + ')';
      
              //TotalPriceFUSD
              numberValue = TotalPriceFUSD;
              theNumberAsString = strTotalPriceFUSD;
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
           
              strTotalPriceFUSDResult = formattedString;
              //TotalPriceFUSD
      
              //TotalPriceFLocal
              numberValue = TotalPriceFLocal;
              theNumberAsString = strTotalPriceFLocal;
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
              
              strTotalPriceFLocalResult = formattedString;
              //TotalPriceFLocal
              qli.m_Selling_Total_Equip_Price_FOB__c = '$' + strTotalPriceFUSDResult + ' (' + strTotalPriceFLocalResult + ' ' + strLocalCurrency + ')';
     /*
              if (trigger.IsInsert){
                  update QL;
              } else if (trigger.IsUpdate){
                  if (trigger.oldMap.get(quoteLineItemId).m_Selling_Unitary_Freight_Logistic__c != qli.m_Selling_Unitary_Freight_Logistic__c ||
                      trigger.oldMap.get(quoteLineItemId).Unitary_Selling_Price_w_Logistics_Disc__c != qli.Unitary_Selling_Price_w_Logistics_Disc__c ||
                      trigger.oldMap.get(quoteLineItemId).Total_Selling_Price_w_Logistics_Disc__c != qli.Total_Selling_Price_w_Logistics_Disc__c ||
                      trigger.oldMap.get(quoteLineItemId).m_Selling_Unitary_Equipment_Price_FOB__c != qli.m_Selling_Unitary_Equipment_Price_FOB__c ||
                      trigger.oldMap.get(quoteLineItemId).m_Selling_Total_Equip_Price_FOB__c != qli.m_Selling_Total_Equip_Price_FOB__c){
                      update QL;
                  }
              }
     */
    }
}