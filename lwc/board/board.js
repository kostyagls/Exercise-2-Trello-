import {LightningElement, wire, track} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import {registerListener, unregisterAllListeners} from 'c/pubsub';
import { fireEvent } from 'c/pubsub'
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import getListsByBoardId from '@salesforce/apex/BoardController.getListsByBoard';
import saveNewList from '@salesforce/apex/BoardController.createNewList';
import changeBoardName from '@salesforce/apex/BoardController.changeBoardName';
import changeCardListId from '@salesforce/apex/BoardController.changeCardListId';
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
        getListsByBoardId({board: this.board})
            .then(result => {
                this.lists = result;
            })
            .catch(error => {
                const title = 'ERROR. Can not get data';
                const variant = 'error';
                this.showNotification(title, variant);
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
        saveNewList({name: this.listName, board: this.board})
            .then(result => {
                    const title = 'List is created';
                    const variant = 'success';
                    this.showNotification(title, variant);
                    this.handleLoadBoardEvent(this.board);
            })
            .catch(error => {
                const title = 'ERROR. List is not created';
                const variant = 'error';
                this.showNotification(title, variant);

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
        changeBoardName({board: this.board, newName: name});
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
                const title = 'ERROR. ' + error.body.message;
                const variant = 'error';
                this.showNotification(title, variant);
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
                const title = 'ERROR. ';
                const variant = 'error';
                this.showNotification(title, variant);
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
        getMembers({board: this.board})
            .then(result => {
                this.members = [];
                result.forEach(value =>  this.members.push(value.User__r));
                this.loadUsers();
            })
            .catch(error => {
                const title = 'ERROR. Can not get data';
                const variant = 'error';
                this.showNotification(title, variant);
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
                const variant = 'error';
                this.showNotification(title, variant);
            });
    }

    handleClickAddMember(event) {
        const eventUser = event.target.value;
        addMember({board: this.board, userId: eventUser.Id})
            .then(result => {
                this.members.push(eventUser);
                this.users = this.users.filter(user => user.Id !== eventUser.Id );
            })
            .catch(error => {
                const title = 'ERROR. Member is not added';
                const variant = 'error';
                this.showNotification(title, variant);
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
                const variant = 'error';
                this.showNotification(title, variant);
            });


    }


}