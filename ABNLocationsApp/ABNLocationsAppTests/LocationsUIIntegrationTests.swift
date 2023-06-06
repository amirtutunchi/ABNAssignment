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
        
        loader.completeFeedLoading(at: 0)
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadLocationsCallCount, 2, "Expected another loading request once user initiates a reload")
        
        loader.completeFeedLoading(at: 1)
        sut.simulateUserInitiatedReload()
        XCTAssertEqual(loader.loadLocationsCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
}

// MARK: - Test Helpers
extension LocationsUIIntegrationTests {
    private func makeSUT(
        openCoordinate: ((_ latitude: Double, _ longitude: Double) -> Void)? = nil,
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
     
        func completeFeedLoading(
            with locations: [Location] = [],
            at index: Int = 0
        ) {
            locationRequests[index].send(locations)
            locationRequests[index].send(completion: .finished)
        }
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
}
