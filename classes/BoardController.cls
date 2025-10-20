//
// BoardController.cls
// Controller class for Trello-like board management
// AI-generated header: Handles board, list, card, and member operations for the Trello app
//
// @author: AI Assistant
// @date: 2024-06-11
//

public with sharing class BoardController {
    // Service layer for board operations
    private static BoardService boardService = new BoardService();

    /**
     * Get all boards
     * @return List of Board__c
     */
    @AuraEnabled
    public static List<Board__c> getAllBoards() {
        try {
            // Return all boards using the service layer
            return boardService.getAllBoards();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Create a new board
     * @param name Board name
     */
    @AuraEnabled
    public static void createNewBoard(String name) {
        try {
            // Prepare board name list for service
            List<String> names = new List<String>();
            names.add(name);
            boardService.createNewBoard(names);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get lists by board Id
     * @param boardId Board Id
     * @return List of List__c
     */
    @AuraEnabled
    public static List<List__c> getListsByBoardId(Id boardId) {
        try {
            // Prepare board Ids for service
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
            return boardService.getListsByBoardId(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Create a new list on a board
     * @param name List name
     * @param boardId Board Id
     */
    @AuraEnabled
    public static void createNewList(String name, Id boardId) {
        try {
            // Map list name to board Id for service
            Map<Id, String> nameByBoardId = new Map<Id, String>();
            nameByBoardId.put(boardId, name);
            boardService.createNewList(nameByBoardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Change board name
     * @param boardId Board Id
     * @param newName New board name
     */
    @AuraEnabled
    public static void changeBoardName(Id boardId, String newName) {
        try {
            // Map new name to board Id for service
            Map<Id, String> nameByBoard = new Map<Id, String>();
            nameByBoard.put(boardId, newName);
            boardService.changeBoardName(nameByBoard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Change list Id on card
     * @param card Card__c
     * @param listId List Id
     */
    @AuraEnabled
    public static void changeListIdOnCard(Card__c card, Id listId) {
        try {
            // Map card to new list Id for service
            Map<Card__c, Id> listIdByCard = new Map<Card__c, Id>();
            listIdByCard.put(card, listId);
            boardService.changeListIdOnCard(listIdByCard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Delete a board
     * @param board Board__c
     */
    @AuraEnabled
    public static void deleteBoard(Board__c board){
        try {
            // Delete board using service
            List<Board__c> boards = new List<Board__c>{board};
            boardService.deleteBoard(boards);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Add member to board
     * @param boardId Board Id
     * @param userId User Id
     */
    @AuraEnabled
    public static void addMember(Id boardId, Id userId) {
        try {
            // Map user to board for service
            Map<Id, Id> userByBoard = new Map<Id, Id>();
            userByBoard.put(boardId, userId);
            boardService.addMember(userByBoard);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get members of a board
     * @param boardId Board Id
     * @return List of BoardUser__c
     */
    @AuraEnabled
    public static List<BoardUser__c> getMembers(Id boardId) {
        try {
            // Prepare board Ids for service
            List<Id> boardIds = new List<Id>();
            boardIds.add(boardId);
            return boardService.getMembers(boardIds).get(boardId);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Get all users
     * @return List of User
     */
    @AuraEnabled
    public static List<User> getUsers() {
        try {
            // Return all users from service
            return boardService.getUsers();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * Delete member from board
     * @param memberId User Id
     * @param board Board__c
     */
    @AuraEnabled
    public static void deleteMember(Id memberId, Board__c board) {
        try {
            // Remove member from board using service
            boardService.deleteMember(memberId, board);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
