public class Randomizer {
    
    //returns random number in provided range 
    public static integer getRandomRange(integer min, integer max)
    {
        return (integer)(Math.floor(Math.random() * (max - min + 1) + min));
    }

     //returns a random Integer
     public static Integer getRandomNumber(Integer size){
          Double d = math.random() * size;
          return d.intValue();
     }

     //returns either true or false randomly
     public static Boolean getRandomBoolean(){
          if(math.mod(getRandomNumber(10),2) == 0){
               return true;
          }
          else{
               return false;
          }
     }

     //Get's a random value from a list of strings
     public static String getRandomString(List<String> strings){
          List<Double> ranks = new List<Double>();
          Map<Double,String> rankMap = new Map<Double,String>();

          for(String s : strings){
               Boolean isDup = true;
               Double rank;

               While(isDup){
                    Double x = getRandomNumber(100000);
                    if(!rankMap.containsKey(x)){
                         rank = x;
                         isDup = false;
                    }
               }

               ranks.add(rank);
               rankMap.put(rank,s);
          }

          ranks.sort();
          return rankMap.get(ranks.get(0));
     }

     //Returns a random picklist value 
     public static string getRandomPickListValue(Sobject s_object, String field_name, Boolean allow_blank){
          List<String> Strings = new List<String>();
          if(allow_blank){
               String b = '';
               Strings.add(b);
          }
            Schema.sObjectType sobject_type = s_object.getSObjectType();
            Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
            Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
            List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues();
            for (Schema.PicklistEntry a : pick_list_values) {
                Strings.add(a.getValue());
            }
            return getRandomString(Strings);
     }

     //returns a map of all picklists and multiselect picklists for a givien object
     //the keyset is the field name using proper case
     public static Map<String,List<String>> getPicVals(sObject s_object){
          Map<String,List<String>> valueMap = new Map<String,List<String>>();
          Schema.sObjectType sobject_type = s_object.getSObjectType();
          Schema.DescribeSObjectResult r = sobject_type.getDescribe();
          Map<String, Schema.SObjectField> field_map = r.fields.getMap();

          for(String s : field_map.keyset()){
               List<String> strings = new List<String>();
               Schema.DescribeFieldResult F = field_map.get(s).getDescribe();
               if(f.GetType() == Schema.DisplayType.Picklist || f.GetType() == Schema.DisplayType.MultiPicklist){
                    List<Schema.PicklistEntry> pick_list_values = field_map.get(s).getDescribe().getPickListValues();
                    for (Schema.PicklistEntry a : pick_list_values) {
                         strings.add(a.getValue());
                   }
                   valueMap.put(String.valueOf(field_map.get(s)),strings);
               }
          }
          return valueMap;
     }

     //Returns Lorem Ipsum placeholder text.
     public static String getPlaceholderText(Integer length){
          String firstSentence = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ';
          List<String> sentenceList = new List<String>();
          sentenceList.add('Vivamus nec lacus eget massa cursus pulvinar. ');
          sentenceList.add('Morbi vel odio eget nunc auctor posuere eget eget ante. ');
          sentenceList.add('Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. ');
          sentenceList.add('Pellentesque lacus eros. ');
          sentenceList.add('Sed suscipit tristique varius. ');
          sentenceList.add('Mauris ultricies, nibh eu fermentum accumsan, justo quam pulvinar tellus, sed tempor quam eros sit amet ante. ');
          sentenceList.add('Duis mi libero, cursus nec facilisis ut, commodo eget nunc. ');
          sentenceList.add('Nulla eros augue, iaculis sed volutpat et, sagittis quis sem. ');
          sentenceList.add('Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla placerat accumsan vulputate. ');
          sentenceList.add('Fusce placerat tellus eget tellus faucibus a gravida sapien fermentum. ');

          String s = firstSentence;

          while (s.length() < length+1){
               s += getRandomString(sentenceList);
          }

          s = s.trim();

          while (s.length() >= length-1){
               s = s.substring(0,s.length()-1).trim();
          } 

          s = s.substring(0,s.length()-1).trim();
          s += '.';
          return s;
     }

     
}