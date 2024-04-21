import UIKit
import Combine

class CoinDetailViewController: UIViewController {
    @IBOutlet weak var coinIcon: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var descriptionlabel: UITextView!
    @IBOutlet weak var websiteButton: UIButton!
    
    let viewModel = CoinDetailViewModel()
    var uuid: String?
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        guard let uuid else { return }
        Task { @MainActor in
            hideAll()
        }
        Task {
            await viewModel.getCoinDetails(by: uuid)
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func goToWebsiteButtonAction(_ sender: Any) {
        guard let webUrl = viewModel.coin?.websiteUrl, let url = URL(string: webUrl) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension CoinDetailViewController {
    private func bind() {
        viewModel.$coin
            .sink { [weak self] data in
                Task { @MainActor in
                    self?.showAll()
                }
                self?.showCoinDetails(coin: data)
            }
            .store(in: &cancellable)
    }
    
    private func showCoinDetails(coin: Coin?) {
        Task { @MainActor in
            if let iconURL = coin?.url, let url = URL(string: iconURL) {
                coinIcon.kf.setImage(with: url)
            }
            
            coinNameLabel.attributedText = "\(coin?.name ?? "") (\(coin?.symbol ?? ""))"
                .add(boldText: coin?.name ?? "",
                     boldFont: UIFont.systemFont(ofSize: 18, weight: .bold),
                     boldTextColor: .init(hexString: coin?.color ?? "#F7931A"))
            
            if let price = coin?.price, var formattedPrice = Double(price)?.formattedCurrency(2) {
                formattedPrice = formattedPrice.replacingOccurrences(of: "US", with: "")
                priceLabel.attributedText = "PRICE \(formattedPrice)"
                    .add(boldText: "PRICE",
                         boldFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            }
            
            if let marketCap = coin?.marketCap?.formatNumber(2) {
                marketCapLabel.attributedText = "MARKET CAP $\(marketCap)"
                    .add(boldText: "MARKET CAP",
                         boldFont: UIFont.systemFont(ofSize: 12, weight: .bold))
            }
            descriptionlabel.text = coin?.description ?? ""
        }
    }
    
    func hideAll() {
        coinIcon.isHidden = true
        coinNameLabel.isHidden = true
        priceLabel.isHidden = true
        marketCapLabel.isHidden = true
        descriptionlabel.isHidden = true
        websiteButton.isHidden = true
    }
    
    func showAll() {
        coinIcon.isHidden = false
        coinNameLabel.isHidden = false
        priceLabel.isHidden = false
        marketCapLabel.isHidden = false
        descriptionlabel.isHidden = false
        websiteButton.isHidden = false
    }
}
