import Foundation
extension Double {
    func formatted(currencyCode: String = "USD", factionDigit: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currencyCode
        numberFormatter.minimumFractionDigits = factionDigit
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
