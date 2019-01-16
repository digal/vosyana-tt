//
//  ChatsService.swift
//  App
//
//  Created by Юрий Буянов on 14/01/2019.
//

import Vapor



final class ChatsService: Provider {
    var chats: [Chat] = []
    var credentials: Credentials!
    
    public init() {
        
    }
    
    func register(_ services: inout Services) throws {
        
    }
    
    func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        self.credentials = try container.make(Credentials.self)
        return try self.update(container).do({ (resp) in
            self.chats = resp.chats
        }).map{ (chats) -> (Void) in
            return ()
        }
    }
    
    func update(_ container: Container) throws -> EventLoopFuture<ChatsResponse> {
        return try container
                    .client()
                    .get("https://\(self.credentials.host)/chats?access_token=\(self.credentials.token)")
                    .flatMap { (resp) -> EventLoopFuture<ChatsResponse> in
                        return try resp.content.decode(ChatsResponse.self)
                    }
    }
    
    
    
}
