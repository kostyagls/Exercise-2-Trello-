
public with sharing class BoardService {


    public List<Board__c> getAllBoards() {
        return [SELECT Id, Name FROM Board__c ORDER BY CreatedDate];
    }

    public void createNewBoard(List<String> names) {
        List<Board__c> boards = new List<Board__c>();
        for (String name : names) {
            Board__c board = new Board__c(Name = name);
            boards.add(board);
        }
        insert boards;
    }

//    public Map<Id, List<List__c>> getListsByBoardId(List<Id> boardIds) {
//        Map<Id, List<List__c>> listsByBoardId = new Map<Id, List<List__c>>();
//        List<List__c> lists = [
//                SELECT Id, Name, Board__c, (SELECT Id, Name, Description__c FROM Cards__r ORDER BY CreatedDate)
//                FROM List__c
//                WHERE Board__c = :boardIds
//                ORDER BY CreatedDate
//        ];
//        for (Id boardId : boardIds) {
//            List<List__c> lists2 = new List<List__c>();
//            for (List__c cList : lists) {
//                if (cList.Board__c == boardId) {
//                    lists2.add(cList);
//                }
//            }
//            listsByBoardId.put(boardId, lists2);
//        }
//        return listsByBoardId;
//    }

    public Map<Id, List<List__c>> getListsByBoardId(List<Id> boardIds) {
        Map<Id, List<List__c>> listsByBoardId = new Map<Id, List<List__c>>();
        List<List__c> lists = [
                SELECT Id, Name, Board__c, (SELECT Id, Name, Description__c FROM Cards__r ORDER BY CreatedDate)
                FROM List__c
                WHERE Board__c = :boardIds
                ORDER BY CreatedDate
        ];
        for (List__c cList : lists){
            if (listsByBoardId.keySet().contains(cList.Board__c)) {
                listsByBoardId.get(cList.Board__c).add(cList);
            } else {
                listsByBoardId.put(cList.Board__c, new List<List__c>{cList});
            }
        }
        return listsByBoardId;
    }

    public void createNewList(Map<Id, String> nameByBoardId) {
        List<List__c> lists = new List<List__c>();
        for (Id boardId : nameByBoardId.keySet()) {
            List__c cList = new List__c(Name = nameByBoardId.get(boardId), Board__c = boardId);
            lists.add(cList);
        }
        insert lists;
    }

    public void changeBoardName(Map<Board__c, String> nameByBoard) {
        List<Board__c> boards = new List<Board__c>();
        for (Board__c board : nameByBoard.keySet()) {
            board.Name = nameByBoard.get(board);
            boards.add(board);
        }
        update boards;
    }

    public void changeListIdOnCard(Map<Card__c, Id> listIdByCard) {
        List<Card__c> cards = new List<Card__c>();
        for (Card__c card : listIdByCard.keySet()) {
            card.List__c = listIdByCard.get(card);
            cards.add(card);
        }
        update cards;
    }

    public void deleteBoard(List<Board__c> boards) {
        delete boards;
    }

    public void addMember(Map<Id, Id> userByBoard) {
        List<BoardUser__c> boardUsers = new List<BoardUser__c>();

        for (Id boardId : userByBoard.keySet()) {
            BoardUser__c boardUser = new BoardUser__c(Board__c = boardId, User__c = userByBoard.get(boardId));
            boardUsers.add(boardUser);
        }
        insert boardUsers;
    }

//    public Map<Id, List<BoardUser__c>> getMembers(List<Id> boardIds) {
//        Map<Id, List<BoardUser__c>> boardUsersByBoardId = new Map<Id, List<BoardUser__c>>();
//        List<BoardUser__c> boardUsers = [
//                SELECT Id, User__c, User__r.Name, Board__c
//                FROM BoardUser__c
//                WHERE Board__c = :boardIds
//        ];
//        for (Id boardId : boardIds) {
//            List<BoardUser__c> boardUsers2 = new List<BoardUser__c>();
//            for (BoardUser__c boardUser : boardUsers) {
//                if (boardUser.Board__c == boardId) {
//                    boardUsers2.add(boardUser);
//                }
//            }
//            boardUsersByBoardId.put(boardId, boardUsers2);
//        }
//        return boardUsersByBoardId;
//    }

    public Map<Id, List<BoardUser__c>> getMembers(List<Id> boardIds) {
        Map<Id, List<BoardUser__c>> boardUsersByBoardId = new Map<Id, List<BoardUser__c>>();
        List<BoardUser__c> boardUsers = [
                SELECT Id, User__c, User__r.Name, Board__c
                FROM BoardUser__c
                WHERE Board__c = :boardIds
        ];

        for (BoardUser__c boardUser : boardUsers) {
            if (boardUsersByBoardId.keySet().contains(boardUser.Board__c)) {
                boardUsersByBoardId.get(boardUser.Board__c).add(boardUser);
            } else {
                boardUsersByBoardId.put(boardUser.Board__c, new List<BoardUser__c>{boardUser});
            }
        }
        return boardUsersByBoardId;
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

        for (BoardUser__c boardUser : boardUsers) {
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