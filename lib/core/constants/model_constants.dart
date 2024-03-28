/// This file contains all the constants used in the models of the application.
/// This file is used to avoid hardcoding the strings and to avoid any typo errors.
/// This file is used to maintain the consistency of the keys used in the models.

/// This class contains all the constants used in the User model.
class UserConstants {
  static const String userUid = 'useruid';
  static const String userEmailAddress = 'useremail';
  static const String userName = 'username';
  static const String userPhotoUrl = 'userphotourl';
}

class MessageConfig {
  static const String senderId = 'sender_id';
  static const String receiverId = 'receiver_id';
  static const String message = 'message';
  static const String timestamp = 'timestamp';
}

/// This class contains all the constants used in the Chatroom model.
class ChatroomConfig {
  // static const String id = 'id';
  // static const String name = 'name';
  // static const String description = 'description';
  // static const String imageUrl = 'imageUrl';
  // static const String members = 'members';
  // static const String lastMessage = 'lastMessage';
  // static const String lastMessageAt = 'lastMessageAt';
  // static const String createdAt = 'createdAt';
  // static const String updatedAt = 'updatedAt';

  static const String userIds = 'user_ids';
  static const String bookId = 'book_id';
  static const String bookBorrowRequestId = 'borrow_request_id';
  static const String chatRoomId = 'chat_room_id';
}

class ChatRoomConfig {
  static const String chatRoomId = 'chat_room_id';
  static const String bookId = 'book_id';
  static const String borrowRequestId = 'borrow_request_id';
  static const String userIds = 'user_ids';
}

/// This class contains all the constants used in the BorrowRequest model.
class BorrowRequestConfig {
  static const String reqBookID = 'req_book_id';
  static const String reqBookOwnerID = 'req_book_owner_id';
  static const String reqBookStatus = 'req_book_status';
  static const String requesterID = 'requester_id';
  static const String timestamp = 'req_timestamp';
  static const String reqStartDate = 'req_start_date';
  static const String reqEndDate = 'req_end_date';
  static const String reqStatus = 'req_status';
  static const String reqID = 'req_id';
}

/// This class contains all the constants used in the Book model.
class BookConfig {
  static const String bookTitle = 'book_title';
  static const String bookAuthor = 'book_author';
  static const String bookPublication = 'book_publication';
  static const String bookCondition = 'book_condition';
  static const String bookGenre = 'book_genre';
  static const String bookAvailability = 'book_availability';
  static const String bookCoverImageUrl = 'book_coverimg_url';
  static const String bookOwnerID = 'book_owner';
  static const String bookID = 'book_id';
  static const String bookRating = 'book_rating';
  static const String location = 'book_exchange_location';
  static const String completeAddress = 'book_exchange_address';
}
