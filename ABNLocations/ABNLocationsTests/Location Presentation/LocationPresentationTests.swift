import XCTest
import ABNLocations
public struct LocationLoadingViewModel {
    public let isLoading: Bool
}
public struct LocationViewModel: Hashable {
    public let name: String?
    public let latitude: Double
    public let longitude: Double
}
public protocol LocationView {
    func display(_ viewModel: [LocationViewModel])
}
public protocol LocationLoadingView {
    func display(_ viewModel: LocationLoadingViewModel)
}
public class LocationsPresentation {
    public init(
        loadingView: LocationLoadingView,
        locationView: LocationView,
        mapper: @escaping (_ locations: [Location]) -> [LocationViewModel]
    ) {
        self.loadingView = loadingView
        self.locationView = locationView
        self.mapper = mapper
    }
    
    private let loadingView: LocationLoadingView
    private let locationView: LocationView
    private let mapper: (_ locations: [Location]) -> [LocationViewModel]
    
    public func didStartLoading() {
        loadingView.display(.init(isLoading: true))
    }
    
    public func didFinishLoading(with locations: [Location]) {
        locationView.display(mapper(locations))
        loadingView.display(.init(isLoading: false))
    }

}

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
