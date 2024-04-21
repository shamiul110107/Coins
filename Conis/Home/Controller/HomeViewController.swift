import UIKit
import Combine

let coinListCell = "CoinListCell"
let topRankCell = "TopRankCryptoTableViewCell"
let titleCell = "TitleCell"
let inviteFriendCell = "InviteFriendCell"

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private let debounceQueue = DispatchQueue(label: "com.example.debounce", qos: .userInitiated)
    private var debounceWorkItem: DispatchWorkItem?
    
    @IBOutlet weak var searchBar: UISearchBar!
    var sections: [HomeSection] = []
    let viewModel = HomeViewModel()
    var cancellable = Set<AnyCancellable>()
    var loaderFooterView: LoaderFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        setupUI()
        addRefreshControl()
        registerCells()
        bind()
        viewModel.state = .loading
        Task {
            await viewModel.getCoins(page: 1)
        }
    }
    
    func setupUI() {
        loaderFooterView = LoaderFooterView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
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
        Task { @MainActor in
            if searchBar.searchTextField.text?.isEmpty ?? false && !data.isEmpty {
                sections.append(.title("Top 3 rank crypto".setColor(.red, ofSubstring: "3")))
                sections.append(.topRank(data: viewModel.topRankCoins))
            }
            if !data.isEmpty {
                sections.append(.title(NSAttributedString(string: "Buy, sell and hold crypto")))
                sections.append(.coinList(data: data))
            }
            tableView.reloadData()
        }
    }
}

extension HomeViewController {
    @objc private func refresh() {
        refreshControl.endRefreshing()
        searchBar.resignFirstResponder()
        viewModel.reset()
        Task {
            await viewModel.getCoins(page: viewModel.currentPage)
        }
    }
    
    private func bind() {
        viewModel.$state
            .sink { [weak self] state in
                self?.showData(state: state)
            }
            .store(in: &cancellable)
        
        loaderFooterView?.tryAgainTapped = { [weak self] in
            self?.loadMore()
        }
    }
    
    func goToDetailView(coin: Coin) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationVC = storyboard.instantiateViewController(withIdentifier: "CoinDetailViewController") as? CoinDetailViewController
        else { return }
        destinationVC.uuid = coin.uuid
        present(destinationVC, animated: true)
    }
    
    func share() {
        let text = "Download Coin App"
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        present(activityViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Task {
            await viewModel.searchCoins(with: searchBar.searchTextField.text ?? "")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debounceWorkItem?.cancel()
        debounceWorkItem = DispatchWorkItem { [weak self] in
            Task {
                await self?.viewModel.searchCoins(with: searchText)
            }
        }
        debounceQueue.asyncAfter(deadline: .now() + 0.5, execute: debounceWorkItem!)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tableView.setContentOffset(CGPointZero, animated: true)
        return true
    }
}

extension HomeViewController {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if searchBar.isFirstResponder {
            return
        }
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height) {
            if viewModel.currentPage <= viewModel.totalPage {
                loadMore()
            }
        }
    }
    
    private func loadMore() {
        showData(state: .loading)
        Task {
            await viewModel.getCoins(page: viewModel.currentPage)
        }
    }
    
    private func showData(state: State) {
        Task { @MainActor in
            switch state {
            case .loading:
                showLoaderFooterView()
            case .normal:
                hideFooterView()
            case let .data(data):
                hideFooterView()
                viewModel.currentPage += 1
                createSections(data: data)
            case .error(_):
                showErrorFooterView()
            }
        }
    }
    
    private func showLoaderFooterView() {
        loaderFooterView?.startAnimating()
        loaderFooterView?.showLoader()
        tableView.tableFooterView = loaderFooterView
    }
    
    private func showErrorFooterView() {
        loaderFooterView?.startAnimating()
        loaderFooterView?.hideLoader()
        tableView.tableFooterView = loaderFooterView
    }
    
    private func hideFooterView() {
        loaderFooterView?.stopAnimating()
        tableView.tableFooterView = UIView()
    }
}
