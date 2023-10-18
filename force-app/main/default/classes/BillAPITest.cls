@isTest
private class BillAPITest {
    @isTest static void testBillApIMethod() {

        Account[] accts = TestDataFactory.createAccounts(8);

        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new BillAPIMockCallOutImp());
        List<Bill__c> billRecs = BillAPI.getBills();
        Test.stopTest();

        System.debug(':::::::billRecs::::::'+billRecs);

        //need to add assert equals
    }
}