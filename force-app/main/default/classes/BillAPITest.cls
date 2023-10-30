@isTest
private class BillAPITest {
    @isTest static void testBillApIMethod() {

        Account[] accts = TestDataFactory.createAccounts(8);

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new BillAPIMockCallOutImp());
        List<Bill__c> billRecs = BillAPI.getBills();
        Test.stopTest();

        System.debug(':::::::billRecs::::::'+billRecs);

        System.assertEquals(accts[1].Id, billRecs[0].Account__c);

        //need to add assert equals
    }

    @isTest static void testBillBatchMethod() {

        Account[] accts = TestDataFactory.createAccounts(8);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BillAPIMockCallOutImp());
        BillBatch batch = new BillBatch() ;
        ID batchId = Database.executeBatch(batch);
        Test.stopTest();

        List<Id> accIdList = new List<Id>();
        accIdList.add(accts[1].Id);

        List<String> resMsg = BillEmailer.sendRecentBillfromFlow(accIdList);
        System.assertEquals(NULL, resMsg);


    }

    @isTest static void testBillSchedulerMethod() {

        Account[] accts = TestDataFactory.createAccounts(8);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BillAPIMockCallOutImp());
        BillScheduler sh1 = new BillScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Bill Scheduler', sch, sh1); 
        Test.stopTest();
    }
}