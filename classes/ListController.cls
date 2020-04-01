
public with sharing class ListController {

    private static ListService listService = new ListService();

    public class CustomException extends Exception {}

    @AuraEnabled
    public static List<Card__c> getCardsByListId(Id cListId) {
        try {
            List<Id> cListIds = new List<Id>();
            cListIds.add(cListId);
            return listService.getCardsByListId(cListIds).get(cListId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createNewCard(String name, Id cListId) {
        try {
            Map<Id, String> nameByListId = new Map<Id, String>();
            nameByListId.put(cListId, name);
            listService.createNewCard(nameByListId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeListName(List__c cList, String newName) {
        try {
            Map<List__c, String> nameByList = new Map<List__c, String>();
            nameByList.put(cList, newName);
            listService.changeListName(nameByList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteList(List__c cList) {
        try {
            List<List__c> lists = new List<List__c>();
            lists.add(cList);
            listService.deleteList(lists);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteCard(Card__c card) {
        try {
            List<Card__c> cards = new List<Card__c>();
            cards.add(card);
            listService.deleteCard(cards);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<CardUser__c> getCardMembers(Id cardId) {
        try {
            List<Id> cardIds = new List<Id>();
            cardIds.add(cardId);
            return listService.getCardsMembers(cardIds).get(cardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<BoardUser__c> getBoardMembers(Id boardId) {
        try {
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
            return listService.getBoardMembers(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addCardMember(Id cardId, Id boardMemberId) {
        try {
            Map<Id,Id> boardMemberIdByCardId = new Map<Id, Id>();
            boardMemberIdByCardId.put(cardId, boardMemberId);
            listService.addCardMember(boardMemberIdByCardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteCardMember(Id cardId, Id boardMemberId ) {
        try {
            Map<Id, Id> boardMemberIdByCardId = new Map<Id, Id>();
            boardMemberIdByCardId.put(cardId, boardMemberId);
            listService.deleteCardMember(boardMemberIdByCardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<File__c> createFile(String fileName, String fileContents, Card__c card) {
        try {
            List<File__c> files = [
                    SELECT Id
                    FROM File__c
                    WHERE Name = :fileName AND Card__c = :card.Id
            ];
            if (files.size() == 0) {
                listService.uploadFileToDropBox(fileName, fileContents, card.Name);

                Map <String, Id> cardIdByFileName = new Map<String, Id>();
                cardIdByFileName.put(fileName, card.Id);
                return listService.createFile(cardIdByFileName);
            } else {
                String errorMessage = 'File with this name have already added to the card!';
                throw new CustomException(errorMessage);
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<File__c> getFiles(Id cardId) {
        try {
            List<Id> cardIds = new List<Id>{cardId};
            return listService.getFiles(cardIds).get(cardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteFile(File__c file, String cardName) {
        try {
            listService.deleteFileFromDropBox(file.Name, cardName);
            List<File__c> files = new List<File__c>{file};
            listService.deleteFiles(files);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}