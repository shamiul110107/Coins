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
    }
    
    func configure(coin: Coin) {

        if let iconURL = coin.url, let url = URL(string: iconURL) {
            coinImageView.kf.setImage(with: url)
        }
        nameLabel.text = coin.name
        symbolLabel.text = coin.symbol

        changeLabel.text = coin.change
        if let change = coin.change, let changeFloat = Float(change) {
            iconArrow.image = (changeFloat < 1) ? UIImage(named: "ic-arrow-down") : UIImage(named: "ic-arrow-up")
            changeLabel.textColor = (changeFloat < 1) ? .init(hexString: "#F82D2D") : .init(hexString: "#13BC24")
        }
    }
}
