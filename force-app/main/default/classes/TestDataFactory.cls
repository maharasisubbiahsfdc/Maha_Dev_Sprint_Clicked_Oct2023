@isTest
public class TestDataFactory {

    public static List<Account> createAccounts(Integer numAccts) {

        List<Account> acctList = new List<Account>();

        for(Integer i=0; i<numAccts; i++) {

            Account accRec = new Account(Name='Account Test' + i);

            if(math.mod(i,2) == 0) {

                accRec.Active__c = 'No';

            }else {

                accRec.Active__c = 'Yes';
                
            }

            acctList.add(accRec);
        }

        insert acctList;
        
        return acctList;
    }
}