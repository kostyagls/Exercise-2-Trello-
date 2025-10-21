/**
 * BoardController
 *
 * Controller class for managing Board, List, Card, and Member operations in the Trello-like application.
 * Provides AuraEnabled methods for Lightning/Aura components.
 *
 * PMD compliance: Unused variable removed, method naming fixed, null argument corrected, logic comments added.
 */
public with sharing class BoardController {

    // Service layer for board operations
    private static BoardService boardService = new BoardService();

    /**
     * Retrieves all boards.
     */
    @AuraEnabled
    public static List<Board__c> getAllBoards() {
        try {
            return boardService.getAllBoards();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Creates a new board with the given name.
     * PMD: Method name fixed, unused variable removed.
     */
    @AuraEnabled
    public static void createNewBoard(String name) {
        try {
            // Prepare list of board names
            List<String> names = new List<String>();
            names.add(name);
            boardService.createNewBoard(names);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Retrieves lists for a given board ID.
     * PMD: Null argument fixed.
     */
    @AuraEnabled
    public static List<List__c> getListsByBoardId(Id boardId) {
        try {
            // Prepare list of board IDs
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
            return boardService.getListsByBoardId(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Creates a new list for a board.
     */
    @AuraEnabled
    public static void createNewList(String name, Id boardId) {
        try {
            // Map boardId to list name
            Map<Id,String> nameByBoardId = new Map<Id, String>();
            nameByBoardId.put(boardId, name);
            boardService.createNewList(nameByBoardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Changes the name of a board.
     */
    @AuraEnabled
    public static void changeBoardName(Id boardId, String newName) {
        try {
            // Map boardId to new name
            Map<Id,String> nameByBoard = new Map<Id, String>();
            nameByBoard.put(boardId, newName);
            boardService.changeBoardName(nameByBoard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Changes the list ID on a card.
     */
    @AuraEnabled
    public static void changeListIdOnCard(Card__c card, Id listId) {
        try {
            // Map card to new listId
            Map<Card__c, Id> listIdByCard = new Map<Card__c, Id>();
            listIdByCard.put(card, listId);
            boardService.changeListIdOnCard(listIdByCard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Deletes a board.
     */
    @AuraEnabled
    public static void deleteBoard(Board__c board){
        try {
            // Add board to list for deletion
            List<Board__c> boards = new List<Board__c>{board};
            boardService.deleteBoard(boards);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Adds a member to a board.
     */
    @AuraEnabled
    public static void addMember(Id boardId, Id userId) {
        try {
            // Map boardId to userId
            Map<Id, Id> userByBoard = new Map<Id, Id>();
            userByBoard.put(boardId, userId);
            boardService.addMember(userByBoard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Retrieves members for a board.
     */
    @AuraEnabled
    public static List<BoardUser__c> getMembers(Id boardId) {
        try {
            // Prepare list of board IDs
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
            return boardService.getMembers(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Retrieves all users.
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
