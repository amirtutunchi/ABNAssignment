import UIKit
import ABNLocations

public final class LocationsListViewController: UITableViewController {
    var openCoordinate: ((_ latitude: Double, _ longitude: Double) -> Void)?
    private var tableModel: [LocationCellController] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBAction func newLocation_Tapped(_ sender: UIBarButtonItem) {
        promptForNewLocation()
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
    
    public func promptForNewLocation() {
        present(createPromptForNewLocation(), animated: false)
    }
    
    public func createPromptForNewLocation() -> UIAlertController {
        let alertController = UIAlertController(title: "Enter the location manually", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "latitude"
            textField.keyboardType = .numbersAndPunctuation
        }
        alertController.addTextField { textField in
            textField.placeholder = "longitude"
            textField.keyboardType = .numbersAndPunctuation
        }
        let submitAction = UIAlertAction(title: "Go", style: .default) { [weak self, weak alertController] _ in
            guard let lat = Double(alertController?.textFields?[0].text ?? ""), let long = Double(alertController?.textFields?[1].text ?? "") else { return }
            self?.openCoordinate?(lat, long)
        }
        alertController.addAction(submitAction)
        return alertController
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

