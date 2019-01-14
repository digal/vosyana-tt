//
//  ChatsService.swift
//  App
//
//  Created by Юрий Буянов on 14/01/2019.
//

import Vapor

final class ChatsService: Provider {
    func register(_ services: inout Services) throws {
        
    }
    
    func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    
}
