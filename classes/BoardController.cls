
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
            boardService.createNewBoard(name);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<List__c> getListsByBoardId(Board__c board) {
        try {
           return boardService.getListsByBoardId(board);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void createNewList(String name, Board__c board) {
        try {
            boardService.createNewList(name, board);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeBoardName(Board__c board, String newName) {
        try {
            boardService.changeBoardName(board, newName);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeCardListId(Card__c card, Id listId) {
        try {
           boardService.changeCardListId(card, listId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteBoard(Board__c board){
        try {
            boardService.deleteBoard(board);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void addMember(Board__c board, Id userId) {
        try {
            boardService.addMember(board, userId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<BoardUser__c> getMembers(Board__c board) {
        try {
           return boardService.getMembers(board);
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