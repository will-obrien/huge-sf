/* Developer   : Keerthi Chandra
 * DateTime    : 11-05-16
 * Description : Utility class to perform DML operations which makes the code re-usable.
 * Status      : Developed
 */
 
 Public class Utility
 {
     ///<OBJECTIVE>
     ///Update records
     ///<OBJECTIVE>
     public static List<sObject> updtSObject(List<sObject> updtSObjct)
     {
         UPDATE updtSObjct;
         RETURN updtSObjct;
     }
     ///<OBJECTIVE>
     ///Update records
     ///<OBJECTIVE>
     public static report ftchRprt(String strRprtName)
     {
         RETURN [SELECT id,
                        name
                        FROM Report 
                        WHERE name =: strRprtName];
     }
 }