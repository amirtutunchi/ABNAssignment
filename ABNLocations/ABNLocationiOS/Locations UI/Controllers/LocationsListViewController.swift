import ABNLocations
import UIKit

public final class LocationsListViewController: UITableViewController {
    public var openCoordinate: ((_ latitude: Double, _ longitude: Double) -> Void)?
    public var onRefresh: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    @IBAction private func refresh() {
        onRefresh?()
    }
    
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
       tableModel[indexPath.row].view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableModel[indexPath.row].didSelectedCell()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func promptForNewLocation() {
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
        let closeAction = UIAlertAction(title: "Close", style: .destructive)
        alertController.addAction(closeAction)
        return alertController
    }
}

extension LocationsListViewController: LocationView, LocationLoadingView {
    public func display(_ viewModel: [ABNLocations.LocationViewModel]) {
        display(
            viewModel.map{
                LocationCellController(
                    viewModel: $0,
                    openCoordinate: openCoordinate ?? { _, _ in }
                )
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

