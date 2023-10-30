public with sharing class BillBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    
    public List<Id> receivesBillByEmail = new List<Id>();
    
    public Database.QueryLocator start(Database.BatchableContext bc) {

        //this is a method that will query for all accounts that are active and have a value
        //for Bill_By_Email__c (Account.Active__c = \'Yes\' AND Bill_By_Email != null)

         String query = 'SELECT Id,Name,Bill_By_Email__c FROM Account WHERE Active__c = \'Yes\' AND Bill_By_Email__c != NULL';

         return Database.getQueryLocator(query);

    }

    public void execute(Database.BatchableContext bc, List<Account> scope){

        //this is a method that will process the queried for records by preparing
        //a list of account Ids (this.receivesBillByEmail) to carry over to the finish method.
        //we will do this by iterating over scope and checking whether Bill_By_Email__c == TRUE.
        //This method will also call our BillAPI.getBills() method.

        for(SObject sObj : scope) {

            Account accRec = (Account)sObj;

            if(accRec.Bill_By_Email__c) {

                receivesBillByEmail.add(accRec.Id);
            }
        }

        List<Bill__c> insertedBills = BillAPI.getBills();

        System.debug(':::::insertedBills:::::::'+insertedBills);

    }

    public void finish(Database.BatchableContext bc){

        //this is the final method of the class, that will be called after all processing in the
        //start and execute methods is complete. We will use this method to send an email to each
        //customer in the receivesBillByEmail list. First, we must query for the recently created bills for
        
       // Map<Id,Id> billMap = new Map<Id,Id>();
       // Map<Id,String> emailMap = new Map<Id,String>();
        Map<String,Blob> sendMap = new Map<String,Blob>();
        Map<String,List<Blob>> sendMapTest = new Map<String,List<Blob>>();

        System.debug(':::::::receivesBillByEmail::::::'+receivesBillByEmail);
       
       
        for(Account acc : [SELECT Id,Email__c, (SELECT Id FROM Bills__r ORDER BY CreatedDate DESC) 
                            FROM Account 
                            WHERE Id IN :receivesBillByEmail]) {

            if(!acc.Bills__r.isEmpty() && acc.Email__c != NULL ) {
            
                PageReference pageRef = new PageReference('/apex/BillVFP?id=' + acc.Bills__r[0].Id);
                Blob pdfBlob = pageRef.getContentAsPDF();
                sendMap.put(acc.Email__c,pdfBlob);
            }
        }

        if(!sendMap.isEmpty() ) {

            BillEmailer.sendEmails(sendMap);

        } 
    }
}