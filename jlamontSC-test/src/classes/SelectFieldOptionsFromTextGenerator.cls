/*
 * SelectFieldOptionsFromTextGenerator
 * String -- OptionsText -- the text that contains the values and labels
 * String -- ListType 	 -- the type of list this is 
 * 	(Select, Checkbox, Radio, Select+Other, Checkbox+Other, Radio+Other)
 * Boolean -- Required 	 -- is a value required.
 * 
 * Turning a text field response into a set of options
 * for Select, Radio, or Checkboxes.
 * Text is of undetermined length
 * Individual options separated by \n line breaks
 * Individual lines can represent label value and default
 * Value and Label are separated by |
 * Value comes first.
 * If no | is present text will be the same for both
 * Default is done by hijacking the <disabled> parameter of the options constructor
 * 		This requires having a bit of JS on the front end
 * 		that will turn off the disabling of the option and
 * 		make it selected.
 * 		Default is indicated with an *
 *
 * Example:
 * 		1|One
 * 		*2|Two
 * 		3|Three
 * 		4|Four
 * 
 * 		Two would be the selected option on the front end.
 * 
 * 		For select drop downs a "choose an item" is added first
 * 		For option boxes with +other, an other option is added at the end.
*/
public class SelectFieldOptionsFromTextGenerator {
    public String OptionsText {get; set;}
    public String ListType {get; set;}
    public Boolean Required {get; set;}
    
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        if (OptionsText == '') {
            options.add(new SelectOption('','This event is broken. No options to choose from for this question type.'));
            options.add(new SelectOption('1','This event is broken. No options to choose from for this question type.'));
        } else {
	        string [] textOptions = OptionsText.split('\n');
        
            // for select lists, we want a no value option
            // at the top of the list. (otherwise the first item would be selected)
            if (textOptions.size() > 0 && ListType.indexOf('DropDown') == 0) {
                // value has to be set to empty.
                options.add(new SelectOption('','Click to choose'));
            }
            
            // for non required radio lists, we want a way to deselect.
            // at the top of the list. (otherwise the first item would be selected)
            if (textOptions.size() > 0 && !Required && ListType.indexOf('Radio') == 0) {
                // value has to be set to empty.
                options.add(new SelectOption('','No response', true));
            } 
    
            string [] optionValueLabel;
            string finalOption = '';
            string optionValue;
            string optionLabel;
            boolean optionDefault = false;
            
            // look at each item of the array of text.
            for (string textOption : textOptions) {

                optionDefault = false;
                // look to see if label and value are indicated.
                finalOption = textOption.trim();
                optionValueLabel = finalOption.split('\\|');
                if (optionValueLabel.size()==1) {
                    optionValue = optionValueLabel[0].trim();
                    // if there is a default make sure it does
                    // not appear in the label.
                    optionLabel = optionValueLabel[0].replace('*','').trim();
                } else {
                    optionValue = optionValueLabel[0].trim();
                    optionLabel = optionValueLabel[1].trim();
                }
                
                // look to see if a default is indicated
                if(optionValue.indexOf('*')==0) {
                    optionDefault = true;
                    // make sure to get rid of the asterix
                    optionValue = optionValue.replace('*','');
                }
                // add the selection option.
                // default uses the "disabled" parameter
                // front end JS looks for this, enables it, and
                // selects or checks the option.
                options.add(new SelectOption(optionValue,optionLabel,optionDefault));
            } // end for loop.
            
            // if the type of list includes other
            // we make this available in the list.
            if (textOptions.size() > 0 && ListType.indexOf('Other') > -1) {
                options.add(new SelectOption('Other','Other'));
            }         
            
        }
        
        return options;
    }
    
}