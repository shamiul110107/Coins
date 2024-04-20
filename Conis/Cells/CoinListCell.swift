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
    }
    
    func configure(coin: Coin) {

        if let iconURL = coin.url, let url = URL(string: iconURL) {
            coinIcon.kf.setImage(with: url)
        }
        coinNameLabel.text = coin.name
        coinSymbol.text = coin.symbol
        if let price = coin.price, let priceDouble = Double(price)?.formatted(factionDigit: 5) {
            coinPrice.text = priceDouble.replacingOccurrences(of: "US", with: "")
        }
        changeLabel.text = coin.change
        if let change = coin.change, let changeFloat = Float(change) {
            iconArrow.image = (changeFloat < 1) ? UIImage(named: "ic-arrow-down") : UIImage(named: "ic-arrow-up")
            changeLabel.textColor = (changeFloat < 1) ? .init(hexString: "#F82D2D") : .init(hexString: "#13BC24")
        }
    }
}
