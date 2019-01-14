import Vapor

public struct BotInfo: Codable {
    let name: String
    let userId: Int
    
    private enum CodingKeys : String, CodingKey {
        case name, userId = "user_id"
    }
}

public final class Credentials: Service {
    let token: String
    let host: String
    var info: BotInfo?
    
    init(token: String, host: String) {
        self.token = token
        self.host = host
    }
}

public final class CredentialsProvider : Provider  {
    let credentials: Credentials
    let token: String
    let host = "test2.tamtam.chat"

    init(token: String) {
        self.token = token
        self.credentials = Credentials(token: token, host: self.host)
    }

    public func register(_ services: inout Services) throws {
        services.register(self.credentials)
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return HTTPClient.connect(scheme: .https,
                                  hostname: self.host,
                                  on: container).flatMap { (client) -> EventLoopFuture<Void> in
            let infoRequest = HTTPRequest(method: .POST, url: "/me?access_token=\(self.token)")
            return client.send(infoRequest).do({ (resp) in
                print("response: \(resp.body)")
                if let respData = resp.body.data,
                    let info = try? JSONDecoder().decode(BotInfo.self, from: respData) {
                    self.credentials.info = info
                }
            }).map({ (resp) -> (Void) in
                return ()
            })
        }
    }
    
    
    
    
}
