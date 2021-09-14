global with sharing class CleanOldToDos  implements Schedulable {

    global void execute(SchedulableContext ctx) {
        ToDosBatch batchToDos = new ToDosBatch();
        Id batchId = Database.executeBatch(batchToDos);
    }
}