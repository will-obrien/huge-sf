public with sharing class TemplateListPopUpController {

Public List<EmailTemplate> LstTemplate{get;set;}
    public string FormTag{get;set;}

    public string TextBox{get;set;}
    
     public string Program{get;set;}
     
     public string searchstr{get;set;}
     
    public TemplateListPopUpController ()
    {
        
       
    
        FormTag=system.currentPagereference().getParameters().get('frm');
        TextBox=system.currentPagereference().getParameters().get('txt');
        Program=system.currentPagereference().getParameters().get('SelectedProgram');
        searchstr=system.currentPagereference().getParameters().get('lksrch');
        LstTemplate=[SELECT Id, TemplateStyle, Name, TemplateType, Encoding FROM EmailTemplate  ];
        if(Program!=null && Program!= '' && searchstr!=null && searchstr!='')
        {
            if(Program!=null && Program!= '' && (searchstr==null || searchstr==''))
            {
            //LstTemplate=[SELECT Id, TemplateStyle, Name, TemplateType, Encoding FROM EmailTemplate where Name LIKE :('%'+Program+'%')];
            }
            else if((Program==null && Program== '') && (searchstr!=null || searchstr!=''))
            {
            
            }
            else
            {
            
            }
        }
        else
        {
        
         
        }
        
}
}