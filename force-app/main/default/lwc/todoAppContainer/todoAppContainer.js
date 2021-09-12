import { api, LightningElement, track, wire } from 'lwc';
import findTodos from '@salesforce/apex/ToDoListController.findTodos';

export default class TodoAppContainer extends LightningElement {
    
    searchKey;
    todays;
    tomorrows;
    laters;
    error;
    
    @wire(findTodos, { searchKey: '$searchKey'})
    wiredTodos({ error, data }){
        if (data) {
            console.log(data);
            this.todays = [...data].filter((item, i) => data[i].Category__c == "Today");
            this.tomorrows = [...data].filter((item, i) => data[i].Category__c == "Tomorrow");
            this.laters = [...data].filter((item, i) => data[i].Category__c == "Later");
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.record = undefined;
        }
    }

    handleSearch(event){
        this.searchKey = event.detail;
    }

}