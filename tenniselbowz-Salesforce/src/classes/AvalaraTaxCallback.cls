/**
 *  Apttus Config & Pricing
 *  AvalaraTaxCallback
 *   
 *  @2013-2014 Apttus Inc. All rights reserved.
 */
global with sharing class AvalaraTaxCallback implements Apttus_Config2.CustomClass.ITaxCallback2 {
    
    public static final String CONFIG_AVALARA           = 'Avalara';
    public static final String CLIENT_NAME              = 'Apttus Billing, 1.0';
    public static final String DETAILLEVEL_TAX          = 'Tax';
    public static final String DOCTYPE_SALESORDER       = 'PurchaseOrder';
    public static final String DOCTYPE_SALESINVOICE     = 'SalesInvoice';
    public static final String ADDRESSCODE_ORIGIN       = 'Origin';
    public static final String ADDRESSCODE_DESTINATION  = 'Destination';
    public static final String ORIGINCODE_NONE          = 'None';
    public static final String DESTINATIONCODE_NONE     = 'None';
    public static final String TAXCODE_NONE             = 'None';
    
    public static final String TAXOVERRIDETYPE_TAXDATE  = 'TaxDate';
    public static final String RESULTCODE_SUCCESS       = 'Success';
    public static final String RESULTCODE_FAIL          = 'Fail';
    public static final String ADDRESSTYPE_SHIPPING     = 'Shipping';
    public static final String TEXTCASE_MIXED           = 'Mixed';
    public static final String CANCELCODE_DOCVOIDED     = 'DocVoided';
    
    /**
     * Callback invoked to compute tax based on the given input
     * @param input the tax input 
     * @return the tax result
     */
   global Static Apttus_Config2.CustomClass.TaxResult computeTax(Apttus_Config2.CustomClass.TaxInput input) {
        // compute tax
        
       // List<Apttus_Config2.CustomClass.TaxResult> results = callGetTax(new Apttus_Config2.CustomClass.TaxInput[]{input}, False); 
        
        //return (!results.isEmpty() ? results[0] : new Apttus_Config2.CustomClass.TaxResult()); 
        return null; 
    }
    
    
    /**
     * Callback invoked to compute tax based on the given list of inputs
     * @param inputs the list of tax inputs
     * @return the list of tax results
     */
    global Static List<Apttus_Config2.CustomClass.TaxResult> computeTaxMultiple(List<Apttus_Config2.CustomClass.TaxInput> inputs) {
        
        // compute tax
       // List<Apttus_Config2.CustomClass.TaxResult> results = callGetTax(inputs, False);
        
        //return (!results.isEmpty() ? results : new List<Apttus_Config2.CustomClass.TaxResult>());
        return null;
    }
    
    
    /**
     * Callback invoked to compute (and commit) tax based on the given list of inputs
     * @param inputs the list of tax inputs
     * @return the list of tax results
     */
    global Static List<Apttus_Config2.CustomClass.TaxResult> computeTaxAndCommit(List<Apttus_Config2.CustomClass.TaxInput> inputs) {
        
        // compute tax
       // List<Apttus_Config2.CustomClass.TaxResult> results = callGetTax(inputs, True);
        
       // return (!results.isEmpty() ? results : new List<Apttus_Config2.CustomClass.TaxResult>());
        return null;
    }
    
    
    /**
     * Callback invoked to compute tax only based on the given list of inputs
     * @param inputs the list of tax inputs
     * @return the list of tax results
     */
    global Static List<Apttus_Config2.CustomClass.TaxResult> computeTaxOnly(List<Apttus_Config2.CustomClass.TaxInput> inputs) {
        
        // compute tax
        List<Apttus_Config2.CustomClass.TaxResult> results = callGetTax(inputs, False);
        
        return (!results.isEmpty() ? results : new List<Apttus_Config2.CustomClass.TaxResult>());
        
    }
    
    
    /**
     * Callback invoked to call Avalara's GetTax() API based on the given list of inputs
     * @param inputs the list of tax inputs
     * @param commitFlag boolean to instruct a commit or not to Avalara
     * @return the list of tax results
     */
    global Static List<Apttus_Config2.CustomClass.TaxResult> callGetTax(List<Apttus_Config2.CustomClass.TaxInput> inputs, Boolean commitflag) {
        
        // Get Tax Connector Config Info
      TaxConnectorConfig__c taxConfig = TaxConnectorConfig__c.getInstance(CONFIG_AVALARA);
        
        // Prepare the return
        List<Apttus_Config2.CustomClass.TaxResult> taxResults = new List<Apttus_Config2.CustomClass.TaxResult>();
        
        // Return if disabled
        if (!taxConfig.EnableAvaTax__c) {
           System.debug('callGetTax() AvaTax disabled. Please visit the Avalara Tax Connector Config settings to enable.');
            return taxResults;

        }
        
        // Initialized the Tax Service with endpoint and credentials
        CBEO.TaxSvc.TaxSvcSoap taxSvc = new CBEO.TaxSvc.TaxSvcSoap(taxConfig.EndPoint__c);
        
        taxSvc.Security = new CBEO.TaxSvc.Security();
        
        taxSvc.Security.UsernameToken.Username  = taxConfig.UserName__c;
        taxSvc.Security.UsernameToken.Password  = taxConfig.Password__c;
        taxSvc.Profile                          = new CBEO.TaxSvc.Profile();
        taxSvc.Profile.Client                   = CLIENT_NAME;
        
        DateTime myDateTime = DateTime.now();
        CBEO.TaxSvc.GetTaxRequest gtreq = new CBEO.TaxSvc.GetTaxRequest();
        
        // Use the Handback for Doc Code for now.
        TaxCustomClass taxInputExtension    = (TaxCustomClass) inputs[0].Handback;
        gtreq.DocCode           = taxInputExtension.DocCode; 
        System.debug('callGetTax() gtreq.DocCode: ' + gtreq.DocCode);
        
        // SalesOrder, SalesInvoice, ReturnOrder, ReturnInvoice, PurchaseOrder, PurchaseInvoice
        gtreq.DocType           = DOCTYPE_SALESORDER;
        gtreq.CustomerCode      = taxInputExtension.CustomerCode;
        gtreq.ExemptionNo       = taxInputExtension.taxExemptionNumber;
        gtreq.BatchCode         = taxInputExtension.batchCode;
        gtreq.LocationCode      = taxInputExtension.locationCode;
        gtreq.CompanyCode       = taxConfig.CompanyCode__c;
        // Document (default), Line, Tax
        gtreq.DetailLevel       = DETAILLEVEL_TAX;
        
        // Setup the origin address info.   
        CBEO.TaxSvc.BaseAddress orgAddr = new CBEO.TaxSvc.BaseAddress();
        orgAddr.AddressCode     = ADDRESSCODE_ORIGIN;
        orgAddr.Line1           = taxConfig.Address1__c;
       // orgAddr.Line2           = taxConfig.Address2__c;
        orgAddr.Line2           = 'General Delivery';
        // orgAddr.Line3        = '[address line 3]';
        orgAddr.City            = taxConfig.City__c;
        orgAddr.Region          = taxConfig.StateCode__c;
        orgAddr.PostalCode      = taxConfig.PostalCode__c;
        
        // Get the Destination Address list together based on address inputs
        gtreq.Addresses = new CBEO.TaxSvc.ArrayOfBaseAddress();
        gtreq.Addresses.BaseAddress = new CBEO.TaxSvc.BaseAddress[inputs.size() + 1];
        
        // Origin goes in the first spot, Destinations go in the rest
        gtreq.Addresses.BaseAddress[0] = orgAddr;
        
        Integer inputIndex = 0;
        for (Apttus_Config2.CustomClass.TaxInput input : inputs) {  
            CBEO.TaxSvc.BaseAddress dstAddr = new CBEO.TaxSvc.BaseAddress();
            dstAddr.AddressCode     = ADDRESSCODE_DESTINATION + inputIndex;
            dstAddr.Line1           = inputs[inputIndex].TaxAddress.Street;
             dstAddr.Line2 = 'General Delivery';
            // dstAddr.Line3 = '[address line 3]';      
            dstAddr.City            = inputs[inputIndex].TaxAddress.City;
            dstAddr.Region          = inputs[inputIndex].TaxAddress.StateCode;
            dstAddr.PostalCode      = inputs[inputIndex].TaxAddress.PostalCode;
            
            gtreq.Addresses.BaseAddress[inputIndex + 1] = dstAddr;
            
            inputIndex++;
        }
        
        // Header Level Jurisdiction (not using, line level is used instead below)
        gtreq.Lines         = new CBEO.TaxSvc.ArrayOfLine();
        System.debug('callGetTax() inputs size: ' + inputs.size());
        gtreq.Lines.Line    = new CBEO.TaxSvc.Line[inputs.size()];
        
        // Go thru the input lines and map to Avalara input
        Integer lineIndex = 0;
        for (Apttus_Config2.CustomClass.TaxInput input : inputs) {
            
            taxInputExtension   = (TaxCustomClass)input.Handback;
            
            Apttus_Config2.CustomClass.TaxResult result = new Apttus_Config2.CustomClass.TaxResult();   
            // Add the handback object to correlate the result with the input
            result.Handback = input.Handback;
            // Compute tax based on tax code and tax address
            System.debug('callGetTax() TaxCode: '           + input.TaxCode);
            // Tax address
            System.debug('callGetTax() Street: '            + input.TaxAddress.Street);
            System.debug('callGetTax() City: '              + input.TaxAddress.City);
            System.debug('callGetTax() State: '             + input.TaxAddress.State);
            System.debug('callGetTax() StateCode: '         + input.TaxAddress.StateCode);
            System.debug('callGetTax() County: '            + input.TaxAddress.County);
            System.debug('callGetTax() PostalCode: '        + input.TaxAddress.PostalCode);
            System.debug('callGetTax() Country: '           + input.TaxAddress.Country);
            System.debug('callGetTax() CountryCode: '       + input.TaxAddress.CountryCode);     
            System.debug('callGetTax() TaxableAmount: '     + input.TaxableAmount);
            System.debug('callGetTax() CustomerCode: '      + taxInputExtension.CustomerCode);
            System.debug('callGetTax() ExemptionNo: '       + taxInputExtension.taxExemptionNumber);
            System.debug('callGetTax() BatchCode: '         + taxInputExtension.batchCode);
            System.debug('callGetTax() LocationCode: '      + taxInputExtension.locationCode);
            System.debug('callGetTax() OriginalTransDate: ' + taxInputExtension.originalTransDate);
            System.debug('callGetTax() OriginalDocCode: '   + taxInputExtension.originalDocCode);
            
            gtreq.Lines.Line[lineIndex] = new CBEO.TaxSvc.Line();
            gtreq.Lines.Line[lineIndex].No          = '' + lineIndex;
            gtreq.Lines.Line[lineIndex].ItemCode    = taxInputExtension.itemCode;
            gtreq.Lines.Line[lineIndex].Description = taxInputExtension.itemDescription;
            gtreq.Lines.Line[lineIndex].Ref1 = taxInputExtension.lineNumber;
            
            // Tax Code is required.  Put some values and let Avalara come back with zero.
            if (input.TaxCode == Null || input.TaxCode.trim().length() == 0 || input.TaxableAmount == Null ) {       
                gtreq.Lines.Line[lineIndex].TaxCode         = TAXCODE_NONE;
                gtreq.Lines.Line[lineIndex].Amount          = input.TaxableAmount;
                system.debug('###taxableamount='+input.taxableAmount);
                gtreq.Lines.Line[lineIndex].Qty             = 1;
              //  gtreq.Lines.Line[lineIndex].OriginCode      = ORIGINCODE_NONE;
              //  gtreq.Lines.Line[lineIndex].DestinationCode = DESTINATIONCODE_NONE;
                gtreq.Lines.Line[lineIndex].OriginCode      = 'Origin';
                gtreq.Lines.Line[lineIndex].DestinationCode = 'Destination0';
            
            // Presumably good input    
            } 
            /*else {    
                gtreq.Lines.Line[lineIndex].TaxCode     = input.TaxCode;
                gtreq.Lines.Line[lineIndex].Amount      = input.TaxableAmount;
                gtreq.Lines.Line[lineIndex].Qty         = 1.0;
                
                gtreq.Lines.Line[lineIndex].OriginCode      = gtreq.Addresses.BaseAddress[0].AddressCode;
                gtreq.Lines.Line[lineIndex].DestinationCode = gtreq.Addresses.BaseAddress[lineIndex + 1].AddressCode;
                
                // If negative, then this possibly is a return.  Check if there is reference to original doc and a original trans date.
                if (input.TaxableAmount < 0) {
                    if ((taxInputExtension.originalTransDate != Null) && (taxInputExtension.originalDocCode != Null)) {
                        System.debug('callGetTax() Return scenario');
                        CBEO.TaxSvc.TaxOverride TaxOverride  = new CBEO.TaxSvc.TaxOverride();
                        
                        TaxOverride.TaxOverrideType             = TAXOVERRIDETYPE_TAXDATE;
                        TaxOverride.TaxDate                     = taxInputExtension.originalTransDate;
                        TaxOverride.Reason                      = 'Credit on ' + taxInputExtension.originalDocCode;
                        System.debug('callGetTax(): ' + TaxOverride.TaxDate + ' : $' + input.TaxableAmount + ' : ' + TaxOverride.Reason);
                        gtreq.Lines.Line[lineIndex].TaxOverride = TaxOverride; 
                            
                    }
                }
                       
            }*/
            lineIndex++;
        }
        
        // Only commit when both commit flags are set
        if (taxConfig.EnableDocumentCommit__c) {
            if  (commitFlag == True) {
                gtreq.Commit_x  = commitFlag;
                gtreq.DocType   = DOCTYPE_SALESINVOICE;
            }
        } else {
            System.debug('callGetTax() Document Commit disabled. Please visit the Avalara Tax Connector Config settings to enable.');
        }
        
        // Make the call to GetTax()
        gtreq.DocDate   = Date.Today();
        CBEO.TaxSvc.GetTaxResult gtres = Null;
        String result = '';
        
        try {
             DateTime now = datetime.now();
             Long startTime = now.getTime();
             
             // Make the call.
             gtres = taxSvc.GetTax(gtreq);
             
             // Measure time
             now = datetime.now();
             Long endTime = now.getTime();
             Long roundTripTime = endTime - startTime;
             
             System.debug('callGetTax() Roundtrip time (Milliseconds): ' + roundTripTime);
             System.debug('callGetTax() Roundtrip time (Seconds): ' + roundTripTime/1000);
        
             if (RESULTCODE_SUCCESS.equals(gtres.ResultCode)) {
                 result = 'GetTax Succeeded - Total Tax: ' + gtres.TotalTax;
                 System.debug('callGetTax() GetTax Succeeded - Total Tax: ' + gtres.TotalTax);
                 inputIndex = 0;
                 
                 CBEO.TaxSvc.ArrayOfTaxLine arrayOfTaxLines = gtres.TaxLines;
                 List<CBEO.TaxSvc.TaxLine> taxLines = arrayOfTaxLines.TaxLine;
                 
                 System.debug('callGetTax() taxLines size: ' + taxLines.size());
                 
                 for (CBEO.TaxSvc.TaxLine taxLine : taxLines) {
                    
                    Apttus_Config2.CustomClass.TaxResult taxResult = new Apttus_Config2.CustomClass.TaxResult();
                        
                    // Add the handback object to correlate the result with the input
                    taxResult.Handback = inputs[inputIndex++].Handback;
                    
                    taxResult.TaxAmount = taxline.TaxCalculated;
                    System.debug('callGetTax() Line Tax Calculated: ' + taxline.TaxCalculated);
                    
                    taxResults.add(taxResult);
                 } 
             } else {
                 result = 'GetTax Failed: ' + gtres.ResultCode + ' : ' +
                     gtres.Messages.Message[0].Name + ' : ' + gtres.Messages.Message[0].Summary;
                 System.debug('callGetTax() ' + result);
             }
        }
        catch(Exception ex) {
             result = 'GetTax Threw an Exception: ' + ex.getmessage();
             System.debug('callGetTax() ' + result);
        }   
        
        return taxResults;  
    }
    
    
    /**
     * Callback invoked to call Avalara's CancelTax() API based on the given list of inputs
     * @param inputs the list of tax inputs
     * @return the list of tax results
     */
    global Static List<Apttus_Config2.CustomClass.TaxResult> cancelTax(List<Apttus_Config2.CustomClass.TaxInput> inputs) {
        
     /*   // Get Tax Connector Config Info
        TaxConnectorConfig__c taxConfig = TaxConnectorConfig__c.getInstance(CONFIG_AVALARA);
        
        // Prepare the return
        List<Apttus_Config2.CustomClass.TaxResult> results = new List<Apttus_Config2.CustomClass.TaxResult>();
        
        // Return if disabled
        if (!taxConfig.EnableAvaTax__c) {
            System.debug('cancelTax() AvaTax disabled. Please visit the Avalara Tax Connector Config settings to enable.');
            return results;
        }
        
        // Return if disabled
        if (!taxConfig.EnableDocumentCommit__c) {
            System.debug('cancelTax() Document Commit disabled. Please visit the Avalara Tax Connector Config settings to enable.');
            return results;
        }
        
        // Initialized the Tax Service with endpoint and credentials
        CBEO.TaxSvc.TaxSvcSoap taxSvc = new CBEO.TaxSvc.TaxSvcSoap(taxConfig.EndPoint__c);
        
        taxSvc.Security = new CBEO.TaxSvc.Security();
        
        taxSvc.Security.UsernameToken.Username  = taxConfig.UserName__c;
        taxSvc.Security.UsernameToken.Password  = taxConfig.Password__c;
        taxSvc.Profile                          = new CBEO.TaxSvc.Profile();
        taxSvc.Profile.Client                   = CLIENT_NAME;
        
        DateTime myDateTime = DateTime.now();
        
        // Handle multiple cancels
        for (Apttus_Config2.CustomClass.TaxInput input : inputs) {
            
            CBEO.TaxSvc.CancelTaxRequest ctreq = new CBEO.TaxSvc.CancelTaxRequest();
            // unique identifiers to locate the document to be Canceled:
            // DocCode+DocType+CompanyCode
            // Use the Handback for Doc Code for now.
            TaxCustomClass taxInputExtension    = (TaxCustomClass) input.Handback;
            ctreq.DocCode                       = taxInputExtension.DocCode;
            ctreq.DocType                       = DOCTYPE_SALESINVOICE;
            ctreq.CompanyCode                   = taxConfig.CompanyCode__c;
            // CancelCode = Unspecified, PostFailed, DocDeleted, DocVoided, AdjustmentCancelled
            ctreq.CancelCode = CANCELCODE_DOCVOIDED;
        
            String ResultMessage = '';
            CBEO.TaxSvc.CancelTaxResult ctres = null;
            
            try {
                Apttus_Config2.CustomClass.TaxResult result = new Apttus_Config2.CustomClass.TaxResult();
                
                // Make the call             
                ctres = taxSvc.CancelTax(ctreq);
    
                // Check the result
                if (RESULTCODE_SUCCESS.equals(ctres.ResultCode)) {
                    ResultMessage = 'CancelTax Succeeded';
                    System.debug('callGetTax() ' + ResultMessage);  
                } else {
                    ResultMessage = 'CancelTax Failed: ' + ctres.ResultCode + ' : ' + ctres.Messages.Message[0].Name +' : ' + ctres.Messages.Message[0].Summary;
                    System.debug('callGetTax() ' + ResultMessage);
                }
                
                // Add the handback object to correlate the result with the input
                TaxCustomClass outputHandback = new TaxCustomClass((TaxCustomClass)input.Handback);
                outputHandback.resultCode = ctres.ResultCode;
                
                result.Handback = outputHandback;
                results.add(result);
                
            } catch(Exception ex) {
                 ResultMessage = 'CancelTax Threw an Exception: ' + ex.getmessage();
                 System.debug('callGetTax() ' + ResultMessage);
            }
        }
        
        return results; 
        */
        return null;
    }
   
    
    /**
     * Callback to check Avalara service given credentials
     * @return true or false depending on if connection can be made
     */
    global Static boolean ping() {
        
/*        // Get Tax Connector Config Info
        TaxConnectorConfig__c taxConfig = TaxConnectorConfig__c.getInstance(CONFIG_AVALARA);
        
        // Return if disabled
        if (!taxConfig.EnableAvaTax__c) {
            System.debug('ping() AvaTax disabled. Please visit the Avalara Tax Connector Config settings to enable.');
            return false;
        }
        
        CBEO.TaxSvc.TaxSvcSoap taxSvc = new CBEO.TaxSvc.TaxSvcSoap(taxConfig.EndPoint__c);
        
        taxSvc.Security.UsernameToken.Username  = taxConfig.UserName__c;
        taxSvc.Security.UsernameToken.Password  = taxConfig.Password__c;
        taxSvc.Profile                          = new CBEO.TaxSvc.Profile();
        taxSvc.Profile.Client                   = CLIENT_NAME;
        
        CBEO.TaxSvc.PingResult pres = null;
        String result = '';
        
        try {
             pres = taxSvc.Ping(' ');
        }
        catch(Exception ex) {
             result = 'Test Connect Excepted: ' + ex.getmessage();
             System.debug('ping() ' + result);
             return false;
        }
        if(RESULTCODE_SUCCESS.equals(pres.ResultCode)) {
             result = 'TaxSvc Test Connect Successful - Avalara Service Version: ' + pres.Version;
             System.debug('ping() ' + result);
             return true;
             
        } else {
             result = 'TaxSvc Test Connect Failed: ' + pres.ResultCode +
                 ' : ' + pres.Messages.Message[0].Name + ' : ' + pres.Messages.Message[0].Summary;
             System.debug('ping() ' + result);
             return false;
        }
        return false;
        */ 
        return null;
    }
    
    
    /**
     * Callback to validate an address with Avalara
     * @param accountId is the id of the account
     * @param address is the address to validate
     * @param addressType type of address, 'Shipping' or 'Billing'
     * @param updateAddress is the flag to tell whether to update account with normalized address or not
     * @return true or false depending on if address was valid or not
     */
    global Static string validateAddress(ID accountId, Apttus_Config2.CustomClass.Address address, String addressType, Boolean updateAddress) {
        
     /*   List<Account>accountUpdates     = new List<Account>();
        Account accountUpdate           = Null;
        String result;
        
        // Get Tax Connector Config Info
        TaxConnectorConfig__c taxConfig = TaxConnectorConfig__c.getInstance(CONFIG_AVALARA);
        
        // Return if disabled
        if (!taxConfig.EnableAddressValidation__c) {
            return 'Address Validation Disabled.  Please visit the Avalara Tax Custom Config to enable Address Validation.';
        }
        
        System.debug('validateAddress() Street: '       + address.Street);
        System.debug('validateAddress() City: '         + address.City);
        System.debug('validateAddress() State: '        + address.State);
        System.debug('validateAddress() StateCode: '    + address.StateCode);
        System.debug('validateAddress() County: '       + address.County);
        System.debug('validateAddress() PostalCode: '   + address.PostalCode);
        System.debug('validateAddress() Country: '      + address.Country);
        System.debug('validateAddress() CountryCode: '  + address.CountryCode);
        
        // Make sure Address Country is not null
        if (address.Country == Null) {
            result = 'Address Country cannot be Null';
            System.debug('validateAddress() ' + result);
            return result;
        }
        
        // Check if the country is a valid country
        if (!(taxConfig.AllowableTaxCountries__c.containsIgnoreCase(address.Country))) {
            result = 'Address Validation is not enabled for the country you selected: ' + address.Country +
                 ' is not one of allowed countries.  Currently enabled countries are : ' + taxConfig.AllowableTaxCountries__c +
                 '. Please visit the Avalara Tax Connector Config settings to update the country list.';
             System.debug('validateAddress() ' + result);
             return result;
        }
        
        CBEO.AddressSvc.AddressSvcSoap addressSvc = new CBEO.AddressSvc.AddressSvcSoap(taxConfig.EndPoint__c);
        
        addressSvc.Security = new CBEO.AddressSvc.Security();
        addressSvc.Security.UsernameToken.Username  = taxConfig.UserName__c;
        addressSvc.Security.UsernameToken.Password  = taxConfig.Password__c;
        addressSvc.Profile.Client                   = CLIENT_NAME;  
        
        CBEO.AddressSvc.ValidateRequest vreq = new CBEO.AddressSvc.ValidateRequest();
        vreq.Address = new CBEO.AddressSvc.BaseAddress();
        vreq.Address.TaxRegionId    =   0;
        vreq.Coordinates            =   false;
        vreq.Taxability             =   false;
        vreq.TextCase               =   TEXTCASE_MIXED;
        
        vreq.Address.Line1      = address.Street;
        vreq.Address.City       = address.City;
        vreq.Address.Region     = address.State;
        vreq.Address.Country    = address.Country;
        vreq.Address.PostalCode = address.PostalCode;
        
        CBEO.AddressSvc.ValidateResult vres = null;
        
        try {
             vres = addressSvc.Validate(vreq);
        }
        catch(Exception ex) {
             result = 'Address Validation Excepted: ' + ex.getmessage();
        }
        
        if (RESULTCODE_SUCCESS.equals(vres.ResultCode))
        {
             result = 'Success. Validated Address: ' + vres.ValidAddresses.ValidAddress[0].Line1 + ' ' + vres.ValidAddresses.ValidAddress[0].Line4;
             
             System.debug('validateAddress() vres.ValidAddresses.ValidAddress[0].Line1: ' + vres.ValidAddresses.ValidAddress[0].Line1);
             System.debug('validateAddress() vres.ValidAddresses.ValidAddress[0].Line2: ' + vres.ValidAddresses.ValidAddress[0].Line2);
             System.debug('validateAddress() vres.ValidAddresses.ValidAddress[0].Line3: ' + vres.ValidAddresses.ValidAddress[0].Line3);
             System.debug('validateAddress() vres.ValidAddresses.ValidAddress[0].Line4: ' + vres.ValidAddresses.ValidAddress[0].Line4);
             
             // Update the Billing Address with normalized address from Avalara if flag is set
             if (updateAddress) {
                
                // Parse address  
                 List<String> addressParts = vres.ValidAddresses.ValidAddress[0].Line4.split(' ', 5);
                 
                 String street = vres.ValidAddresses.ValidAddress[0].Line1;
                 String zipCode = addressParts[addressParts.size() - 1];
                 String state   = addressParts[addressParts.size() - 2];
                 String city    = '';
                 
                 for (Integer i = 0; i < addressParts.size() - 2; i++) {
                    city += addressParts[i] + ' ';
                 }
                 city = city.trim();
                 
                 System.debug('validateAddress() street: '  + street);
                 System.debug('validateAddress() city: '    + city);
                 System.debug('validateAddress() state: '   + state);
                 System.debug('validateAddress() zip: '     + zipCode);
                 
                 // Update Shipping or Billing Address
                 if (ADDRESSTYPE_SHIPPING.equals(addressType)) {
                 
                     // Update account Shipping Address
                     accountUpdate = new Account (  
                        Id                  = accountId,
                        ShippingStreet      = street,
                        ShippingCity        = city,
                        ShippingState       = state,
                        ShippingPostalCode  = zipCode
                     );
                 } else {
                    
                     // Update account Billing Address
                     accountUpdate = new Account (  
                        Id                  = accountId,
                        BillingStreet       = street,
                        BillingCity         = city,
                        BillingState        = state,
                        BillingPostalCode   = zipCode
                     );
                 }
                 accountUpdates.add(accountUpdate);
                 update accountUpdates;
             } 
             System.debug('validateAddress() ' + result);  
             return result;
        
        } else {
             result = 'Address Validation Failed: ' + vres.ResultCode +
                 ' : ' + vres.Messages.Message[0].Name + ' : ' + vres.Messages.Message[0].Summary;
             System.debug('validateAddress() ' + result);
             return result;
        }*/
        return null;
    }
             
}