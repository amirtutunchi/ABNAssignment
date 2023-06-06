import ABNLocations
import ABNLocationsApp
import ABNLocationiOS
import Combine
import XCTest

extension LocationsUIIntegrationTests {
    func makeSUT(
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
