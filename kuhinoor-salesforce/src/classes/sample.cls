public class sample 
{
    public sample(ApexPages.StandardController controller) 
    {

    }   
    
    //Dynamic creation of Section Header
    public Component.Apex.SectionHeader getsecHead()
    {
        Component.Apex.SectionHeader sh = new Component.Apex.SectionHeader();
        sh.title = 'Create Account';
        return sh;
    }  
      
    //Dynamic creation of pageBlock
    public Component.Apex.PageBlock getformSample()
    {
        Component.Apex.PageBlock pageBlock = new Component.Apex.PageBlock();
      
        //Dynamic creation of inputField
        Component.Apex.InputField name = new Component.Apex.InputField();
        name.expressions.value = '{!Account.Name}';
        name.id = 'name';
        Component.Apex.OutputLabel label = new Component.Apex.OutputLabel();
        label.value = 'Name';
        label.for = 'name';
        
        //Dynamic creation of CommandButton
        Component.Apex.CommandButton save = new Component.Apex.CommandButton();
        save.value = 'Save';
        save.expressions.action = '{!Save}';


        pageBlock.childComponents.add(label);
        pageBlock.childComponents.add(name);
        pageBlock.childComponents.add(save);
        return pageBlock;
    }
    
}