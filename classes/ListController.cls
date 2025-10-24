/**
 * ListController
 * Controller for managing List and Card operations.
 * @description Handles CRUD operations for lists and cards.
 */
public with sharing class ListController {
    // Service instance for list operations
    private static ListService listService = new ListService();

    public class CustomException extends Exception {}

    /**
     * Gets cards on a specific list.
     * @param cListId Id of the list
     * @return List of Card__c records
     */
    @AuraEnabled
    public static List<Card__c> getCardsOnList(Id cListId) {
        try {
            // Prepare list of Ids for service call
            List<Id> cListIds = new List<Id>();
            cListIds.add(cListId);
            // Directly return the result from service
            return listService.getCardsOnLists(cListIds).get(cListId);
        } catch (Exception e) {
            // Log error with appropriate logging level
            System.debug(LoggingLevel.ERROR, 'RRR ' + e);
            // Throw handled exception for Aura
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Creates a new card on a list.
     * @param name Name of the card
     * @param cListId Id of the list
     */
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

    /**
     * Changes the name of a list.
     * @param cList List__c record
     * @param newName New name for the list
     */
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

    /**
     * Deletes a list.
     * @param cList List__c record
     */
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

    /**
     * Deletes a card.
     * @param card Card__c record
     */
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

    /**
     * Gets members of a card.
     * @param cardId Id of the card
     * @return List of CardUser__c records
     */
    @AuraEnabled
    public static List<CardUser__c> getCardMembers(Id cardId) {
        try {
            List<Id> cardIds = new List<Id>();
            cardIds.add(cardId);
            return listService.getCardMembers(cardIds).get(cardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Gets members of a board.
     * @param boardId Id of the board
     * @return List of BoardUser__c records
     */
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

    /**
     * Adds a card member.
     * @param cardId Id of the card
     * @param boardMemberId Id of the board member
     */
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

    /**
     * Deletes a card member.
     * @param cardId Id of the card
     * @param boardMemberId Id of the board member
     */
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

    /**
     * Creates a file and attaches to a card.
     * @param fileName Name of the file
     * @param fileContent Content of the file
     * @param card Card__c record
     * @return List of File__c records
     */
    @AuraEnabled
    public static List<File__c> createFile(String fileName, String fileContent, Card__c card) {
        try {
            List<File__c> files = [
                SELECT Id
                FROM File__c
                WHERE Name = :fileName AND Card__c = :card.Id
            ];
            if (files.size() == 0) {
                listService.uploadFileToDropBox(fileName, fileContent, card.Name);
                Map<String, Id> cardIdByFileName = new Map<String, Id>();
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

    /**
     * Gets files attached to a card.
     * @param cardId Id of the card
     * @return List of File__c records
     */
    @AuraEnabled
    public static List<File__c> getFiles(Id cardId) {
        try {
            List<Id> cardIds = new List<Id>{cardId};
            return listService.getFiles(cardIds).get(cardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Deletes a file from a card.
     * @param file File__c record
     * @param cardName Name of the card
     */
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
