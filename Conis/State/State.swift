import Foundation

enum State: Equatable {
    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.key == rhs.key
    }
    case loading
    case normal
    case data([CoinsData])
    case error(Error)
    
    var key: String {
        switch self {
        case .loading:
            return "loading"
        case .normal:
            return "normal"
        case .data(_):
            return "data"
        case .error(_):
            return "error"
        }
    }
}
