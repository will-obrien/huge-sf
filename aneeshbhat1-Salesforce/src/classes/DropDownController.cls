public with sharing class DropDownController {

     @AuraEnabled
    public static string getDropDownValues(string SelectedDropDownSource,string SelectedDropDownType) {
        system.debug('-------------------------------' + SelectedDropDownType );
        system.debug('-------------------------------' + SelectedDropDownSource );
        if(SelectedDropDownSource.trim().toUpperCase()=='PRODUCT')
        {
             return JSON.serialize(GetPrograms());
        }
        else
        {
            return null;
        }
    }
    
    
    @AuraEnabled
    public static string getUniqueComponentId() 
    {
        system.debug('Hello Arjun');
        Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
        string UniqueId=h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
         system.debug('Hello Arjun'+UniqueId);
		return UniqueId;
    }
    
     @AuraEnabled
    public static string LoadDependentDropDownValues(string SelectedDropDownSource,string ControllingField,string ControllingFieldValues) 
    {
        List<string> ProgramList=new List<string>();
        system.debug('-------------------------------' + SelectedDropDownSource );
        system.debug('-------------------------------' + ControllingField );
        if(ControllingField.trim().toUpperCase()=='PRODUCT' && SelectedDropDownSource=='Program')
        {
            system.debug('-------------------------------' + ControllingFieldValues );
           ProgramList= GetProgramsForProducts(ControllingFieldValues);
        }
         return JSON.serialize(ProgramList);
    }
    
    private static List<string> GetPrograms()
    {
        List<string> lstPrograms=new List<string>();
        lstPrograms.add('APP');
         lstPrograms.add('CLT');
         lstPrograms.add('EF');
         lstPrograms.add('HSY');
         lstPrograms.add('LS');
         lstPrograms.add('LSP');
         lstPrograms.add('SCH');
  
        return lstPrograms;
    }
    
    Private static List<string> GetProgramsForProducts(string selectedProducts)
    {
        
        String[] SelectedproductList = selectedProducts.split('\\,');
        List<string> Programs=new List<string>();
         Programs.clear();
        
				for (String Product : SelectedproductList) 
                {
    				if(Product.trim().toUpperCase()=='APP')
                    {
                        //Programs.clear();
                        Programs.add('HUG');
                        Programs.add('AY');
                        Programs.add('MLY');
                        Programs.add('PRW');
                    }
                    else if(Product.trim().toUpperCase()=='CLT')
                    {
                        //Programs.clear();
                        Programs.add('EFC');
                        Programs.add('LOCAL');
                        //ProgramsList.put(Product.trim().toUpperCase(),Programs);
                    }
                     else if(Product.trim().toUpperCase()=='EF')
                    {
                        //Programs.clear();
                        Programs.add('EF');
                       // ProgramsList.put(Product.trim().toUpperCase(),Programs);
                    }
                   else if(Product.trim().toUpperCase()=='HSY')
                    {
                       // Programs.clear();
                        Programs.add('HSY');
                        Programs.add('PSP');
                        //ProgramsList.put(Product.trim().toUpperCase(),Programs);
                    }
                   else if(Product.trim().toUpperCase()=='LS')
                    {
                        //Programs.clear();
                        Programs.add('ILS');
                        Programs.add('CC');
                        //ProgramsList.put(Product.trim().toUpperCase(),Programs);
                    }
                   else if(Product.trim().toUpperCase()=='LSP')
                    {
                        //Programs.clear();
                        Programs.add('ILSP');
                        Programs.add('AYP');
                        Programs.add('MLYP');
                        Programs.add('EXC');
                       // ProgramsList.put(Product.trim().toUpperCase(),Programs);
                    }
                   else if(Product.trim().toUpperCase()=='SCH')
                    {
                        //Programs.clear();
                        Programs.add('ILC');
                        Programs.add('JU');
                        Programs.add('LT');
                        Programs.add('PW');
                        //ProgramsList.put(Product.trim().toUpperCase(),Programs);
                    }
                    else
                    {
                        // Programs.clear();
                        Programs.add('--None--');
                        //ProgramsList.put(Product.trim().toUpperCase(),Programs);
                    }
				}
     
        
        return Programs;
            
    }
}