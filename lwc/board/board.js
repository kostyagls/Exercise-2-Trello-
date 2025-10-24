import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { fireEvent } from 'c/pubsub'
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

    // Register event listener only once in connectedCallback
    connectedCallback() {
        // subscribe to loadBoard event
        registerListener('loadboard', this.handleLoadBoardEvent, this);
    }
    disconnectedCallback() {
        // unsubscribe from bearListUpdate event
        unregisterAllListeners(this);
    }

    // ... rest of the logic remains unchanged ...
}
