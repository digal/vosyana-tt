//
//  TTCallbackController.swift
//  App
//
//  Created by Юрий Буянов on 14/01/2019.
//

import Vapor
import Foundation

final class TTCallbackController {
    func handleMessage(_ req: Request) throws -> Future<String> {
        
        print("TTCallbackController handleMessage: \(req)")
        if let data = req.http.body.data {
            print("body: \(String(data: data, encoding: .utf8) ?? "n/a")")
        } else {
            print("empty request")
        }
        
        fflush(stdout)
        
        return req.future("TT callback")
    }

}
