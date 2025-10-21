/**
 * BoardController
 *
 * This Apex controller manages board, list, card, and member operations for the Trello-like application.
 *
 * - Provides AuraEnabled methods for Lightning/Aura components
 * - Handles board creation, list management, member management, and more
 * - All methods are wrapped in try/catch for safe exception handling
 *
 * @author AI Generated
 * @date 2025-10-21
 */
public with sharing class BoardController {

    // Service layer for board operations
    private static BoardService boardService = new BoardService();

    /**
     * Get all boards
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
     * Create a new board with the given name
     * @param boardName The name of the new board
     */
    @AuraEnabled
    public static void createNewBoard(String boardName) {
        try {
            // Prepare a list of board names for creation
            List<String> names = new List<String>();
            names.add(boardName);
            boardService.createNewBoard(names);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get all lists for a given board
     * @param boardId The Id of the board
     * @return List of List__c records for the board
     */
    @AuraEnabled
    public static List<List__c> getListsByBoardId(Id boardId) {
        try {
            // Prepare a list of board IDs for the service call
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
            // Pass the correct list of board IDs (not null)
            return boardService.getListsByBoardId(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Create a new list for a board
     * @param name The name of the new list
     * @param boardId The Id of the board
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
     * Change the name of a board
     * @param boardId The Id of the board
     * @param newName The new name for the board
     */
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

    /**
     * Change the list Id on a card
     * @param card The card to update
     * @param listId The new list Id
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
     * Delete a board
     * @param board The board to delete
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
     * Add a member to a board
     * @param boardId The Id of the board
     * @param userId The Id of the user to add
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
     * Get all members of a board
     * @param boardId The Id of the board
     * @return List of BoardUser__c records for the board
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
     * Get all users
     * @return List of User records
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
     * Delete a member from a board
     * @param memberId The Id of the member
     * @param board The board from which to remove the member
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
