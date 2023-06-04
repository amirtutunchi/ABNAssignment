import UIKit
import ABNLocations

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: LocationView where T: LocationView {
    func display(_ viewModel: [ABNLocations.LocationViewModel]) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: LocationLoadingView where T: LocationLoadingView {
    func display(_ viewModel: LocationLoadingViewModel) {
        object?.display(viewModel)
    }
}
