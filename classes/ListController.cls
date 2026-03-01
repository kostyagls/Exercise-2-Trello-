/**
 * ListController
 *
 * Controller for managing List and Card operations in Trello-like app.
 *
 * Provides methods to get, create, update, and delete lists and cards, as well as manage members and files.
 *
 * Logic is delegated to ListService. Handles exceptions and provides Aura-enabled endpoints for LWC/Aura.
 *
 * @description  AI-generated documentation and PMD compliance fixes.
 * @date         2024-06-XX
 */
public with sharing class ListController {

    // Service layer for List operations
    private static ListService listService = new ListService();

    /**
     * Custom exception for ListController
     */
    public class CustomException extends Exception {}

    /**
     * Get all cards on a specific list
     * @param cListId List Id
     * @return List of Card__c
     */
    @AuraEnabled
    public static List<Card__c> getCardsOnList(Id cListId) {
        try {
            List<Id> cListIds = new List<Id>();
            cListIds.add(cListId);
            // Removed always-true if (true) { return; } as per PMD
            return listService.getCardsOnLists(cListIds).get(cListId);
        } catch (Exception e) {
            // Use logging level for debug as per PMD
            System.debug(LoggingLevel.ERROR, 'RRR ' + e);
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Create a new card on a list
     * @param name Card name
     * @param cListId List Id
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
     * Change the name of a list
     * @param cList List__c record
     * @param newName New name
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
     * Delete a list
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
     * Delete a card
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
     * Get card members
     * @param cardId Card Id
     * @return List of CardUser__c
     */
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

    /**
     * Get board members
     * @param boardId Board Id
     * @return List of BoardUser__c
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
     * Add a card member
     * @param cardId Card Id
     * @param boardMemberId BoardUser__c Id
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
     * Delete a card member
     * @param cardId Card Id
     * @param boardMemberId BoardUser__c Id
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
     * Create a file for a card
     * @param fileName File name
     * @param fileContents File contents
     * @param card Card__c record
     */
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

    /**
     * Get files for a card
     * @param cardId Card Id
     * @return List of File__c
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
     * Delete a file from a card
     * @param file File__c record
     * @param cardName Card name
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
