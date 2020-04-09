import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getCardsByListId from '@salesforce/apex/ListController.getCardsOnList';
import saveNewCard from '@salesforce/apex/ListController.createNewCard';
import changeListName from '@salesforce/apex/ListController.changeListName';
import deleteList from '@salesforce/apex/ListController.deleteList';


export default class List extends LightningElement {
    @api list;
    @api board;
    @track cards = [];
    @track isModalOpen;
    @track isDeleteListModalOpen;
    @track cardName;

    connectedCallback() {
        if (this.list.Cards__r){
            this.list.Cards__r.forEach(card => this.cards.push(card));
        }
    }

    @api
    loadCards() {
        getCardsByListId({cListId: this.list.Id})
            .then(result => {
                this.cards = result;
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    handleClickOnNewCard() {
        this.isModalOpen = true;
    }

    handleClickCloseModel() {
        this.isModalOpen = false;
    }

    handleInputName(event) {
        this.cardName = event.target.value;
    }

    handleClickSave() {
        saveNewCard({name: this.cardName, cListId: this.list.Id})
            .then(result => {
                    const title = 'Card created';
                    const variant = 'success';
                    this.showNotification(title, variant);
                    this.loadCards();
            })
            .catch(error => {
                const title = 'ERROR. Card is not created';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
        this.handleClickCloseModel();
    }

    showNotification(title, variant, message) {
        const evt = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message
        });
        this.dispatchEvent(evt);
    }

    handleNameChange(event) {
        let newName = event.target.value;
        setTimeout(() => {
            this.setNewListName(newName);
        }, 3000);
    }

    setNewListName(name) {
        changeListName({cList: this.list, newName: name});
    }

    handleDeleteCardEvent() {
        this.loadCards();
    }

    handleClickDeleteList() {
        this.isDeleteListModalOpen = true;
    }

    handleClickCloseDeleteListModel() {
        this.isDeleteListModalOpen = false;
    }

    handleClickDeleteListInModal() {
        deleteList({cList: this.list})
            .then(result => {
                    const title = 'List is deleted!';
                    const variant = 'success';
                    this.showNotification(title, variant);
                    this.updateListsEvent();
            })
            .catch(error => {
                const title = 'List is not deleted!';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
        this.handleClickCloseDeleteListModel();
    }

    updateListsEvent() {
        const updateListsEvent = new CustomEvent('listdeleted');
        this.dispatchEvent(updateListsEvent);
    }

    handleDragOver(evt) {
        evt.preventDefault();
    }

    handleDrop(evt) {
        const event = new CustomEvent('carddrop', {
            detail: this.list
        });
        this.dispatchEvent(event);
    }

}