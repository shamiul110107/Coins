import UIKit

public extension String {
    func setColor(_ color: UIColor, ofSubstring substring: String) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: substring)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return attributedString
    }
    
    func add(boldText: String, boldFont: UIFont, boldTextColor: UIColor = .black) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        if let range = attributedString.string.range(of: boldText) {
            let nsRange = NSRange(range, in: attributedString.string)
            
            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: boldTextColor, range: nsRange)
        }
        
        return attributedString
    }
}

public extension String {
    func formatNumber(_ fractionDigit: Int) -> String {
        guard let number = Double(self) else {
            return "Invalid number"
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = fractionDigit

        switch number {
        case 0..<1_000_000_000:
            let millions = Double(number / 1_000_000)
            return "\(numberFormatter.string(from: NSNumber(value: millions)) ?? "") million"
        case 1_000_000_000..<1_000_000_000_000:
            let billions = Double(number / 1_000_000_000)
            return "\(numberFormatter.string(from: NSNumber(value: billions)) ?? "") billion"
        default:
            let trillions = Double(number / 1_000_000_000_000)
            return "\(numberFormatter.string(from: NSNumber(value: trillions)) ?? "") trillion"
        }
    }
}
