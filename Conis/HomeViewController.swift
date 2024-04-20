import UIKit
import Combine

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private let coinListCell = "CoinListCell"
    private let topRankCell = "TopRankCryptoTableViewCell"
    private let titleCell = "TitleCell"
    private let inviteFriendCell = "InviteFriendCell"
    
    @IBOutlet weak var searchBar: UISearchBar!
    private var sections: [HomeSection] = []
    let viewModel = HomeViewModel()
    var cancellable = Set<AnyCancellable>()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        addRefreshControl()
        registerCells()
        bind()
        Task {
            await viewModel.getCoins()
        }
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
    
    private func createSections(data: [CoinsData]) {
        sections.removeAll()
        if !isSearching || !viewModel.topRankCoins.isEmpty {
            sections.append(.title("Top 3 rank crypto".setColor(.red, ofSubstring: "3")))
            sections.append(.topRank(data: viewModel.topRankCoins))
        }
        sections.append(.title(NSAttributedString(string: "Buy, sell and hold crypto")))
        sections.append(.coinList(data: data))
        Task { @MainActor in
            tableView.reloadData()
        }
    }
}

extension HomeViewController {
    @objc private func refresh() {
        refreshControl.endRefreshing()
    }
    
    private func bind() {
        viewModel.$coinsData
            .sink(receiveValue: { data in
                self.createSections(data: data)
            }).store(in: &cancellable)
    }
}

// MARK: - Tableview methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[indexPath.section]
        switch currentSection {
        case let .topRank(coinData):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: topRankCell, for: indexPath) as? TopRankCryptoTableViewCell else {
                return UITableViewCell()
            }
            cell.applySnapshot(with: coinData)
            return cell
        case let .coinList(coinData):
            let data = coinData[indexPath.row]
            switch data {
            case .inviteFriend:
                return tableView.dequeueReusableCell(withIdentifier: inviteFriendCell, for: indexPath)
            case let .coin(coin):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: coinListCell, for: indexPath) as? CoinListCell else {
                    return UITableViewCell()
                }
                cell.configure(coin: coin)
                return cell
            }
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
            return data.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
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
// create theme for color and font
