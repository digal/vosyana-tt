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
                
                return HTTPClient.connect(scheme: .https,
                                          hostname: credentials.host,
                                          on: req).flatMap { (client) -> EventLoopFuture<HTTPStatus> in
                                            let outgoingMessage = OutgoingMessage(with: reply)
                                            let outgoingJson = try! JSONEncoder().encode(outgoingMessage)
                                            let msgRequest = HTTPRequest(method: .POST, url: "/messages?access_token=\(credentials.token)&chat_id=\(msg.recipient.chatId)", body: outgoingJson)
                                            return client.send(msgRequest).do({ (resp) in
//                                                print("msg send response: \(resp.body)")
                                                fflush(stdout)
                                            }).map({ (resp) -> (HTTPStatus) in
                                                return .ok
                                            })
                }
            } else {
                print("no reply")
            }
            
            fflush(stdout)
            
            return req.future(.ok)
        }
    }

}
