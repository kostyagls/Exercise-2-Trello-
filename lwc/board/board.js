import {LightningElement, wire, track} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import { fireEvent } from 'c/pubsub'
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getListsByBoardId from '@salesforce/apex/BoardController.getListsByBoardId';
import saveNewList from '@salesforce/apex/BoardController.createNewList';
import changeBoardName from '@salesforce/apex/BoardController.changeBoardName';
import changeCardListId from '@salesforce/apex/BoardController.changeListIdOnCard';
import deleteBoard from '@salesforce/apex/BoardController.deleteBoard';
import getMembers from '@salesforce/apex/BoardController.getMembers';
import getUsers from '@salesforce/apex/BoardController.getUsers';
import addMember from '@salesforce/apex/BoardController.addMember';
import deleteMember from '@salesforce/apex/BoardController.deleteMember';



export default class Board extends LightningElement {

    @wire(CurrentPageReference) pageRef;
    @track board;
    @track lists;
    @track isModalOpen;
    @track listName;
    @track test;
    @track draggedCard;
    @track isDeleteBoardModalOpen;
    @track isMembersModalOpen;
    @track members;
    @track users;

    connectedCallback() {
        // subscribe to loadBoard event
        registerListener('loadboard', this.handleLoadBoardEvent, this);
    }

    disconnectedCallback() {
        // unsubscribe from bearListUpdate event
        unregisterAllListeners(this);
    }

    handleLoadBoardEvent(board) {
        this.board = board;
        getListsByBoardId({boardId: this.board.Id})
            .then(result => {
                this.lists = result;
            })
            .catch(error => {
                const title = 'ERROR. Can not get data';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });

    }

    handleClickOnNewList() {
        this.isModalOpen = true;
    }

    handleClickCloseModel() {
        this.isModalOpen = false;
    }

    handleInputName(event) {
        this.listName = event.target.value;
    }

    handleSave() {
        saveNewList({name: this.listName, boardId: this.board.Id})
            .then(result => {
                    const title = 'List is created';
                    const variant = 'success';
                    this.showNotification(title, variant);
                    this.handleLoadBoardEvent(this.board);
            })
            .catch(error => {
                const title = 'ERROR. List is not created';
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

    handleUpdateCards() {
        const lists = this.template.querySelectorAll('c-list');
        lists.forEach(list => list.loadCards());
    }

    handleNameChange(event) {
        let newName = event.target.value;
        setTimeout(() => {
            this.setNewBoardName(newName);
        }, 3000);
    }

    setNewBoardName(name) {
        changeBoardName({boardId: this.board.Id, newName: name})
            .then(result => {
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    handleUpdateLists() {
        this.handleLoadBoardEvent(this.board);
    }

    handleListItemDrag(evt) {
        this.draggedCard = evt.detail;
    }

    handleCardDrop(evt) {
        let list = evt.detail;
        changeCardListId({card: this.draggedCard, listId: list.Id})
            .then(result => {
                this.handleUpdateCards();
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    handleClickDeleteBoard() {
        this.isDeleteBoardModalOpen = true;
    }

    handleClickCloseDeleteBoardModel() {
        this.isDeleteBoardModalOpen = false;
    }

    handleClickDeleteBoardInModal() {
        deleteBoard({board: this.board})
            .then(result => {
                this.handleClickCloseDeleteBoardModel();
                this.deleteBoardEvent();
                this.board = false;
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    deleteBoardEvent() {
        fireEvent(this.pageRef, 'deleteboard', this.board);
    }

    handleClickMembers() {
        this.isMembersModalOpen = true;
        this.loadMembers();
    }

    handleClickCloseMembersModal() {
        this.isMembersModalOpen = false;
    }

    loadMembers() {
        getMembers({boardId: this.board.Id})
            .then(result => {
                this.members = [];
                if (result){
                    result.forEach(value =>  this.members.push(value.User__r));
                }
                this.loadUsers();
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    loadUsers() {
        getUsers()
            .then(result => {
                let membersId = [];
                this.members.forEach(member => membersId.push(member.Id));
                this.users = result.filter(resUser =>  !membersId.includes(resUser.Id));
            })
            .catch(error => {
                const title = 'ERROR. Can not get data';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    handleClickAddMember(event) {
        const eventUser = event.target.value;
        addMember({boardId: this.board.Id, userId: eventUser.Id})
            .then(result => {
                this.members.push(eventUser);
                this.users = this.users.filter(user => user.Id !== eventUser.Id );
            })
            .catch(error => {
                const title = 'ERROR. Member is not added';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });

    }

    handleClickDeleteMember(event) {
        const eventMember = event.target.value;
        deleteMember({board: this.board, memberId: eventMember.Id})
            .then(result => {
                this.users.push(eventMember);
                this.members = this.members.filter(member => member.Id !== eventMember.Id);
            })
            .catch(error => {
                const title = 'ERROR. Member is not deleted';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });


    }


}