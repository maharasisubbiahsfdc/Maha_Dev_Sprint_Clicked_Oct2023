public with sharing class BillAPI {

    public static String errormessage;
    
    public static List<Bill__c> getBills() {

        //create a list of bills to insert
        List<Bill__c> billsToBeCreated = new List<Bill__c>(); //Added by Maha

        try {
            //start by creating an HttpRequest object and set the endpoint and method.
            HTTPResponse billResponse = billingCallout();  //Added by Maha

            System.debug(':::::billresponse::::::::'+billResponse);

            if((billResponse != NULL)) {

                String responseBody = billResponse.getBody();
                System.debug(':::::responseBody::::::::'+responseBody);

                //Use the following to deserialize the JSON response into a wrapper class:
        
                List<BillWrapper> billingWrapperList = (List<BillWrapper>)JSON.deserialize(responseBody, List<BillWrapper>.class);

                System.debug(':::::billingWrapperList::::::::'+billingWrapperList);

                Map<String,Id> BillingAcctMap = new Map<String,Id>();

                for(Account acc : [SELECT Id,Name FROM Account WHERE Active__c = 'Yes']) {

                    System.debug(':::::billresponse::::::::'+billResponse);
                    BillingAcctMap.put(acc.Name,acc.Id);

                }

                System.debug(':::::BillingAcctMap::::::::'+BillingAcctMap);

                for(BillWrapper bw : billingWrapperList){

                    System.debug(':::::bw::::::::'+bw);

                    if(String.isNotBlank(bw.accountName) && BillingAcctMap.containskey(bw.accountName) ) {

                        Bill__c newBillRec = new Bill__c(Account__c = BillingAcctMap.get(bw.accountName) );
                        newBillRec.Balance__c = Decimal.valueOf(bw.balance.replace('$', ''));
                        newBillRec.Bill_Id__c = bw.billId;

                        billsToBeCreated.add(newBillRec);

                        System.debug(':::::newBillRec::::::::'+newBillRec);

                    }

                }

                //finally, insert the new bills list
                if(billsToBeCreated.size() > 0) {

                    insert billsToBeCreated;
                    System.debug(':::::billsToBeCreated::::::::'+billsToBeCreated);
                }
            }

        return billsToBeCreated;

        } catch (Exception e) {

            System.debug(':::::error::::::::::'+e.getMessage());
            errormessage = e.getMessage();

            return null;

        }

    }

    public static HTTPResponse billingCallout() {

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Billing_API');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug(res.getBody());

        return res;
    }
   
    
    public class BillWrapper {

        public String billId;
        public String accountName;
        public String balance;
    }
}