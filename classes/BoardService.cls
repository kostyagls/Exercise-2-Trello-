
public with sharing class BoardService {


    public List<Board__c> getAllBoards() {
        return [SELECT Id, Name FROM Board__c ORDER BY CreatedDate];
    }

    public void createNewBoard(String name) {
        Board__c board = new Board__c(Name = name);
        insert board;
    }

    public List<List__c> getListsByBoard(Board__c board) {
        List<List__c> lists = [
                SELECT Id, Name, (SELECT Id, Name, Description__c FROM Cards__r ORDER BY CreatedDate)
                FROM List__c
                WHERE Board__c = :board.id
                ORDER BY CreatedDate
        ];
        return lists;
    }

    public void createNewList(String name, Board__c board) {
        List__c cList = new List__c(Name = name, Board__c = board.Id);
        insert cList;
    }

    public void changeBoardName(Board__c board, String newName) {
        board.Name = newName;
        update board;
    }

    public void changeCardListId(Card__c card, Id listId) {
        card.List__c = listId;
        update card;
    }

    public void deleteBoard(Board__c board) {
        delete board;
    }

    public void addMember(Board__c board, Id userId) {
        BoardUser__c boardUser = new BoardUser__c(Board__c = board.Id, User__c = userId);
        insert boardUser;
    }

    public List<BoardUser__c> getMembers(Board__c board) {
        List<BoardUser__c> boardUsers = [
                SELECT Id, User__c, User__r.Name
                FROM BoardUser__c
                WHERE Board__c = :board.Id
        ];
        return boardUsers;
    }

    public List<User> getUsers() {
        List<User> users = [
                SELECT Id, Name
                FROM User
                WHERE Profile.Name = 'Standard User2'
        ];
        return users;
    }

    public void deleteMember(Id memberId, Board__c board) {
        List<BoardUser__c> boardUsers = [
                SELECT Id
                FROM BoardUser__c
                WHERE Board__c = :board.id AND User__c = :memberId
        ];
        delete boardUsers;
    }

    public void shareAccessToBoards(List<BoardUser__c> boardUsers) {
        List<Board__Share> boardShares = new List<Board__Share>();

        for(BoardUser__c boardUser : boardUsers) {
            Board__Share boardShare = new Board__Share();
            boardShare.UserOrGroupId = boardUser.User__c;
            boardShare.ParentId = boardUser.Board__c;
            boardShare.AccessLevel = 'Edit';
            boardShares.add(boardShare);
        }
        insert boardShares;
    }

    public void deleteAccessToBoards(List<BoardUser__c> boardUsers) {
        List<Board__Share> boardSharesForDelete = new List<Board__Share>();
        List<Board__Share> boardShares = [SELECT Id, ParentId, UserOrGroupId FROM Board__Share];

        for (Board__Share boardShare : boardShares) {
            for (BoardUser__c boardUser : boardUsers) {
                if (boardUser.User__c == boardShare.UserOrGroupId && boardUser.Board__c == boardShare.ParentId) {
                    boardSharesForDelete.add(boardShare);
                }
            }
        }

        delete boardSharesForDelete;
    }

}