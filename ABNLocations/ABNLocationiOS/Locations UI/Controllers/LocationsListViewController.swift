import UIKit
import ABNLocations

public final class LocationsListViewController: UITableViewController {
    private var tableModel: [LocationCellController] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    public func display(_ cellControllers: [LocationCellController]) {
        tableModel = cellControllers
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableModel[indexPath.row].view(in: tableView)
    }
}

extension LocationsListViewController: LocationView, LocationLoadingView {
    public func display(_ viewModel: [ABNLocations.LocationViewModel]) {
        display(
            viewModel.map{
                LocationCellController(viewModel: $0)
            }
        )
    }
    
    public func display(_ viewModel: ABNLocations.LocationLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
}

