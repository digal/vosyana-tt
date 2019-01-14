import Vapor

public struct BotInfo: Codable {
    let name: String
    let userId: Int
    
    private enum CodingKeys : String, CodingKey {
        case name, userId = "user_id"
    }
}

public final class Credentials : Provider {
    public let token: String
    public let host = "test2.tamtam.chat"
    
    public var info: BotInfo?
    
    public init(token: String) {
        self.token = token
    }

    public func register(_ services: inout Services) throws {
        
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return HTTPClient.connect(scheme: .https,
                                  hostname: self.host,
                                  on: container).flatMap { (client) -> EventLoopFuture<Void> in
            let infoRequest = HTTPRequest(method: .GET, url: "/me?access_token=\(self.token)")
            return client.send(infoRequest).do({ (resp) in
                print("response: \(resp.body)")
                if let respData = resp.body.data,
                    let info = try? JSONDecoder().decode(BotInfo.self, from: respData) {
                    self.info = info
                }
            }).map({ (resp) -> (Void) in
                return ()
            })
        }
    }
    
    
    
    
}
