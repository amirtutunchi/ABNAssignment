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
