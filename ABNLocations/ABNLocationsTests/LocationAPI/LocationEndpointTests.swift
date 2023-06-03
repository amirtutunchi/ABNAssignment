import XCTest
import ABNLocations

final class LocationEndpointTests: XCTestCase {
    func test_location_endPointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        let receivedURL = LocationEndpoint.get.url(baseURL: baseURL)
        let expectedURL = URL(string: "http://base-url.com/abnamrocoesd/assignment-ios/main/locations.json")
        XCTAssertEqual(receivedURL, expectedURL)
        
    }
}
