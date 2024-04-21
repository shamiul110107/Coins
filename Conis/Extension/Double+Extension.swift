import Foundation
public extension Double {
    func formattedCurrency(code: String = "USD", _ factionDigit: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = code
        numberFormatter.minimumFractionDigits = factionDigit
        return numberFormatter.string(from: NSNumber(value: self))
    }
    
    func formatted(_ factionDigit: Int) -> String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.minimumFractionDigits = factionDigit
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
