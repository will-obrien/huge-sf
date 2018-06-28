@isTest
public class SelectFieldOptionsFromTextGeneratorTest {

    static testMethod void dropDownTest() {       
        SelectFieldOptionsFromTextGenerator options = new SelectFieldOptionsFromTextGenerator();
        options.ListType = 'DropDown';
        options.OptionsText = '*A \r\n B \r\n C';
        options.Required = false;
        options.getItems();              
    }
    
    static testMethod void dropDownNoValuesTest() {       
        SelectFieldOptionsFromTextGenerator options = new SelectFieldOptionsFromTextGenerator();
        options.ListType = 'DropDown';
        options.OptionsText = '';
        options.Required = false;
        options.getItems();              
    }
    
    static testMethod void radioTest() {      
        SelectFieldOptionsFromTextGenerator options = new SelectFieldOptionsFromTextGenerator();
        options.ListType = 'Radio';
        options.OptionsText = 'A|a \r\n B|b \r\n C|c ';
        options.Required = false;
        options.getItems();              
    }
    
    static testMethod void otherTest() {      
        SelectFieldOptionsFromTextGenerator options = new SelectFieldOptionsFromTextGenerator();
        options.ListType = 'Radio+Other';
        options.OptionsText = 'A \r\n B \r\n C';
        options.Required = false;
        options.getItems();              
    }
}