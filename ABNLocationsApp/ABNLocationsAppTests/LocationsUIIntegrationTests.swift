import ABNLocations
import XCTest

final class LocationsUIIntegrationTests: XCTestCase {
    
    func test_loadLocation_requestLocationFromLoader() {
        let (sut , loader) = makeSUT()
        XCTAssertEqual(loader.loadLocationsCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadLocationsCallCount, 1, "Expected a loading request once view is loaded")
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadLocationsCallCount, 1, "Expected no request until previous completes")
    }
    
    func test_selectingLocation_notifiesHandler() {
        let location = Location(name: "test", latitude: 12.323, longitude: 22.3231)
        var receivedLocations = [(latitude: Double, longitude: Double)]()
        let (sut , loader) = makeSUT(
            openCoordinate: { latitude, longitude in
                receivedLocations.append((latitude: latitude, longitude: longitude))
            }
        )
        sut.loadViewIfNeeded()
        loader.completeLocationLoading(with: [location, location], at: 0)

        sut.simulateTapOnLocation(at: 0)
        
        XCTAssertEqual(receivedLocations.count, 1)
        XCTAssertEqual(receivedLocations.first?.latitude, location.latitude)
        XCTAssertEqual(receivedLocations.first?.longitude, location.longitude)
    }
    
    func test_loadLocation_rendersSuccessfullyLoadedLocations() {
        let location1 = Location(name: "test1", latitude: 12.323, longitude: 22.3231)
        let location2 = Location(name: "test2", latitude: 43.2222, longitude: 55.2222)

       
        let (sut , loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeLocationLoading(with: [location1, location2], at: 0)
        assertThat(sut, isRendering: [location1, location2])
    }
    
    func test_loadLocationCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeLocationLoading(at: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}
