import Foundation

public final class LocationMapper {
    private struct Root: Decodable {
        private let locations: [RemoteLocation]
        
        private struct RemoteLocation: Decodable {
            let name: String?
            let lat: Double
            let long: Double
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws {
        guard response.statusCode == 200, ((try? JSONDecoder().decode(Root.self, from: data)) != nil)  else {
            throw Error.invalidData
        }
    }
}
