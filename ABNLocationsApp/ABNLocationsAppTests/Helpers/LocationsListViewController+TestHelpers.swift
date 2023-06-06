import ABNLocationiOS
import UIKit

extension LocationsListViewController {
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateTapOnLocation(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: locationSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    private var locationSection: Int { 0 }
    
    func numberOfRenderedLocationViews() -> Int {
        return tableView.numberOfRows(inSection: locationSection)
    }
        
    func locationView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedLocationViews() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: locationSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

