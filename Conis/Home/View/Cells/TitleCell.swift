//
//  TitleCell.swift
//  Conis
//
//  Created by Bismillah on 20/4/2567 BE.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        accessibilityIdentifier = AccessibilityId.Home.titleCell.rawValue
    }
    
    func configure(title: NSAttributedString) {
        titleLabel.attributedText = title
    }
}
