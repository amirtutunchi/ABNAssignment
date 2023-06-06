import UIKit
import ABNLocations

public final class LocationCellController {
    private let openCoordinate: (_ latitude: Double, _ longitude: Double) -> Void
    private let viewModel: LocationViewModel
    
    public init(
        viewModel: LocationViewModel,
        openCoordinate: @escaping (_ latitude: Double, _ longitude: Double) -> Void
    ) {
        self.viewModel = viewModel
        self.openCoordinate = openCoordinate
    }
    
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: LocationCell = tableView.dequeueReusableCell()
        cell.nameLabel.text = viewModel.name ?? "No name"
        cell.latitudeLabel.text = String(viewModel.latitude)
        cell.longitudeLabel.text = String(viewModel.longitude)
        return cell
    }
    
    public func didSelectedCell() {
        openCoordinate(viewModel.latitude, viewModel.longitude)
    }
}

