import XCTest
import ABNLocationiOS
import ABNLocations

final class LocationsListSnapshotTests: XCTestCase {
    func test_locationsList_emptyList() {
        let sut = makeSUT()
        
        sut.display(emptyList())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    func test_locationsList_loadingState() {
        let sut = makeSUT()
        
        sut.display(LocationLoadingViewModel(isLoading: true))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LOADING_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LOADING_LIST_dark")
    }
    
    func test_locationsList_locationListWithData() {
        let sut = makeSUT()
        
        sut.display(fullList())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "LOCATION_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "LOCATION_LIST_dark")
    }
}

// MARK: - Test Helpers
extension LocationsListSnapshotTests {
    private func makeSUT() -> LocationsListViewController {
        let bundle = Bundle(for: LocationsListViewController.self)
        let storyboard = UIStoryboard(name: "LocationsList", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! LocationsListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [LocationCellController] {
        return []
    }
    
    private func fullList() -> [LocationCellController] {
        [
            LocationCellController(
                viewModel: LocationViewModel(
                    name: nil,
                    latitude: 12.12344,
                    longitude: 21.56435
                ),
                openCoordinate:  { _, _ in  }
            ),
            LocationCellController(
                viewModel: LocationViewModel(
                    name: "Malibu",
                    latitude: 12.12344,
                    longitude: 21.5643
                ),
                openCoordinate:  { _, _ in  }
            ),
            LocationCellController(
                viewModel: LocationViewModel(
                    name: "Esfahan",
                    latitude: 12.123,
                    longitude: 21.56435
                ),
                openCoordinate:  { _, _ in  }
            )
        ]
    }
}
