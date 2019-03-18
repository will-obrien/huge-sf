public class SamplePick 
{

    public Date datee { get; set; }
    public String state {get;set;}
    public String city {get;set;}
    public String phase {get;set;}

    public List<SelectOption> getStates()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('TN','Tamil Nadu'));
        options.add(new SelectOption('KL','Kerala'));
        return options;
    } 
    
    public List<SelectOption> getPhases()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('P1','P1'));
        options.add(new SelectOption('P2','P2'));
        options.add(new SelectOption('P3','P3'));
        return options;
    }
    
    public List<SelectOption> getCities()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(state == 'TN')
        {       
            options.add(new SelectOption('CHE','Chennai'));
            options.add(new SelectOption('CBE','Coimbatore'));
        }
        else if(state == 'KL')
        {       
            options.add(new SelectOption('COA','Coachin'));
            options.add(new SelectOption('MVL','Mavelikara'));
        }
        else
        {
            options.add(new SelectOption('None','--- None ---'));
        }      
        return options;
    }       

}