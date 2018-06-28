public class EmailHelper {
    final String subject;
    
    public EmailHelper(String subject) {
        this.subject = subject;
    }
    
    public Messaging.SingleEmailMessage newEmail(string toAddress, Id userId, Date activityDate, String status, Id ownerId, Id taskId) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        String body = '<style>p{margin-top:0px; margin-bottom:0px;}</style><body class="setupTab"  style=" background-color:#003333; bLabel:body; bEditID:b1st1;"><center ><table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" ><tr valign="top" ><td  style=" vertical-align:top; height:100; text-align:left; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;"></td></tr><tr valign="top" ><td  style=" height:5; background-color:#AAAAFF; bLabel:accent1; bEditID:r2st1;"></td></tr><tr valign="top" ><td styleInsert="1" height="300"  style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;"><table height="400" width="550" cellpadding="5" border="0" cellspacing="5" ><tr height="400" valign="top" ><td style=" color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;" tEditID="c1r1" aEditID="c1r1" locked="0" ><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">You have pending tasks:</div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><br></div><blockquote style="margin: 0 0 0 40px; border: none; padding: 0px;"><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">Due Date: ';
        body = body + activityDate + '</div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><font face="arial">Subject: ' + this.subject + '</font></div><div><font face="arial">Status: ';
        body = body + status + '</font></div><div><font face="arial">Owner Id: ' + ownerId + '</font></div><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;">Task Id: ' + taskId + '<span style="font-size: 12pt;"></span></div></blockquote><div style="color: rgb(0, 0, 0); font-family: arial; font-size: 12pt;"><font face="arial"><br></font></div></td></tr></table></td></tr><tr valign="top" ><td  style=" height:5; background-color:#AAAAFF; bLabel:accent2; bEditID:r4st1;"></td></tr><tr valign="top" ><td  style=" vertical-align:top; height:100; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;"></td></tr><tr valign="top" ><td  style=" height:0; background-color:#003333; bLabel:accent3; bEditID:r6st1;"></td></tr></table></center><br><br>';
        
        
        String[] sendingTo = new String[]{toAddress};
        email.setToAddresses(sendingTo);
        
        email.setUseSignature(false);
        email.setSaveAsActivity(false);
        email.setSenderDisplayName(UserInfo.getOrganizationName());
        email.setTargetObjectId(userId);
        
        email.setSubject(subject);
        email.setHtmlBody(body);

        return email;
    }
}