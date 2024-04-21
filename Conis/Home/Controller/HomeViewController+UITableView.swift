
import Foundation
import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = sections[safe: indexPath.section]
        switch currentSection {
        case let .topRank(coinData):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: topRankCell, for: indexPath) as? TopRankCryptoTableViewCell else {
                return UITableViewCell()
            }
            cell.applySnapshot(with: coinData)
            cell.cellTapped = { [weak self] coin in
                self?.goToDetailView(coin: coin)
            }
            return cell
            
        case let .coinList(coinData):
            let data = coinData[safe: indexPath.row]
            switch data {
            case .inviteFriend:
                return tableView.dequeueReusableCell(withIdentifier: inviteFriendCell, for: indexPath)
            case let .coin(coin):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: coinListCell, for: indexPath) as? CoinListCell else {
                    return UITableViewCell()
                }
                cell.configure(coin: coin)
                return cell
            case .none:
                return UITableViewCell()
            }
            
        case let .title(text):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: titleCell, for: indexPath) as? TitleCell else {
                return UITableViewCell()
            }
            cell.configure(title: text)
            return cell
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = sections[safe: section]
        switch currentSection {
        case let .coinList(data):
            return data.count
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sections.count == 0 && searchBar.isFirstResponder {
            tableView.setEmptyMessage()
        } else {
            tableView.restore()
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentSection = sections[safe: indexPath.section]
        switch currentSection {
        case let .coinList(data):
            guard let coinData = data[safe: indexPath.row] else {
                return
            }
            switch coinData {
            case let .coin(data):
                goToDetailView(coin: data)
            case .inviteFriend:
                share()
            }
            
        default:
            print("do nothing")
        }
    }
}

extension UITableView {
    func setEmptyMessage() {
        let message = "Sorry\nNo result match this keyword".add(boldText: "Sorry", boldFont: .systemFont(ofSize: 20, weight: .bold))
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height))
        messageLabel.attributedText = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        backgroundView = messageLabel
    }

    func restore() {
        backgroundView = nil
    }
}
