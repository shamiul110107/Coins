import UIKit

struct Item: Hashable {
    let id: UUID
    let name: String
}

enum Section {
    case main
}

class TopRankCryptoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        collectionView.collectionViewLayout = createLayout()
        createDataSource()
        applySnapshot()
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
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinGridCell", for: indexPath) as? CoinGridCell else {
                return UICollectionViewCell.init()
            }
            cell.nameLabel.text = item.name
            return cell
        }
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        let items = (0..<3).map { _ in Item(id: UUID(), name: "samiul\(Int.random(in: 0...100))") }
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

