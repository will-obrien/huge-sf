trigger UpdateQuoteMultiCurrencyFieldsBeforeInsert on Quote (before insert) {
     for(Quote qr: trigger.new){ 

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
    }
}