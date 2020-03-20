
public with sharing class BoardController {

    private static BoardService boardService = new BoardService();


    @AuraEnabled
    public static List<Board__c> getAllBoards() {
        try {
            return boardService.getAllBoards();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createNewBoard(String name) {
        try {
            List<String> names = new List<String>();
            names.add(name);
            boardService.createNewBoard(names);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<List__c> getListsByBoardId(Id boardId) {
        try {
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
           return boardService.getListsByBoardId(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createNewList(String name, Id boardId) {
        try {
            Map<Id,String> nameByBoardId = new Map<Id, String>();
            nameByBoardId.put(boardId, name);
            boardService.createNewList(nameByBoardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeBoardName(Board__c board, String newName) {
        try {
            Map<Board__c,String> nameByBoard = new Map<Board__c, String>();
            nameByBoard.put(board, newName);
            boardService.changeBoardName(nameByBoard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeListIdOnCard(Card__c card, Id listId) {
        try {
            Map<Card__c, Id> listIdByCard = new Map<Card__c, Id>();
            listIdByCard.put(card, listId);
           boardService.changeListIdOnCard(listIdByCard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteBoard(Board__c board){
        try {
            List<Board__c> boards = new List<Board__c>();
            boards.add(board);
            boardService.deleteBoard(boards);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addMember(Id boardId, Id userId) {
        try {
            Map<Id, Id> userByBoard = new Map<Id, Id>();
            userByBoard.put(boardId, userId);
            boardService.addMember(userByBoard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<BoardUser__c> getMembers(Id boardId) {
        try {
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
           return boardService.getMembers(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<User> getUsers() {
        try {
            return boardService.getUsers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteMember(Id memberId, Board__c board) {
        try {
            boardService.deleteMember(memberId, board);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}