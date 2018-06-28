/* Developer   : Keerthi Chandra
 * DateTime    : 13-05-16
 * Description : Send the standard report as csv file attachment.
 * Status      : Developed
 */
global class K_ReportEmailCSVAttchmnt implements System.Schedulable 
{
    ///<OBJECTIVE>
    /// Send the report as attachment in csv format.
    ///<OBJECTIVE>
    global void execute(SchedulableContext sc) 
    {
        Report rprt = new Report();
        rprt = Utility.ftchRprt(System.Label.Report);
        ApexPages.PageReference report = new ApexPages.PageReference('/'+rprt.id+'?csv=1');
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.setFileName('report.csv');
        attachment.setBody(report.getContent());
        attachment.setContentType('text/csv');
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setFileAttachments(new Messaging.EmailFileAttachment[] { attachment } );
        message.setSubject('Planned Campaigns Report');
        message.setPlainTextBody('The report is attached.');
        message.setToAddresses( new String[] {System.Label.Emails} );
        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { message } );
    }
}