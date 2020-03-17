import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import deleteCard from '@salesforce/apex/ListController.deleteCard';
import getBoardMembers from '@salesforce/apex/BoardController.getMembers';
import getCardMembers from '@salesforce/apex/ListController.getCardMembers';
import addCardMember from '@salesforce/apex/ListController.addCardMember';
import deleteCardMember from '@salesforce/apex/ListController.deleteCardMember';

export default class Card extends LightningElement {
    @api card;
    @api board;
    @track isModalOpen;
    @track boardMembers;
    @track cardMembers;

    handleClickCard() {
        this.isModalOpen = true;
        this.loadCardMembers();
    }

    handleClickCloseModel() {
        this.isModalOpen = false;
    }

    successUpdateRecord() {
        const title = 'Card is updated!';
        const variant = 'success';
        this.showNotification(title, variant);
        this.createCardChangedEvent();
    }

    createCardChangedEvent() {
        const updateCardEvent = new CustomEvent('cardchanged', {
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(updateCardEvent);
    }

    showNotification(title, variant) {
        const evt = new ShowToastEvent({
            title: title,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

    handleDeleteCard() {
        deleteCard({card: this.card})
            .then(result => {
                const title = 'Card is deleted!';
                const variant = 'success';
                this.showNotification(title, variant);
                this.createCardDeleteEvent();
            })
            .catch(error => {
                const title = 'Card is not deleted!';
                const variant = 'error';
                this.showNotification(title, variant);
            });
    }

    createCardDeleteEvent() {
        const deleteCardEvent = new CustomEvent('deletecard');
        this.dispatchEvent(deleteCardEvent);
    }

    cardDragStart() {
        const event = new CustomEvent('carddrag', {
            detail: this.card,
            bubbles: true,
            composed: true
        });
        this.dispatchEvent(event);
    }

    loadCardMembers() {
        getCardMembers({card: this.card})
            .then(result => {
                this.cardMembers = [];
                result.forEach(resElement => this.cardMembers.push({
                    "Id": resElement.Id,
                    "UserId": resElement.BoardUser__r.User__c,
                    "UserName": resElement.BoardUser__r.User__r.Name,
                    "BoardUserId": resElement.BoardUser__c
                }));
                this.loadBoardMembers();
            })
            .catch(error => {
            });
    }

    loadBoardMembers() {
        getBoardMembers({board: this.board})
            .then(result => {
                this.boardMembers = [];
                result.forEach(resElement => this.boardMembers.push({
                    "Id": resElement.Id,
                    "UserId": resElement.User__c,
                    "UserName": resElement.User__r.Name,
                    "BoardUserId": resElement.Id
                }));
                let cardMemberUserIds = [];
                this.cardMembers.forEach(member =>  cardMemberUserIds.push(member.UserId));
                this.boardMembers =  this.boardMembers.filter(boardMember =>  !cardMemberUserIds.includes(boardMember.UserId));
            })
            .catch(error => {
            });
    }

    handleClickAddMember(event) {
        const eventMember = event.target.value;
        addCardMember({card: this.card, boardMemberId: eventMember.BoardUserId})
            .then(result => {
                this.cardMembers.push(eventMember);
                this.boardMembers = this.boardMembers.filter(member => member.Id !== eventMember.Id );
            })
            .catch(error => {
                const title = 'ERROR. Member is not added';
                const variant = 'error';
                this.showNotification(title, variant);
            });
    }

    handleClickDeleteMember(event) {
        const eventMember = event.target.value;
        deleteCardMember({card: this.card, boardMemberId: eventMember.BoardUserId})
            .then(result => {
                this.boardMembers.push(eventMember);
                this.cardMembers = this.cardMembers.filter(member => member.Id !== eventMember.Id );
            })
            .catch(error => {
                const title = 'ERROR. Member is not deleted';
                const variant = 'error';
                this.showNotification(title, variant);
            });
    }


}