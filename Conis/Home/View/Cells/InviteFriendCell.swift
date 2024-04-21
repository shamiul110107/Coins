//
//  InviteFriendCell.swift
//  Conis
//
//  Created by Bismillah on 20/4/2567 BE.
//

import UIKit

class InviteFriendCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var inviteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        containerView.layer.cornerRadius = 8
        inviteLabel.attributedText = "You can earn $10  when you invite a friend to buy crypto. Invite your friend".add(boldText: "Invite your friend", boldFont: UIFont.systemFont(ofSize: 16, weight: .bold), boldTextColor: .init(hexString: "#38A0FF"))
    }
}
