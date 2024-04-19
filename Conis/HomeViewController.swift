import UIKit
class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()

    private let coinListCell = "CoinListCell"
    private let topRankCell = "TopRankCryptoTableViewCell"
    private let titleCell = "TitleCell"
    private let inviteFriendCell = "InviteFriendCell"

    private var sections: [HomeSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControl()
        registerCells()
        createSections()
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: coinListCell, bundle: nil), forCellReuseIdentifier: coinListCell)
        tableView.register(UINib(nibName: topRankCell, bundle: nil), forCellReuseIdentifier: topRankCell)
        tableView.register(UINib(nibName: titleCell, bundle: nil), forCellReuseIdentifier: titleCell)
        tableView.register(UINib(nibName: inviteFriendCell, bundle: nil), forCellReuseIdentifier: inviteFriendCell)

    }
    
    private func addRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func createSections() {
        sections.append(.title("Top 3 rank crypto".setColor(.red, ofSubstring: "3")))
        sections.append(.topRank(data: []))
        sections.append(.title(NSAttributedString(string: "Buy, sell and hold crypto")))
        sections.append(.coinList(data: []))
    }
}

extension HomeViewController {
    @objc private func refresh() {
        refreshControl.endRefreshing()
    }
}

// MARK: - Tableview methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        switch currentSection {
        case let .topRank(data):
            let cell = tableView.dequeueReusableCell(withIdentifier: topRankCell, for: indexPath)
            return cell
        case let .coinList(data):
            var cell = tableView.dequeueReusableCell(withIdentifier: coinListCell, for: indexPath)
            // FIX ME: it should be 5, 10, 20
            if indexPath.row > 0 && indexPath.row % 5 == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: inviteFriendCell, for: indexPath)
            }
            return cell
        case let .title(text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: titleCell, for: indexPath) as? TitleCell else {
                return UITableViewCell()
            }
            cell.configure(title: text)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[section]
        switch currentSection {
        case let .coinList(data):
            return 10
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

// Search
// pull to refresh
// pagination
// show invite friend in correct position
// open share sheet on tap
// add error state
// add empty state
// check internet connection
// Networking
// unit testing
// ui testing
// run in iPad
// shimmer if possible
