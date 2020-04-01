import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from "lightning/platformShowToastEvent";
import deleteCard from '@salesforce/apex/ListController.deleteCard';
import getBoardMembers from '@salesforce/apex/BoardController.getMembers';
import getCardMembers from '@salesforce/apex/ListController.getCardMembers';
import addCardMember from '@salesforce/apex/ListController.addCardMember';
import deleteCardMember from '@salesforce/apex/ListController.deleteCardMember';
import createFile from '@salesforce/apex/ListController.createFile';
import getFiles from '@salesforce/apex/ListController.getFiles';
import deleteFile from '@salesforce/apex/ListController.deleteFile';



export default class Card extends LightningElement {
    @api card;
    @api board;
    @track isModalOpen;
    @track boardMembers;
    @track cardMembers;
    @track fileName;
    @track attachments;

    handleClickCard() {
        this.isModalOpen = true;
        this.loadCardMembers();
        this.loadAttachments();
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

    showNotification(title, variant, message) {
        const evt = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message
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
        getCardMembers({cardId: this.card.Id})
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
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    loadBoardMembers() {
        getBoardMembers({boardId: this.board.Id})
            .then(result => {
                this.boardMembers = [];
                if (result) {
                    result.forEach(resElement => this.boardMembers.push({
                        "Id": resElement.Id,
                        "UserId": resElement.User__c,
                        "UserName": resElement.User__r.Name,
                        "BoardUserId": resElement.Id
                    }));
                }
                let cardMemberUserIds = [];
                this.cardMembers.forEach(member =>  cardMemberUserIds.push(member.UserId));
                this.boardMembers =  this.boardMembers.filter(boardMember =>  !cardMemberUserIds.includes(boardMember.UserId));
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    handleClickAddMember(event) {
        const eventMember = event.target.value;
        addCardMember({cardId: this.card.Id, boardMemberId: eventMember.BoardUserId})
            .then(result => {
                this.cardMembers.push(eventMember);
                this.boardMembers = this.boardMembers.filter(member => member.Id !== eventMember.Id );
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
        deleteCardMember({cardId: this.card.Id, boardMemberId: eventMember.BoardUserId})
            .then(result => {
                this.boardMembers.push(eventMember);
                this.cardMembers = this.cardMembers.filter(member => member.Id !== eventMember.Id );
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    loadAttachments() {
        getFiles({cardId: this.card.Id})
            .then(result => {
                if (result){
                    this.attachments = result;
                } else {
                    this.attachments = [];
                }

            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            const filesUploaded = event.target.files;
            this.fileName = event.target.files[0].name;
            this.getFileContent(filesUploaded[0]);
        }
    }

    getFileContent(file) {
        const fileReader = new FileReader();
        // set onload function of FileReader object
        fileReader.onloadend = (() => {
            let fileContents = fileReader.result;
            const base64 = 'base64,';
            const content = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(content);
            this.saveFile(fileContents);

        });
        fileReader.readAsDataURL(file);
    }

    saveFile(fileContents) {
        createFile({fileName: this.fileName, fileContents: fileContents, card: this.card})
            .then(result => {
                let title = 'File "' + this.fileName + '" is upload!';
                const variant = 'success';
                this.showNotification(title, variant);
                this.attachments.push(...result);
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

    handleClickDeleteAttachment(event) {
        const eventAttachment = event.target.value;
        deleteFile({file: eventAttachment, cardName: this.card.Name})
            .then(result => {
                this.attachments = this.attachments.filter(attachment => attachment.Id !== eventAttachment.Id);
                const title = 'Attachment is deleted!';
                const variant = 'success';
                this.showNotification(title, variant);
            })
            .catch(error => {
                const title = 'ERROR';
                const message =  error.body.message;
                const variant = 'error';
                this.showNotification(title, variant, message);
            });
    }

}