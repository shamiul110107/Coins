import Foundation
enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case responseError
    case decodingError
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid URL", comment: "Invalid URL")
        case .requestFailed:
            return NSLocalizedString("Request Failed", comment: "Request Failed")
        case .responseError:
            return NSLocalizedString("Unexpected status code", comment: "Invalid response")
        case .decodingError:
            return NSLocalizedString("Decoding Error", comment: "Decoding Error")
        case .unknown:
            return NSLocalizedString("Unknown error", comment: "Unknown error")
        }
    }
}
