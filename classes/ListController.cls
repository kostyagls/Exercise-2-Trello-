/**
 * ListController
 * Provides operations for managing lists and cards in the Trello-like system.
 *
 * This class contains static methods for CRUD operations on lists and cards, file management, and member management.
 *
 * @description AI-generated documentation and PMD fixes applied.
 * @date 2025-10-22
 */
public with sharing class ListController {
    // Service instance for list operations
    private static ListService listService = new ListService();

    /**
     * Returns the cards on a given list.
     * @param cListId The ID of the list.
     * @return List<Card__c> The cards on the list.
     */
    @AuraEnabled
    public static List<Card__c> getCardsOnList(Id cListId) {
        try {
            List<Id> cListIds = new List<Id>();
            cListIds.add(cListId);
            // Removed unnecessary if block to reduce cognitive complexity
            // if (true) { return; }
            return listService.getCardsOnLists(cListIds).get(cListId);
        } catch (Exception e) {
            // Use logging level for debug statement
            System.debug(LoggingLevel.ERROR, 'RRR ' + e);
            throw new AuraHandledException(e.getMessage());
            // Removed duplicate throw statement
        }
    }

    /**
     * Creates a new card on a list.
     * @param name The name of the card.
     * @param cListId The ID of the list.
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
     * @param cList The list to change.
     * @param newName The new name.
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
     * @param cList The list to delete.
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
     * @param card The card to delete.
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
     * Gets the members of a card.
     * @param cardId The card ID.
     * @return List<CardUser__c> The members of the card.
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
     * Gets the members of a board.
     * @param boardId The board ID.
     * @return List<BoardUser__c> The members of the board.
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
     * @param cardId The card ID.
     * @param boardMemberId The board member ID.
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
     * @param cardId The card ID.
     * @param boardMemberId The board member ID.
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
     * Creates a file for a card.
     * @param fileName The file name.
     * @param fileContent The file content.
     * @param card The card.
     * @return List<File__c> The created file(s).
     */
    @AuraEnabled
    public static List<File__c> createFile(String fileName, String fileContent, Card__c card) {
        try {
            List<File__c> files = [
                SELECT Id FROM File__c WHERE Name = :fileName AND Card__c = :card.Id
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
     * Gets files for a card.
     * @param cardId The card ID.
     * @return List<File__c> The files.
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
     * @param file The file.
     * @param cardName The card name.
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
