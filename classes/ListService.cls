
public with sharing class ListService {


    public List<Card__c> getCardsByList(List__c cList) {
        List<Card__c> cards = [
                SELECT Id, Name, Description__c, Due_Date__c
                FROM Card__c
                WHERE List__c = :cList.Id
                ORDER BY CreatedDate
        ];
        return cards;
    }


    public void createNewCard(String name, List__c cList) {
        Card__c card = new Card__c(Name = name, List__c = cList.Id);
        insert card;
    }


    public void changeListName(List__c cList, String newName) {
        cList.Name = newName;
        update cList;
    }

    public void deleteList(List__c cList) {
       delete cList;
    }

    public void deleteCard(Card__c card) {
       delete card;
    }

    public List<CardUser__c> getCardMembers(Card__c card) {
        List<CardUser__c> cardUsers = [
                SELECT Id, Card__c, BoardUser__r.User__r.Name
                FROM CardUser__c
                WHERE Card__c = :card.Id
        ];
        return cardUsers;
    }

    public List<BoardUser__c> getBoardMembers(Board__c board) {
        List<BoardUser__c> boardUsers = [
                SELECT Id, Board__c, User__r.Name
                FROM BoardUser__c
                WHERE Board__c = :board.Id
        ];
        return boardUsers;
    }

    public void addCardMember(Card__c card, Id boardMemberId) {
        CardUser__c cardUser = new CardUser__c(Card__c = card.Id, BoardUser__c = boardMemberId);
        insert cardUser;
    }

    public void deleteCardMember(Card__c card, Id boardMemberId ) {
        List<CardUser__c> cardUsers = [
                SELECT Id
                FROM CardUser__c
                WHERE Card__c = :card.Id AND BoardUser__c = :boardMemberId
        ];
        delete cardUsers;
    }

}