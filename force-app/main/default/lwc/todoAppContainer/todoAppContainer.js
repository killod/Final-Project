import { api, LightningElement, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import findTodos from '@salesforce/apex/ToDoListController.findTodos';

export default class TodoAppContainer extends LightningElement {
    
    searchKey;
    @track
    wiredToDos = [];
    todays;
    tomorrows;
    laters;
    error;
    
    @wire(findTodos, { searchKey: '$searchKey'})
    wiredTodos(result){
        if (result.data) {
            this.wiredToDos = result;
            this.todays = [...result.data].filter((item, i) => result.data[i].Category__c == "Today");
            this.tomorrows = [...result.data].filter((item, i) => result.data[i].Category__c == "Tomorrow");
            this.laters = [...result.data].filter((item, i) => result.data[i].Category__c == "Later");
            this.error = undefined;
        } else if (result.error) {
            this.error = error;
            this.wiredToDos = undefined;
        }
    }

    handleSearch(event){
        this.searchKey = event.detail;
    }

    handleRefresh(){
        refreshApex(this.wiredToDos);
    }

}