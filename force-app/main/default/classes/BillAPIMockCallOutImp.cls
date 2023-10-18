global class BillAPIMockCallOutImp implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        String bdy =  '[{"billId": "testbillId1234567","accountName": "Account Test1","balance": "$376.08"},';
        bdy += '{"billId": "testbillId1234342","accountName": "Account Test3","balance": "$100.08"},';
        bdy += '{"billId": "testbillId1234345","accountName": "Account Test5","balance": "$200.08"}]';

        res.setBody(bdy);
        res.setStatusCode(200);
        return res;
    }
}