import UIKit

class CoinGridCell: UICollectionViewCell {
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var iconArrow: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.addShadow()
        accessibilityIdentifier = AccessibilityId.Home.gridCell.rawValue
    }
    
    func configure(coin: Coin) {

        if let iconURL = coin.url, let url = URL(string: iconURL) {
            coinImageView.kf.setImage(with: url)
        }
        nameLabel.text = coin.name ?? ""
        symbolLabel.text = coin.symbol
        symbolLabel.textColor = .init(hexString: coin.color ?? "#3C3C3C")
        
        iconArrow.isHidden = coin.change == nil
        if let change = coin.change, let changeDouble = Double(change) {
            iconArrow.image = (changeDouble < 1) ? UIImage(named: "ic-arrow-down") : UIImage(named: "ic-arrow-up")
            changeLabel.textColor = (changeDouble < 1) ? .init(hexString: "#F82D2D") : .init(hexString: "#13BC24")
            changeLabel.text = changeDouble.formatted(2)
        }
    }
}
