import FluentSQLite
import Vapor

final class Chat: SQLiteModel, Decodable {
    var id: Int?
    var type: String //TODO: enum
    var status: String
    var title: String?
    var lastEventTime: Int
    
    private enum CodingKeys : String, CodingKey {
        case id = "chat_id", type, status, title, lastEventTime = "last_event_time"
    }

    
}

class ChatsResponse: Decodable {
    let chats: [Chat]
    let marker: Int?
}
