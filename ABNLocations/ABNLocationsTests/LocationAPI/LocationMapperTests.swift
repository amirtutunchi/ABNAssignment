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
}

// MARK: - Test Helpers
extension LocationMapperTests {
    
    func makeLocationsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["Locations": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
}
