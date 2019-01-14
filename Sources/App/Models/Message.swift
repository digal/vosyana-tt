import FluentSQLite
import Vapor

final class Message: SQLiteModel {
    var id: Int?
    var chatId: Int
    var senderId: Int
    var senderName: String
    var text: String

    
}
