import UIKit

class DetailViewController: UITableViewController {
    @IBOutlet var searchBar: UISearchBar!

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return searchBar
        default:
            return nil
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}
