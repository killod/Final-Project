@IsTest
private class ToDoControllerTest {
    @IsTest
    static void createToDosTest() {
        String jsonString = '[{\n' +
                '  "Name" : "Test",\n' +
                '  "Category__c" : "Today",\n' +
                '  "Completed__c" : false,\n' +
                '  "Description__c" : "description",\n' +
                '  "Priority__c" : "None",\n' +
                '  "Reminder__c" : "Don’t remind me",\n' +
                '  "SameToDoId__c" : "a005g000030kT2VAAU"\n' +
                '}]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ToDo__c/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        ToDoController.createToDos();
        Test.stopTest();
        List<ToDo__c> toDos = [SELECT Id, Name, Category__c, Completed__c, Description__c, Priority__c, Reminder__c, SameToDoId__c FROM ToDo__c];
        System.assertEquals(1, toDos.size());
        System.assertEquals('Test', toDos.get(0).Name);
        System.assertEquals('Today', toDos.get(0).Category__c);
        System.assertEquals(false, toDos.get(0).Completed__c);
        System.assertEquals('description', toDos.get(0).Description__c);
        System.assertEquals('None', toDos.get(0).Priority__c);
        System.assertEquals('Don’t remind me', toDos.get(0).Reminder__c);
        System.assertEquals('a005g000030kT2VAAU', toDos.get(0).SameToDoId__c);
    }


    @IsTest
    static void deleteToDosTest() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', true);
        String jsonString = '{"ById" : [ "' + toDo.Id + '" ]}';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ToDo__c/';
        req.httpMethod = 'DELETE';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        ToDoController.deleteToDos();
        Test.stopTest();
        List<ToDo__c> toDos = [SELECT Id FROM ToDo__c WHERE Id = :toDo.Id];
        System.assertEquals(true, toDos.isEmpty());
    }


    @IsTest
    static void updateToDosOwnerQueueTest() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Today', true);
        String jsonString = '[ {\n' +
                '  "OwnerToDo" : "queue",\n' +
                '  "ToDo" : {\n' +
                '    "Id" : "' + toDo.Id + '",\n' +
                '    "Name" : "name",\n' +
                '    "Category__c" : "Later",\n' +
                '    "Completed__c" : false,\n' +
                '    "Description__c" : "",\n' +
                '    "Priority__c" : "High",\n' +
                '    "Reminder__c" : "Don’t remind me",\n' +
                '    "SameToDoId__c" : "' + toDo.Id + '"\n' +
                '  }\n' +
                '} ]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ToDo__c/';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        ToDoController.updateToDos();
        Test.stopTest();
        List<ToDo__c> toDos = [SELECT Id, Category__c, Priority__c FROM ToDo__c WHERE Id = :toDo.Id];
        System.assertEquals('Later', toDos.get(0).Category__c);
        System.assertEquals('High', toDos.get(0).Priority__c);
    }


    @IsTest
    static void updateToDosOwnerUserQueueTest() {
        ToDo__c toDo = TestDataFactory.createDummyToDo('Test', 'Tomorrow', false);
        User userId = [SELECT Id FROM User WHERE IsActive = TRUE LIMIT 1];
        Group laterQueue = [SELECT Id, Name FROM Group WHERE Type = 'Queue' AND Name = 'Later Queue' LIMIT 1];
        toDo.OwnerId = userId.Id;
        insert toDo;
        toDo.SameToDoId__c = toDo.Id;
        update toDo;
        System.assertNotEquals(laterQueue.Id, toDo.OwnerId);
        String jsonString = '[ {\n' +
                '  "OwnerToDo" : "queue",\n' +
                '  "ToDo" : {\n' +
                '    "Id" : "' + toDo.Id + '",\n' +
                '    "Name" : "name",\n' +
                '    "Category__c" : "Later",\n' +
                '    "Completed__c" : false,\n' +
                '    "Description__c" : "",\n' +
                '    "Priority__c" : "High",\n' +
                '    "Reminder__c" : "Don’t remind me",\n' +
                '    "SameToDoId__c" : ""\n' +
                '  }\n' +
                '} ]';
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ToDo__c/';
        req.httpMethod = 'PATCH';
        RestContext.request = req;
        RestContext.response = res;
        req.requestBody = Blob.valueOf(jsonString);
        ToDoController.updateToDos();
        Test.stopTest();
        List<ToDo__c> toDos = [SELECT Id, Category__c, OwnerId FROM ToDo__c WHERE Id = :toDo.Id];
        System.assertEquals(1, toDos.size());
        System.assertEquals(laterQueue.Id, toDos.get(0).OwnerId);
    }
}