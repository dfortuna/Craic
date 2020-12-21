//
//  FriendshipRequestCollectionViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 16/12/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class FriendshipRequestCollectionViewCell: UICollectionViewCell, FIRObjectCell {

    private var user: User?
    weak var delegate: FIRCellButtonProtocol?

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var acceptButtonOutlet: UIButton!
    @IBOutlet weak var declineButtonOutlet: UIButton!
    
    @IBAction func acceptButton(_ sender: UIButton) {
        delegate?.handleAcceptButton(sender: self)
    }
    
    @IBAction func declineButton(_ sender: UIButton) {
        delegate?.handleDeclineButton(sender: self)
    }
    
    func formatCellUI(withData cellData: FIRCellInputObj, hasPermission: Bool) {
        guard let user = cellData.user else { return }
        self.user = user
        self.format()
        backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        userNameLabel.text = user.name
        acceptButtonOutlet.formatCustomButtonEnabled(forTitle: "Accept")
        declineButtonOutlet.formatCustomButtonDecline(forTitle: "Decline")
        userImageView.load(urlString: user.profileImage) { (_) in }
    }
}
