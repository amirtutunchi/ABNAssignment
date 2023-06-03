import Foundation

public final class LocationMapper {
    private struct Root: Decodable {
        private let locations: [RemoteLocation]
        
        private struct RemoteLocation: Decodable {
            let name: String?
            let lat: Double
            let long: Double
        }
        
        var toDomainLocations: [Location] {
            locations.map {
                Location(
                    name: $0.name,
                    latitude: $0.lat,
                    longitude: $0.long
                )
            }
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Location] {
        guard response.statusCode == 200,  let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.toDomainLocations
    }
}
