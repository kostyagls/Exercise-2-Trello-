
public with sharing class ListController {

    private static ListService listService = new ListService();

    @AuraEnabled
    public static List<Card__c> getCardsByList(List__c cList) {
        try {
            return listService.getCardsByList(cList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createNewCard(String name, List__c cList) {
        try {
            listService.createNewCard(name, cList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeListName(List__c cList, String newName) {
        try {
            listService.changeListName(cList, newName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteList(List__c cList) {
        try {
            listService.deleteList(cList);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteCard(Card__c card) {
        try {
            listService.deleteCard(card);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<CardUser__c> getCardMembers(Card__c card) {
        try {
            return listService.getCardMembers(card);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<BoardUser__c> getBoardMembers(Board__c board) {
        try {
            return listService.getBoardMembers(board);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addCardMember(Card__c card, Id boardMemberId) {
        try {
            listService.addCardMember(card, boardMemberId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteCardMember(Card__c card, Id boardMemberId ) {
        try {
            listService.deleteCardMember(card, boardMemberId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}