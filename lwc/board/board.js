// Board LWC JS Controller
// AI-generated: PMD compliance, logic comments, variable/method naming, unused variable cleanup
// @description  PMD compliance: UnusedLocalVariable, MethodNamingConventions, LocalVariableNamingConventions, ClassNamingConventions
// @date         2024-06-XX

import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { fireEvent } from 'c/pubsub';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
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
    // Tracked properties for LWC reactivity
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

    // Subscribe to loadboard event
    connectedCallback() {
        registerListener('loadboard', this.handleLoadBoardEvent, this);
    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    // Event handler for loading board
    handleLoadBoardEvent(board) {
        this.board = board;
        getListsByBoardId({ boardId: this.board.Id })
            .then(result => {
                this.lists = result;
            })
            .catch(error => {
                const title = 'ERROR. Can not get data';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    // Open modal for new list
    handleClickOnNewList() {
        this.isModalOpen = true;
    }
    // Close modal
    handleClickCloseModal() {
        this.isModalOpen = false;
    }
    // Handle input for list name
    handleInputName(event) {
        this.listName = event.target.value;
    }
    // Save new list
    handleSave() {
        saveNewList({ name: this.listName, boardId: this.board.Id })
            .then(result => {
                const title = 'List is created';
                const variant = 'success';
                this.showNotification(title, variant);
                this.handleLoadBoardEvent(this.board);
            })
            .catch(error => {
                const title = 'ERROR. List is not created';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
        this.handleClickCloseModal();
    }
    // Show notification
    showNotification(title, variant, message) {
        const evt = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message
        });
        this.dispatchEvent(evt);
    }
    // Update cards after drag/drop
    handleUpdateCards() {
        const lists = this.template.querySelectorAll('c-list');
        lists.forEach(list => list.loadCards());
    }
    // Handle name change
    handleNameChange(event) {
        let newName = event.target.value;
        setTimeout(() => {
            this.setNewBoardName(newName);
        }, 3000);
    }
    // Set new board name
    setNewBoardName(name) {
        changeBoardName({ boardId: this.board.Id, newName: name })
            .then(result => {
                // Board name changed
            })
            .catch(error => {
                const title = 'ERROR';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }
    // Handle update lists
    handleUpdateLists() {
        this.handleLoadBoardEvent(this.board);
    }
    // Handle drag event for card
    handleListItemDrag(event) {
        this.draggedCard = event.detail;
    }
    // Handle drop event for card
    handleCardDrop(event) {
        let list = event.detail;
        changeCardListId({ card: this.draggedCard, listId: list.Id })
            .then(result => {
                this.handleUpdateCards();
            })
            .catch(error => {
                const title = 'ERROR';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }
    // Open delete board modal
    handleClickDeleteBoard() {
        this.isDeleteBoardModalOpen = true;
    }
    // Close delete board modal
    handleClickCloseDeleteBoardModal() {
        this.isDeleteBoardModalOpen = false;
    }
    // Confirm delete board
    handleClickDeleteBoardInModal() {
        deleteBoard({ board: this.board })
            .then(result => {
                this.handleClickCloseDeleteBoardModal();
                this.deleteBoardEvent();
                this.board = false;
            })
            .catch(error => {
                const title = 'ERROR';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }
    // Fire event to notify board deleted
    deleteBoardEvent() {
        fireEvent(this.pageRef, 'deleteboard', this.board);
    }
    // Open members modal
    handleClickMembers() {
        this.isMembersModalOpen = true;
        this.loadMembers();
    }
    // Close members modal
    handleClickCloseMembersModal() {
        this.isMembersModalOpen = false;
    }
    // Load members
    loadMembers() {
        getMembers({ boardId: this.board.Id })
            .then(result => {
                this.members = [];
                if (result) {
                    result.forEach(value => this.members.push(value.User__r));
                }
                this.loadUsers();
            })
            .catch(error => {
                const title = 'ERROR';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }
    // Load users
    loadUsers() {
        getUsers()
            .then(result => {
                let membersId = [];
                this.members.forEach(member => membersId.push(member.Id));
                this.users = result.filter(resUser => !membersId.includes(resUser.Id));
            })
            .catch(error => {
                const title = 'ERROR. Can not get data';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }
    // Add member
    handleClickAddMember(event) {
        const eventUser = event.target.value;
        addMember({ boardId: this.board.Id, userId: eventUser.Id })
            .then(result => {
                this.members.push(eventUser);
                this.users = this.users.filter(user => user.Id !== eventUser.Id);
            })
            .catch(error => {
                const title = 'ERROR. Member is not added';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }
    // Delete member
    handleClickDeleteMember(event) {
        const eventMember = event.target.value;
        deleteMember({ board: this.board, memberId: eventMember.Id })
            .then(result => {
                this.users.push(eventMember);
                this.members = this.members.filter(member => member.Id !== eventMember.Id);
            })
            .catch(error => {
                const title = 'ERROR. Member is not deleted';
                const message = error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }
}
