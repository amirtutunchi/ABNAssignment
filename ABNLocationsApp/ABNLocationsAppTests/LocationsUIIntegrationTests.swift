import Combine
import XCTest
import UIKit
import ABNLocations
import ABNLocationiOS
import ABNLocationsApp

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

// MARK: - Test Helpers
extension LocationsUIIntegrationTests {
    private func makeSUT(
        openCoordinate: @escaping (_ latitude: Double, _ longitude: Double) -> Void = { _, _ in },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocationsListViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = LocationUIComposer.locationsComposedWith(
            locationLoader: loader.loadPublisher,
            openCoordinate: openCoordinate
        )
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy {
        
        private var locationRequests = [PassthroughSubject<[Location], Error>]()
        
        var loadLocationsCallCount: Int {
            return locationRequests.count
        }
        
        func loadPublisher() -> AnyPublisher<[Location], Error> {
            let publisher = PassthroughSubject<[Location], Error>()
            locationRequests.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
     
        func completeLocationLoading(
            with locations: [Location] = [],
            at index: Int = 0
        ) {
            locationRequests[index].send(locations)
        }
    }
    
    func assertThat(_ sut: LocationsListViewController, isRendering locations: [Location], file: StaticString = #file, line: UInt = #line) {
            sut.view.enforceLayoutCycle()
            
            guard sut.numberOfRenderedLocationViews() == locations.count else {
                return XCTFail("Expected \(locations.count) locations, got \(sut.numberOfRenderedLocationViews()) instead.", file: file, line: line)
            }
            
            locations.enumerated().forEach { index, image in
                assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
            }
        }
        
        func assertThat(_ sut: LocationsListViewController, hasViewConfiguredFor location: Location, at index: Int, file: StaticString = #file, line: UInt = #line) {
            let view = sut.locationView(at: index)
            
            guard let cell = view as? LocationCell else {
                return XCTFail("Expected \(LocationCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
            }
            
            
            XCTAssertEqual(cell.nameText, location.name, "Expected name text to be \(String(describing: location.name)) for location view at index (\(index))", file: file, line: line)
            XCTAssertEqual(cell.latitudeText, String(location.latitude), "Expected latitude text to be \(String(describing: location.latitude)) for location view at index (\(index))", file: file, line: line)
            
            XCTAssertEqual(cell.longitudeText, String(location.longitude), "Expected longitude text to be \(String(describing: location.longitude)) for location view at index (\(index)", file: file, line: line)
        }
}

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension LocationsListViewController {
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateTapOnLocation(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: locationSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    private var locationSection: Int { 0 }
    
    func numberOfRenderedLocationViews() -> Int {
        return tableView.numberOfRows(inSection: locationSection)
    }
        
    func locationView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedLocationViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: locationSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

extension LocationCell {
    var nameText: String? {
        nameLabel.text
    }
    
    var latitudeText: String? {
        latitudeLabel.text
    }
    
    var longitudeText: String? {
        longitudeLabel.text
    }
}

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
