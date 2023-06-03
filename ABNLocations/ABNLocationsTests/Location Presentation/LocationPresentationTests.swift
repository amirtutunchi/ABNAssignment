import XCTest
import ABNLocations

final class LocationPresentationTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoading_startsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(
            view.messages,
            [
                .display(isLoading: true)
            ]
        )
    }
    
    func test_didFinishLoadingLocation_displaysLocationsAndStopsLoading() {
        let mapper: (_ locations: [Location]) -> [LocationViewModel] = { locations in
            locations.map{
                LocationViewModel(
                    name: $0.name,
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
            }
        }
        let (sut, view) = makeSUT(mapper: mapper)
        
        let locations: [Location] = [
            .init(name: nil, latitude: 23.1234, longitude: 43.34244),
            .init(name: "any place", latitude: 12.3343, longitude: 21.3213)
        ]
        sut.didFinishLoading(with: locations)
        
        XCTAssertEqual(
            view.messages,
            [
                .display(locationsViewModel: mapper(locations)),
                .display(isLoading: false)
            ]
        )
    }
    
}

// MARK: - Test Helpers
extension LocationPresentationTests {
    private func makeSUT(
        mapper: @escaping (_ locations: [Location]) -> [LocationViewModel] = { _ in return [] } ,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocationsPresentation, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LocationsPresentation(
            loadingView: view,
            locationView: view,
            mapper: mapper
        )
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: LocationView, LocationLoadingView {
        typealias ResourceViewModel = String
        
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(locationsViewModel: [LocationViewModel])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: LocationLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: [LocationViewModel]) {
            messages.insert(.display(locationsViewModel: viewModel))
        }
    }
}
