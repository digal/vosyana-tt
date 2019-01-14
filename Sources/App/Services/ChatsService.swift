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
        self.credentials = try! container.make(Credentials.self)
        return self.update(container).do({ (chats) in
            self.chats = chats
        }).map{ (chats) -> (Void) in
            return ()
        }
    }
    
    func update(_ container: Container) -> EventLoopFuture<[Chat]> {
        return HTTPClient.connect(scheme: .https,
                                  hostname: self.credentials.host,
                                  on: container).flatMap { (client) -> EventLoopFuture<[Chat]> in
                                    let infoRequest = HTTPRequest(method: .GET, url: "/chats?access_token=\(self.credentials.token)")
                                    return client.send(infoRequest).map({ (resp) -> ([Chat]) in
                                        print("response: \(resp.body)")
                                        if let respData = resp.body.data {
                                            do {
                                                let resp = try JSONDecoder().decode(ChatsResponse.self, from: respData)
                                                return resp.chats
                                            } catch {
                                                print(error)
                                                return []
                                            }
                                        } else {
                                            return []
                                        }
                                    })
        }
    }
    
    
}
