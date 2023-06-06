import ABNLocations
import ABNLocationiOS
import Combine
import UIKit

public typealias LocationLoader = AnyPublisher<[Location], Error>

public final class LocationUIComposer {
    private init() { }
    
    public static func locationsComposedWith(
        locationLoader: @escaping () -> LocationLoader,
        openCoordinate: @escaping (_ latitude: Double, _ longitude: Double) -> Void
    ) -> LocationsListViewController {
        let presentationAdaptor = LocationLoaderPresentationAdaptor(locationLoader: locationLoader)
        let controller = makeLocationsListViewController()
        controller.openCoordinate = openCoordinate
        controller.onRefresh = presentationAdaptor.loadLocations
        let presentation = LocationsPresentation(
            loadingView: WeakRefVirtualProxy(controller),
            locationView: WeakRefVirtualProxy(controller)) {
                locations in
                locations.map {
                    LocationViewModel(name: $0.name, latitude: $0.latitude, longitude: $0.longitude)
                }
            }
        presentationAdaptor.locationPresenter = presentation
        return controller
    }
    
    private static func makeLocationsListViewController() -> LocationsListViewController {
        let bundle = Bundle(for: LocationsListViewController.self)
        let storyboard = UIStoryboard(name: "LocationsList", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! LocationsListViewController
        return controller
    }
}

final class LocationLoaderPresentationAdaptor {
    let locationLoader: () -> LocationLoader
    var locationPresenter: LocationsPresentation?
    private var cancellable: Cancellable?
    private var isLoading = false

    init(locationLoader: @escaping () -> LocationLoader) {
        self.locationLoader = locationLoader
    }
    
    func loadLocations() {
        guard !isLoading else { return }

        locationPresenter?.didStartLoading()
        isLoading = true

        cancellable = locationLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] _ in
                    self?.isLoading = false
                },
                receiveValue: { [weak self] locations in
                    self?.locationPresenter?.didFinishLoading(with: locations)
                }
            )
    }
}
