@isTest
public class TestDataFactory {

    public static List<Account> createAccounts(Integer numAccts) {

        List<Account> acctList = new List<Account>();

        for(Integer i=0; i<numAccts; i++) {

            Account accRec = new Account(Name='Account Test' + i);

            if(math.mod(i,2) == 0) {

                accRec.Active__c = 'No';
                accRec.Bill_By_Email__c = FALSE;

            }else {

                accRec.Active__c = 'Yes';
                accRec.Bill_By_Email__c = TRUE;
                accRec.Email__c = 'accountTest'+i+'@gmail.com';
            }

            acctList.add(accRec);
        }

        insert acctList;
        
        return acctList;
    }
}