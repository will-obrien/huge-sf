/*
@ Description :
*/
@isTest
Public Class testbulkAcccountInsertWithContact{
    Static testMethod void demo(){
    
        bulkAcccountInsertWithContact bcon = new bulkAcccountInsertWithContact();
        
       
        
        bcon.rowIndex=1;
        bcon.addModelRow();
        bcon.addconrow();
       
        Account account = new Account(name='test');     
        
        
        Contact con = new Contact();
        con.lastname='test';
        //insert con;
        
         bulkAcccountInsertWithContact.model md = new bulkAcccountInsertWithContact.model();
         md.acc=account;
         
         md.conList= new List<contact>{con};
         bcon.mdlList = new List<bulkAcccountInsertWithContact.model>{md};
         bcon.mdconList = new List<bulkAcccountInsertWithContact.model>{md};
        bcon.save();
        bcon.extra();
    }
    
}