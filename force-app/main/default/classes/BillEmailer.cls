public with sharing class BillEmailer {
    
    public static void sendEmails(Map<String, Blob> emailsWithBills) {

        //iterate over the keyset of the emailsWithBills map and instantiate a single Messaging.SingleEmailMessage
        //object. Set the bccAddress to the email from the iteration, set a PlainTextBody, and set a Subject for the
        //Messaging.SingleEmailMessage object.

        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>(); //Added by Maha

        for(String email : emailsWithBills.keySet()) {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); //Added by Maha

            String msgBody = 'Dear Client,\n\n';
            msgBody += 'We are contacting you in regard to a new bill that has been created on your account.The bill has been attached as a PDF in this email.';
            msgBody += 'Kindly make the payment for the bill using the provided payment details in this email.\n\n';
            msgBody += 'Regards\n';
            msgBody += UserInfo.getFirstName() +' '+userinfo.getLastName();

            mail.setPlainTextBody(msgBody);
            String sub = 'Bill-' + Date.Today().Month() + '-' + Date.Today().Day() + '-' + Date.Today().Year();
            mail.setSubject(sub);

            List<string> emailList = new List<string>();
            emailList.add(email);
            mail.setBccAddresses(emailList);

            //use the following
            //to attach the PDF blob to the email:
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.Body = emailsWithBills.get(email);
            attach.FileName = 'Bill-' + Date.Today().Month() + '-' + Date.Today().Day() + '-' + Date.Today().Year() + '.pdf';
            attach.ContentType = 'application/pdf';

            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});

            emailsToSend.add(mail); //Added by Maha

            //add the Messaging.SingleEmailMessage object to the list inside of the loop, and send the email outside of the loop.

        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailsToSend);
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }

    //this is a method that will allow you to check to see if your code works.
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {

        Boolean sendResult = true;
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {

            if (res.isSuccess()) {
                
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        return sendResult;
    }

    @InvocableMethod( label='send Recent Bill' description='send Recent bill of an account' category='Account')
    public static List<String> sendRecentBillfromFlow (List<Id> AccId){

        List<String> errMsg ;

       Bill__c RecentBill = [SELECT Id,Name,Account__r.Email__c FROM Bill__c WHERE Account__c IN :AccId ORDER BY CreatedDate DESC LIMIT 1];
        System.debug('::::RecentBill:::::::'+RecentBill);

        if(RecentBill != NULL && RecentBill.Account__r.Email__c != NULL) {

            PageReference pageRef = new PageReference('/apex/BillVFP?id=' + RecentBill.Id);

            Blob pdfBlob = pageRef.getContentAsPDF();
            Map<String, Blob> testBlob = new Map<String,Blob>{RecentBill.Account__r.Email__c => pdfBlob};
            
            sendEmails(testBlob);
            
        }else {

            //errMsg = 'Please make sure that you added bill record and email address for the account';
            errMsg = new List<String>{'Please make sure that you added bill record and email address for this account'};
        }

        return errMsg;

    } 
}