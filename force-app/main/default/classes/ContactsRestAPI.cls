@RestResource(urlMapping='/api/Account/*')
global with sharing class ContactsRestAPI {
    
    @HttpGet
    global static List<Contact> getContacts() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String AccId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Contact> contList = [SELECT  Name,MailingAddress, Phone,Email FROM Contact WHERE AccountId = :AccId];
        return contList;
    }
}