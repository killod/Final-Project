import { api, LightningElement, track, wire } from 'lwc';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import NAME_FIELD from '@salesforce/schema/ToDo__c.Name';
import CATEGORY_FIELD from '@salesforce/schema/ToDo__c.Category__c';
import COMPLETED_FIELD from '@salesforce/schema/ToDo__c.Completed__c';
import DESCRIPTION_FIELD from '@salesforce/schema/ToDo__c.Description__c';
import DUE_DATE_FIELD from '@salesforce/schema/ToDo__c.DueDate__c';
import PRIORITY_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import REMINDER_FIELD from '@salesforce/schema/ToDo__c.Reminder__c';

export default class TodoList extends LightningElement {

    objectApiName = TODO_OBJECT;
    nameField = NAME_FIELD;
    categoryField = CATEGORY_FIELD;
    completedField = COMPLETED_FIELD;
    descriptionField = DESCRIPTION_FIELD;
    dueDateField = DUE_DATE_FIELD;
    priorityField = PRIORITY_FIELD;
    reminderField = REMINDER_FIELD;

    @api
    items;

    formShown = false;

    @api
    category;

    handleCreateToDo(){
        this.formShown = true;
    }

    handleCloseForm(){
        this.formShown = false;

    }

    handleSuccessCreate(){
        this.dispatchEvent(new CustomEvent('refresh'));
        this.formShown = false;
    }
}