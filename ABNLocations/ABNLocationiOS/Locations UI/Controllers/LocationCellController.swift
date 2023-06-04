import UIKit
import ABNLocations

public final class LocationCellController {
    
    public init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
    }
    
    private let viewModel: LocationViewModel
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: LocationCell = tableView.dequeueReusableCell()
        cell.nameLabel.text = viewModel.name ?? "No name"
        cell.latitudeLabel.text = String(viewModel.latitude)
        cell.longitudeLabel.text = String(viewModel.longitude)
        return cell
    }
}

