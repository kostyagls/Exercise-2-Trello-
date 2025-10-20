/*
 * BoardController.cls
 * Controller for Board operations in Trello-like app
 * Author: AI Assistant
 * Last Modified: 2024-06
 *
 * This class provides AuraEnabled methods for board management, including CRUD operations and member management.
 * All methods enforce sharing and best practices for Apex code.
 */
public with sharing class BoardController {
    // Service for board operations
    private static BoardService boardService = new BoardService();

    /**
     * Gets all boards in the org
     * @return List<Board__c>
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
     * Creates a new board with the given name
     * @param name Board name
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
     * Gets lists by board Id
     * @param boardId Board Id
     * @return List<List__c>
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
     * Creates a new list for a board
     * @param name List name
     * @param boardId Board Id
     */
    @AuraEnabled
    public static void createNewList(String name, Id boardId) {
        try {
            Map<Id, String> nameByBoardId = new Map<Id, String>();
            nameByBoardId.put(boardId, name);
            boardService.createNewList(nameByBoardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Changes board name
     * @param boardId Board Id
     * @param newName New name
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
     * Changes list Id on card
     * @param card Card__c
     * @param listId List Id
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
     * Deletes a board
     * @param board Board__c
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
     * Adds a member to a board
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
     * Gets members of a board
     * @param boardId Board Id
     * @return List<BoardUser__c>
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
     * Gets all users
     * @return List<User>
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
     * Deletes a member from a board
     * @param memberId Member Id
     * @param board Board__c
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
