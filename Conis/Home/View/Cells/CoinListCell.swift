import UIKit
import Kingfisher

class CoinListCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var coinIcon: UIImageView!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinSymbol: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var iconArrow: UIImageView!
    @IBOutlet weak var changeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.addShadow()
        selectionStyle = .none
        accessibilityIdentifier = AccessibilityId.Home.listCell.rawValue
    }
    
    func configure(coin: Coin) {

        if let iconURL = coin.url, let url = URL(string: iconURL) {
            coinIcon.kf.setImage(with: url)
        }
        coinNameLabel.text = coin.name ?? ""
        coinSymbol.text = coin.symbol ?? ""
        if let price = coin.price, let formattedPrice = Double(price)?.formattedCurrency(5) {
            coinPrice.text = formattedPrice.replacingOccurrences(of: "US", with: "")
        }
        if let change = coin.change, let changeDouble = Double(change) {
            iconArrow.image = (changeDouble < 1) ? UIImage(named: "ic-arrow-down") : UIImage(named: "ic-arrow-up")
            changeLabel.textColor = (changeDouble < 1) ? .init(hexString: "#F82D2D") : .init(hexString: "#13BC24")
            changeLabel.text = changeDouble.formatted(2)
            iconArrow.isHidden = false
        } else {
            iconArrow.isHidden = true
        }
    }
}
