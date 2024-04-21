import UIKit

enum Section {
    case main
}

class TopRankCryptoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Coin>!
    var cellTapped: ((Coin) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        registerCell()
        collectionView.collectionViewLayout = createLayout()
        createDataSource()
        applySnapshot(with: [])
    }
    
    private func registerCell() {
        let nib = UINib(nibName: "CoinGridCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CoinGridCell")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Coin>(collectionView: collectionView) { collectionView, indexPath, coin in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinGridCell", for: indexPath) as? CoinGridCell else {
                return UICollectionViewCell.init()
            }
            cell.configure(coin: coin)
            return cell
        }
    }
    
    func applySnapshot(with coins: [Coin]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Coin>()
        snapshot.appendSections([.main])
        snapshot.appendItems(coins)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension TopRankCryptoTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let coin = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        cellTapped?(coin)
    }
}
