import { LightningElement } from 'lwc';

export default class SearchBar extends LightningElement {
    connectedCallback(){
        this.dispatchEvent(new CustomEvent('search', {
            detail: ''
        }));
    }
    
    handleSearchChange(event) {
        this.dispatchEvent(new CustomEvent('search', {
            detail: event.target.value
        }));
    }
}