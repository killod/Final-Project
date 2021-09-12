import { api, LightningElement } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import NAME_FIELD from '@salesforce/schema/ToDo__c.Name';
import CATEGORY_FIELD from '@salesforce/schema/ToDo__c.Category__c';
import COMPLETED_FIELD from '@salesforce/schema/ToDo__c.Completed__c';
import DESCRIPTION_FIELD from '@salesforce/schema/ToDo__c.Description__c';
import DUE_DATE_FIELD from '@salesforce/schema/ToDo__c.DueDate__c';
import PRIORITY_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import REMINDER_FIELD from '@salesforce/schema/ToDo__c.Reminder__c';

export default class TodoCard extends LightningElement {

    objectApiName = TODO_OBJECT;
    nameField = NAME_FIELD;
    categoryField = CATEGORY_FIELD;
    completedField = COMPLETED_FIELD;
    descriptionField = DESCRIPTION_FIELD;
    dueDateField = DUE_DATE_FIELD;
    priorityField = PRIORITY_FIELD;
    reminderField = REMINDER_FIELD;

    @api
    item;

    detailShown = false;
    editFormShown = false;

    handleCardClick(){
        this.detailShown = true;
    }

    handleCloseButton(){
        this.detailShown = false;
        this.editFormShown = false;
    }

    handleDeleteToDo(event) {
        deleteRecord(this.item.Id)
            .then(() => {
                this.detailShown = false;
                this.dispatchEvent(new CustomEvent('refresh'));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Record deleted',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            })
    }

    handleEditToDo(){
        this.detailShown = false;
        this.editFormShown = true;
    }
}