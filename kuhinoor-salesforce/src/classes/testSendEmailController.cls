@isTest
Public Class testSendEmailController{
    Static testmethod void demo(){
        SendEmailController snd = new SendEmailController();
       // snd.to.add('test');
        snd.subject='testSub';
        snd.body='testbody';
        snd.testing='testing';
        snd.SendMailToStudent();
    }
}