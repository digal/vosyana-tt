//
//  TTCallbackController.swift
//  App
//
//  Created by Юрий Буянов on 14/01/2019.
//

import Vapor

final class TTCallbackController {


    func handleMessage(_ req: Request) throws -> Future<HTTPStatus> {
        if let data = req.http.body.data {
            print(String(data: data, encoding: .utf8) ?? "n/a")
        } else {
            print("empty request")
        }
        
        return req.future(.ok)
    }

}
