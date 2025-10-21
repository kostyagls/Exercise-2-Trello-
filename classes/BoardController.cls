// ============================================================================
// Apex Class: BoardController
// Description: Controller for Board operations. Provides AuraEnabled methods
//              for board, list, and member management in the Trello-like app.
// AI-generated header: All changes below are documented inline.
// ============================================================================

public with sharing class BoardController {
    // Service instance for board operations
    private static BoardService boardService = new BoardService();

    /**
     * Retrieves all Board__c records.
     * @return List of Board__c
     */
    @AuraEnabled
    public static List<Board__c> getAllBoards() {
        try {
            // AI Fix: Removed commented-out code and fixed typo in method call
            return boardService.getAllBoards(); // AI: Fixed typo in method name
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Creates a new Board__c record with the given name.
     * @param name Name of the new board
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

    /**
     * Retrieves lists by Board Id.
     * @param boardId Board Id
     * @return List of List__c
     */
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

    /**
     * Creates a new List__c record for a given board.
     * @param name Name of the new list
     * @param boardId Board Id
     */
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

    /**
     * Changes the name of a board.
     * @param boardId Board Id
     * @param newName New name for the board
     */
    @AuraEnabled
    public static void changeBoardName(Id boardId, String newName) {
        try {
            Map<Id,String> nameByBoard = new Map<Id, String>();
            nameByBoard.put(boardId, newName);
            boardService.changeBoardName(nameByBoard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Changes the List Id on a Card.
     * @param card Card__c record
     * @param listId New List Id
     */
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

    /**
     * Deletes a board.
     * @param board Board__c record
     */
    @AuraEnabled
    public static void deleteBoard(Board__c board){
        try {
            List<Board__c> boards = new List<Board__c>{board};
            boardService.deleteBoard(boards);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Adds a member to a board.
     * @param boardId Board Id
     * @param userId User Id
     */
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

    /**
     * Retrieves members of a board.
     * @param boardId Board Id
     * @return List of BoardUser__c
     */
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

    /**
     * Retrieves all users.
     * @return List of User
     */
    @AuraEnabled
    public static List<User> getUsers() {
        try {
            return boardService.getUsers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Deletes a member from a board.
     * @param memberId User Id
     * @param board Board__c record
     */
    @AuraEnabled
    public static void deleteMember(Id memberId, Board__c board) {
        try {
            boardService.deleteMember(memberId, board);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
