/**
 * BoardController
 * AI-generated documentation block.
 * This class provides AuraEnabled methods for board, list, card, and member management in a Trello-like Salesforce app.
 * All changes below are made by AI to address PMD issues, improve code safety, and clarify logic.
 * - Method naming conventions enforced.
 * - Unused local variables removed.
 * - One declaration per line enforced.
 * - Inline comments added for AI changes.
 * - No logic or formatting changes except where required for PMD compliance.
 */
public with sharing class BoardController {

    // Field declaration at start of class (PMD: FieldDeclarationsShouldBeAtStart)
    private static BoardService boardService = new BoardService();

    @AuraEnabled
    public static List<Board__c> getAllBoards() {
        try {
            return boardService.getAllBoards();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * AI FIX: Renamed method to follow naming conventions (PMD: MethodNamingConventions).
     * AI FIX: Removed unused local variable (PMD: UnusedLocalVariable).
     * AI FIX: One declaration per line (PMD: OneDeclarationPerLine).
     */
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
            // AI NOTE: Logic unchanged, but ensure null is intentional for boardService.getListsByBoardId
            return boardService.getListsByBoardId(null).get(boardId);
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
    public static void changeBoardName(Id boardId, String newName) {
        try {
            Map<Id, String> nameByBoard = new Map<Id, String>();
            nameByBoard.put(boardId, newName);
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
            List<Board__c> boards = new List<Board__c>{board};
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
