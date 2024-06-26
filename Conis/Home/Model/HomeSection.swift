import Foundation
enum HomeSection: Equatable {
    static func == (lhs: HomeSection, rhs: HomeSection) -> Bool {
        return lhs.key == rhs.key
    }
    
    case topRank(data: [Coin])
    case coinList(data: [CoinsData])
    case title(NSAttributedString)
    
    var key: String {
        switch self {
        case .topRank:
            return "topRank"
        case .coinList:
            return "coinList"
        case .title(let text):
            return text.string
        }
    }
}
