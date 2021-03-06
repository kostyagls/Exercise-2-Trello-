
public with sharing class ListService {

    public class CustomException extends Exception {}

    public Map<Id, List<Card__c>> getCardsOnLists(List<Id> cListIds) {
        Map<Id, List<Card__c>> cardsByListId = new Map<Id, List<Card__c>>();
        List<Card__c> cards = [
                SELECT Id, Name, Description__c, Due_Date__c, List__c
                FROM Card__c
                WHERE List__c = :cListIds
                ORDER BY CreatedDate
        ];

        for (Card__c card : cards){
            if (cardsByListId.keySet().contains(card.List__c)) {
                cardsByListId.get(card.List__c).add(card);
            } else {
                cardsByListId.put(card.List__c, new List<Card__c>{card});
            }
        }
        return cardsByListId;
    }

    public void createNewCard(Map<Id, String> nameByListId) {
        List<Card__c> cards = new List<Card__c>();
        for (Id listId : nameByListId.keySet()) {
            Card__c card = new Card__c(Name = nameByListId.get(listId), List__c = listId);
            cards.add(card);
        }
        insert cards;
    }

    public void changeListName(Map<List__c, String> nameByList) {
        List<List__c> lists = new List<List__c>();
        for (List__c cList : nameByList.keySet()) {
            cList.Name = nameByList.get(cList);
            lists.add(cList);
        }
        update lists;
    }

    public void deleteList(List<List__c> cLists) {
        delete cLists;
    }

    public void deleteCard(List<Card__c> cards) {
        delete cards;
    }

    public Map<Id, List<CardUser__c>> getCardsMembers(List<Id> cardIds) {
        Map<Id, List<CardUser__c>> cardUsersByCardId = new Map<Id, List<CardUser__c>>();
        List<CardUser__c> cardUsers = [
                SELECT Id, Card__c, BoardUser__r.User__r.Name
                FROM CardUser__c
                WHERE Card__c = :cardIds
        ];

        for (CardUser__c cardUser : cardUsers){
            if (cardUsersByCardId.keySet().contains(cardUser.Card__c)) {
                cardUsersByCardId.get(cardUser.Card__c).add(cardUser);
            } else {
                cardUsersByCardId.put(cardUser.Card__c, new List<CardUser__c>{cardUser});
            }
        }
        return cardUsersByCardId;
    }

    public Map<Id, List<BoardUser__c>> getBoardMembers(List<Id> boardIds) {
        Map<Id, List<BoardUser__c>> boardUsersByBoardId = new Map<Id, List<BoardUser__c>>();
        List<BoardUser__c> boardUsers = [
                SELECT Id, Board__c, User__r.Name
                FROM BoardUser__c
                WHERE Board__c = :boardIds
        ];

        for (BoardUser__c boardUser : boardUsers){
            if (boardUsersByBoardId.keySet().contains(boardUser.Board__c)) {
                boardUsersByBoardId.get(boardUser.Board__c).add(boardUser);
            } else {
                boardUsersByBoardId.put(boardUser.Board__c, new List<BoardUser__c>{boardUser});
            }
        }
        return boardUsersByBoardId;
    }

    public void addCardMember(Map<Id, Id> boardMemberIdByCardId) {
        List<CardUser__c> cardUsers = new List<CardUser__c>();
        for (Id cardId : boardMemberIdByCardId.keySet()) {
            CardUser__c cardUser = new CardUser__c(Card__c = cardId, BoardUser__c = boardMemberIdByCardId.get(cardId));
            cardUsers.add(cardUser);
        }
        insert cardUsers;
    }

    public void deleteCardMember(Map<Id, Id> boardMemberIdByCardId) {
        List<CardUser__c> cardUsersForDelete = new List<CardUser__c>();
        List<CardUser__c> cardUsers = [SELECT Id, Card__c, BoardUser__c FROM CardUser__c];

        for (Id cardId : boardMemberIdByCardId.keySet()) {
            for (CardUser__c cardUser : cardUsers) {
                if (cardUser.Card__c == cardId && cardUser.BoardUser__c == boardMemberIdByCardId.get(cardId)) {
                    cardUsersForDelete.add(cardUser);
                }
            }
        }
        delete cardUsersForDelete;
    }

    public void uploadFileToDropBox(String fileName, String fileContents, String cardName) {
        Blob blobFileContent = EncodingUtil.base64Decode(fileContents);
        String uploadingFileName = cardName + '_' + fileName;
        API_token__c token = API_token__c.getValues('DropBox');
        String accessToken = token.Body__c;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://content.dropboxapi.com/2/files/upload');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/octet-stream');
        request.setHeader('Dropbox-API-Arg', '{"path":"/TrelloIntegr/' + uploadingFileName + '"}');
        request.setBodyAsBlob(blobFileContent);
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            String errorMessage = response.getStatusCode() + ' ' + response.getStatus();
            throw new CustomException(errorMessage);
        }
    }

    public List<File__c> createFile(Map <String, Id> cardIdByFileName) {
        List<File__c> files = new List<File__c>();
        for (String fileName : cardIdByFileName.keySet()) {
            File__c file = new File__c(Name = fileName, Card__c = cardIdByFileName.get(fileName));
            files.add(file);
        }
        insert files;
        return files;
    }

    public  Map<Id, List<File__c>> getFiles(List<Id> cardIds) {
        Map<Id, List<File__c>> filesByCardId = new Map<Id, List<File__c>>();
        List<File__c> files = [
                SELECT Id, Name, Card__c
                FROM File__c
                WHERE Card__c = :cardIds
        ];
        for (File__c file : files){
            if (filesByCardId.keySet().contains(file.Card__c)) {
                filesByCardId.get(file.Card__c).add(file);
            } else {
                filesByCardId.put(file.Card__c, new List<File__c>{file});
            }
        }
        return filesByCardId;
    }

    public void deleteFiles(List<File__c> files) {
        delete files;
    }

    public void deleteFileFromDropBox(String fileName, String cardName) {
        String deletingFileName = cardName + '_' + fileName;
        Http http = new Http();
        API_token__c token = API_token__c.getValues('DropBox');
        String accessToken =token.Body__c;
        String body = '{"path": "/TrelloIntegr/' + deletingFileName + '"}';
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.dropboxapi.com/2/files/delete_v2');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        request.setTimeout(120000);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 200) {
            String errorMessage = response.getStatusCode() + ' ' + response.getStatus();
            throw new CustomException(errorMessage);
        }
    }
}