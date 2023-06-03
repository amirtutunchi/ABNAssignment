import XCTest
import ABNLocations

final class LocationMapperTests: XCTestCase {
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeLocationsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try LocationMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try LocationMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoLocationsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeLocationsJSON([])
        
        let result = try LocationMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversLocationsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(name: nil, lat: 23.432423, long: 14.7678)
        
        let item2 = makeItem(name: "barcelona", lat: 32.432423, long: 41.7678)
        
        let json = makeLocationsJSON([item1.json, item2.json])
        
        let result = try LocationMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])
    }
}

// MARK: - Test Helpers
extension LocationMapperTests {
    
    func makeLocationsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["locations": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeItem(
        name: String? = nil,
        lat: Double,
        long: Double
    ) -> (
        model: Location,
        json: [String: Any]
    ) {
        let location = Location(name: name, latitude: lat, longitude: long)
        
        let json = [
            "name": name as Any,
            "lat": lat,
            "long": long
        ].compactMapValues { $0 }
        
        return (location, json)
    }
}
