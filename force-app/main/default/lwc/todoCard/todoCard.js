import { api, LightningElement } from 'lwc';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateSubToDo from '@salesforce/apex/ToDoListController.updateSubToDo';

import TODO_OBJECT from '@salesforce/schema/ToDo__c';
import NAME_FIELD from '@salesforce/schema/ToDo__c.Name';
import CATEGORY_FIELD from '@salesforce/schema/ToDo__c.Category__c';
import COMPLETED_FIELD from '@salesforce/schema/ToDo__c.Completed__c';
import DESCRIPTION_FIELD from '@salesforce/schema/ToDo__c.Description__c';
import DUE_DATE_FIELD from '@salesforce/schema/ToDo__c.DueDate__c';
import PRIORITY_FIELD from '@salesforce/schema/ToDo__c.Priority__c';
import REMINDER_FIELD from '@salesforce/schema/ToDo__c.Reminder__c';

import SUBTODO_OBJECT from '@salesforce/schema/SubToDo__c';
import SUB_NAME_FIELD from '@salesforce/schema/SubToDo__c.Name';
import SUB_DESCRIPTION_FIELD from '@salesforce/schema/SubToDo__c.Description__c';
import SUB_COMPLETED_FIELD from '@salesforce/schema/SubToDo__c.Completed__c';
import SUB_TODO_FIELD from '@salesforce/schema/SubToDo__c.ToDo__c';

export default class TodoCard extends LightningElement {

    objectApiName = TODO_OBJECT;
    nameField = NAME_FIELD;
    categoryField = CATEGORY_FIELD;
    completedField = COMPLETED_FIELD;
    descriptionField = DESCRIPTION_FIELD;
    dueDateField = DUE_DATE_FIELD;
    priorityField = PRIORITY_FIELD;
    reminderField = REMINDER_FIELD;

    subBbjectApiName = SUBTODO_OBJECT;
    subNameField = SUB_NAME_FIELD;
    subDescriptionField = SUB_DESCRIPTION_FIELD;
    subCompletedField = SUB_COMPLETED_FIELD;
    subToDoField = SUB_TODO_FIELD;

    @api
    item;

    detailShown = false;
    editFormShown = false;
    subToDoCreationFormShown = false;

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
                this.dispatchEvent(new CustomEvent('refresh',{
                    bubbles: true,
                    composed: true
                }));
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

    handleEditSave(){
        this.dispatchEvent(new CustomEvent('refresh',{
            bubbles: true,
            composed: true
        }));
        this.editFormShown = false;
    }

    handleCreateSubToDo(){
        this.subToDoCreationFormShown = true;
    }

    handleSuccessCreate(){
        this.dispatchEvent(new CustomEvent('refresh',{
            bubbles: true,
            composed: true
        }));
        this.subToDoCreationFormShown = false;
    }

    handleCloseForm(){
        this.subToDoCreationFormShown = false;
    }

    handleDeleteSubToDo(event){
        deleteRecord(event.target.value)
            .then(() => {
                this.dispatchEvent(new CustomEvent('refresh',{
                    bubbles: true,
                    composed: true
                }));
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

    handleUpdateSubToDo(event){
        let subToDo = { 'sobjectType': 'SubToDo__c' };
        subToDo.Id = event.target.value;
        subToDo.Completed__c = !event.target.checked;
        updateSubToDo({subtodo: subToDo})
            .then(() => {
                this.dispatchEvent(new CustomEvent('refresh',{
                    bubbles: true,
                    composed: true
                }));
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            })
    }
}