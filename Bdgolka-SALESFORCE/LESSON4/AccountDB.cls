/**
 * This class returns collections of three types from Database,
 * namely : Order__c, Rate__c, Account 
 * @author Julia Pulova
 * */

public class AccountDB {
         
        public static List<Order__c> getOrder(){
            return [SELECT Name from Order__c];
        }
    
        public static List <Account> getAccount(){
        return [SELECT Name from Account ];
        }
    
       public static List <Rate__c> getRate(){
       return [SELECT Name FROM Rate__c];         
        }
}