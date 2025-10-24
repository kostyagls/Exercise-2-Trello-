/**
 * ListController
 *
 * This class provides methods to manage Trello-like lists and cards in Salesforce.
 * It includes logic for retrieving, creating, updating, and deleting lists and cards.
 *
 * Logic comments and PMD compliance improvements by AI.
 */
public with sharing class ListController {

    // Service layer for list operations
    private static ListService listService = new ListService();

    // Custom exception for controller errors
    public class CustomException extends Exception {}

    /**
     * Retrieves cards on a specific list by list Id.
     * @param cListId The Id of the list.
     * @return List of Card__c records on the list.
     */
    @AuraEnabled
    public static List<Card__c> getCardsOnList(Id cListId) {
        try {
            List<Id> cListIds = new List<Id>();
            cListIds.add(cListId);
            // PMD: Removed unreachable code and always-true condition
            return listService.getCardsOnLists(cListIds).get(cListId);
        } catch (Exception e) {
            // PMD: Use logging level for debug
            System.debug(LoggingLevel.ERROR, 'RRR ' + e);
            // PMD: Only throw once
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Creates a new card on a list.
     * @param name The name of the card.
     * @param cListId The Id of the list.
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
     * @param cList The list record.
     * @param newName The new name for the list.
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
     * @param cList The list record to delete.
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
     * @param card The card record to delete.
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
     * Retrieves card members by card Id.
     * @param cardId The Id of the card.
     * @return List of CardUser__c records.
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
     * Retrieves board members by board Id.
     * @param boardId The Id of the board.
     * @return List of BoardUser__c records.
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
     * @param cardId The Id of the card.
     * @param boardMemberId The Id of the board member.
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
     * @param cardId The Id of the card.
     * @param boardMemberId The Id of the board member.
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
     * Creates a file and attaches it to a card.
     * @param fileName The name of the file.
     * @param fileContents The file contents.
     * @param card The card record.
     * @return List of File__c records.
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
     * Retrieves files attached to a card.
     * @param cardId The Id of the card.
     * @return List of File__c records.
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
     * @param file The file record.
     * @param cardName The name of the card.
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
