
public with sharing class BoardUserTriggerHandler {

    private BoardService boardService = new BoardService();

    public void beforeInsert(List<BoardUser__c> boardUsers) {
        boardService.shareAccessToBoards(boardUsers);
    }

    public void beforeDelete(List<BoardUser__c> boardUsers) {
        boardService.deleteAccessToBoards(boardUsers);
    }
}