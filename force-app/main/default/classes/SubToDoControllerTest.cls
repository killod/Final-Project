@IsTest
private class SubToDoControllerTest {

    @IsTest
    static void createSubToDosTest() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', true);
        String jsonString = '[ {\n' +
                '  "SameToDoId" : "' + toDo.Id + '",\n' +
                '  "SubToDo" : {\n' +
                '    "Name" : "Test",\n' +
                '    "Description__c" : "",\n' +
                '    "Completed__c" : false,\n' +
                '    "SameSubToDoId__c" : "a015g00000XflBKAAZ",\n' +
                '    "ToDo__c" : "' + toDo.Id + '"\n' +
                '  }\n' +
                '} ]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SubToDo__c/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        SubToDoController.createSubToDos();
        Test.stopTest();
        List<SubToDo__c> subToDos = [SELECT Id, Name, Description__c, Completed__c, ToDo__c, SameSubToDoId__c  FROM SubToDo__c];
        System.assertEquals(1, subToDos.size());
        System.assertEquals('Test', subToDos.get(0).Name);
        System.assertEquals(false, subToDos.get(0).Completed__c);
        System.assertEquals(null, subToDos.get(0).Description__c);
        System.assertEquals(toDo.Id, subToDos.get(0).ToDo__c);
        System.assertEquals('a015g00000XflBKAAZ', subToDos.get(0).SameSubToDoId__c);
    }


    @IsTest
    static void createSubToDos2Test() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', true);
        toDo.SameToDoId__c = toDo.Id;
        update toDo;
        String jsonString = '[ {\n' +
                '  "SameToDoId" : "",\n' +
                '  "SubToDo" : {\n' +
                '    "Name" : "Test",\n' +
                '    "Description__c" : "",\n' +
                '    "Completed__c" : false,\n' +
                '    "SameSubToDoId__c" : "a015g00000XflBKAAZ",\n' +
                '    "ToDo__c" : "' + toDo.Id + '"\n' +
                '  }\n' +
                '} ]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SubToDo__c/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        SubToDoController.createSubToDos();
        Test.stopTest();
        List<SubToDo__c> subToDos = [SELECT Id, Name, Description__c, Completed__c, ToDo__c, SameSubToDoId__c  FROM SubToDo__c];
        System.assertEquals(1, subToDos.size());
        System.assertEquals('Test', subToDos.get(0).Name);
        System.assertEquals(false, subToDos.get(0).Completed__c);
        System.assertEquals(null, subToDos.get(0).Description__c);
        System.assertEquals(toDo.Id, subToDos.get(0).ToDo__c);
        System.assertEquals('a015g00000XflBKAAZ', subToDos.get(0).SameSubToDoId__c);
    }


    @IsTest
    static void deleteSubToDosTest() {
        SubToDo__c subToDo = TestDataFactory.createDummySubToDo('Test', true);
        String jsonString = '{"ById" : [ "' + subToDo.Id + '" ]}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SubToDo__c/';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        SubToDoController.deleteSubToDos();
        Test.stopTest();
        List<SubToDo__c> subToDos = [SELECT Id FROM SubToDo__c WHERE Id = :subToDo.Id];
        System.assertEquals(true, subToDos.isEmpty());
    }


    @IsTest
    static void updateSubToDosTest() {
        SubToDo__c subToDo = TestDataFactory.createDummySubToDo('Test', true);
        String jsonString = '[ {\n' +
                '  "Id" : "' + subToDo.Id + '",\n' +
                '  "Name" : "New Test",\n' +
                '  "Completed__c" : true,\n' +
                '  "Description__c" : "description",\n' +
                '  "SameSubToDoId__c" : "' + subToDo.Id + '"\n' +
                '} ]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SubToDo__c/';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        SubToDoController.updateSubToDos();
        Test.stopTest();
        List<SubToDo__c> subToDos = [SELECT Id, Name, Completed__c, Description__c FROM SubToDo__c WHERE Id = :subToDo.Id];
        System.assertEquals('New Test', subToDos.get(0).Name);
        System.assertEquals(true, subToDos.get(0).Completed__c);
        System.assertEquals('description', subToDos.get(0).Description__c);
    }


    @IsTest
    static void updateSubToDos2Test() {
        SubToDo__c subToDo = TestDataFactory.createDummySubToDo('Test', true);
        subToDo.SameSubToDoId__c = subToDo.Id;
        update subToDo;
        String jsonString = '[ {\n' +
                '  "Id" : "' + subToDo.Id + '",\n' +
                '  "Name" : "New Test",\n' +
                '  "Completed__c" : true,\n' +
                '  "Description__c" : "description",\n' +
                '  "SameSubToDoId__c" : ""\n' +
                '} ]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/SubToDo__c/';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        SubToDoController.updateSubToDos();
        Test.stopTest();
        List<SubToDo__c> subToDos = [SELECT Id, Name, Completed__c, Description__c FROM SubToDo__c WHERE Id = :subToDo.Id];
        System.assertEquals('New Test', subToDos.get(0).Name);
        System.assertEquals(true, subToDos.get(0).Completed__c);
        System.assertEquals('description', subToDos.get(0).Description__c);
    }
}