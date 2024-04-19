import UIKit

public extension String {
    func setColor(_ color: UIColor, ofSubstring substring: String) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: substring)
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        return attributedString
    }
    
    func add(boldText: String, boldFont: UIFont, boldTextColor: UIColor) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        if let range = attributedString.string.range(of: boldText) {
            let nsRange = NSRange(range, in: attributedString.string)
            
            attributedString.addAttribute(.font, value: boldFont, range: nsRange)
            attributedString.addAttribute(.foregroundColor, value: boldTextColor, range: nsRange)
        }
        
        return attributedString
    }
}
