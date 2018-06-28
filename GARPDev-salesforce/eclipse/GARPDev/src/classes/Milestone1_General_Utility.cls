public with sharing class Milestone1_General_Utility 
{
    public static String processTaskName(String name)
    {
        String nameString = name;
        if(nameString.length() >= 80)
        {
            nameString = nameString.subString(0,76);
            Integer lastSpaceLocation = Milestone1_General_Utility.truncateStringAtSpace(nameString);
            if(lastSpaceLocation > -1)
            {
                nameString = nameString.subString(0,lastSpaceLocation);
            }
            nameString = namesTring + '...';
        }
        return nameString;
    }
    
    public static Integer truncateStringAtSpace(String inputString)
    {
        Integer location = inputString.lastIndexOf(' ');
        return location;
    }
    
    static testMethod void testTruncateString()
    {
        String example = 'NEW DESCRIPTION 1234567890 ABCDEFGHIJKLMNOPQRSTUVWXYZ THIS IS LONG DESCRIPTION GREATER THAN 80 CHARACTER LIMIT FOR NAME TEST TRUNCATING';
        String nameString = Milestone1_General_Utility.processTaskName(example);
        system.AssertEquals('NEW DESCRIPTION 1234567890 ABCDEFGHIJKLMNOPQRSTUVWXYZ THIS IS LONG...',nameString);
    } 
    
}