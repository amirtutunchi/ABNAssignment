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

}

final class LocationPresentationTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
}

// MARK: - Test Helpers
extension LocationPresentationTests {
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocationsPresentation, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LocationsPresentation(loadingView: view, locationView: view) { locations in
            []
        }
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: LocationView, LocationLoadingView {
        typealias ResourceViewModel = String
        
        enum Message: Hashable {
            case display(isLoading: Bool)
            case display(resourceViewModel: [LocationViewModel])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: LocationLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: [LocationViewModel]) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }
}
