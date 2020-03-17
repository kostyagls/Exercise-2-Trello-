import {LightningElement, track, wire, api} from 'lwc';
import { fireEvent } from 'c/pubsub';
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllBoards from '@salesforce/apex/BoardController.getAllBoards';
import saveNewBoard from '@salesforce/apex/BoardController.createNewBoard';




export default class BoardsList extends LightningElement {

    @track name;
    @track boards;
    @track isModalOpen;
    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
        this.loadBoards();
        registerListener('deleteboard', this.handleDeleteBoardEvent, this);
        }

    disconnectedCallback() {
        // unsubscribe from bearListUpdate event
        unregisterAllListeners(this);
    }

    loadBoards() {
        getAllBoards()
            .then(result => {
                this.boards = result;
            })
            .catch(error => {
                const title = 'ERROR. Board is not created';
                const variant = 'error';
                this.showNotification(title, variant)
            });
    }

    handleClickOnBoard(event) {
        let board = event.target.value;
        fireEvent(this.pageRef, 'loadboard', board);
    }

    handleClickOnNewBoard() {
        this.isModalOpen = true;
    }

    handleClickCloseModel() {
        this.isModalOpen = false;
    }

    handleInputName(event) {
        this.name = event.target.value;
    }

    handleSave() {
        saveNewBoard({name: this.name})
            .then(result => {
                   const title = 'Board is created';
                   const variant = 'success';
                   this.showNotification(title, variant)
                   this.loadBoards();
            })
            .catch(error => {
                const title = 'Board is not created';
                const variant = 'error';
                this.showNotification(title, variant)
            });

        this.handleClickCloseModel();

    }

    showNotification(title, variant) {
        const evt = new ShowToastEvent({
            title: title,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    handleDeleteBoardEvent(deleteBoard) {
        this.boards = this.boards.filter(board => board.Id !== deleteBoard.Id );
    }
}

