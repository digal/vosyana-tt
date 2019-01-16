//
//  TTCallbackController.swift
//  App
//
//  Created by Юрий Буянов on 14/01/2019.
//

import Vapor
import Foundation

final class TTCallbackController {
    func handleMessage(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.content.decode(Message.self).flatMap { msg in
            let reply: String?
            
            let chatType: String
            if (msg.recipient.chatId > 0) {
                chatType = "DIALOG"
            } else {
                chatType = "MULTI"
            }
            
            if let text = msg.message.text {
                reply = try req.make(PhrasesService.self).getPhrase(for: text,
                                                                    from: msg.sender.userName,
                                                                    in: chatType)
            } else {
                reply = nil
            }
            
            if let reply = reply {
                print("reply: \(reply)")
            
                let credentials = try req.make(Credentials.self)
                let outgoingMessage = OutgoingMessage(with: reply)

                return try req
                            .client()
                            .post("https://\(credentials.host)/messages?access_token=\(credentials.token)&chat_id=\(msg.recipient.chatId)") { (post) in
                                try post.content.encode(outgoingMessage)
                            }.map{ $0.http.status }
                
            } else {
                print("no reply")
            }
            
            fflush(stdout)
            
            return req.future(.ok)
        }
    }

}
