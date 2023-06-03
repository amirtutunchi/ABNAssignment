import Foundation

public final class LocationMapper {
    
    public enum Error: Swift.Error {
        case invalidStatusCode
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws {
        guard response.statusCode == 200 else {
            throw Error.invalidStatusCode
        }
    }
}
