//
//  MessagesDetailTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 28/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol MessageDetailProtocol: class {
    func handleDeleteMessage(sender: MessagesDetailTableViewCell)
    func handleReplyMesage(sender: MessagesDetailTableViewCell)
}

class MessagesDetailTableViewCell: UITableViewCell {
    
    var messageToDisplay: Message?
    var delegate:  MessageDetailProtocol?

    @IBOutlet weak var senderProfilePicture: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var buttonsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var replyMessageOutletButton: UIButton!
    @IBOutlet weak var deleteMessageOutletButton: UIButton!
    @IBOutlet weak var deleteMessageTitleOutlet: UIButton!
    
    
    @IBAction func deleteMessageButton(_ sender: UIButton) {
        self.delegate?.handleDeleteMessage(sender: self)
    }
    
    @IBAction func replyButton(_ sender: UIButton) {
        self.delegate?.handleReplyMesage(sender: self)
    }
    
    @IBAction func deleteMessageTitle(_ sender: UIButton) {
        self.delegate?.handleDeleteMessage(sender: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .white
        }
    }
    
    override func prepareForReuse() {
        replyMessageOutletButton.isHidden = false
        replyMessageOutletButton.layer.cornerRadius = 10
        replyMessageOutletButton.layer.borderColor = Colors.mainColor?.cgColor
        replyMessageOutletButton.layer.borderWidth = 1

        deleteMessageOutletButton.isHidden = false
        deleteMessageOutletButton.layer.cornerRadius = 10
        deleteMessageOutletButton.layer.borderColor = Colors.mainColor?.cgColor
        deleteMessageOutletButton.layer.borderWidth = 1

    }
    
    override func awakeFromNib() {
        print("test")
    }
    
  
    
    func formatUI(forMessage message: Message, buttonsEnable: Bool) {
        
        if buttonsEnable {
            replyMessageOutletButton.isHidden = false
            replyMessageOutletButton.layer.cornerRadius = 10
            replyMessageOutletButton.layer.borderColor = Colors.mainColor?.cgColor
            replyMessageOutletButton.layer.borderWidth = 1
            
            deleteMessageOutletButton.isHidden = false
            deleteMessageOutletButton.layer.cornerRadius = 10
            deleteMessageOutletButton.layer.borderColor = Colors.mainColor?.cgColor
            deleteMessageOutletButton.layer.borderWidth = 1
            
            deleteMessageTitleOutlet.isHidden = true
            buttonsHeightConstraint.constant = 35
            buttonsTopConstraint.constant = 12
        } else {
            buttonsHeightConstraint.constant = 0
            buttonsTopConstraint.constant = 0
            replyMessageOutletButton.isHidden = true
            deleteMessageOutletButton.isHidden = true
            deleteMessageTitleOutlet.isHidden = false
        }        
        messageToDisplay = message
        loadProfilePicture()
        loadText()
    }
    
    private func loadProfilePicture() {
        guard let mURL = messageToDisplay?.senderProfilePicture else { return }
        senderProfilePicture.layer.cornerRadius = 34.5
        if let profilePictureURL = URL(string: mURL) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: profilePictureURL)  else { return }
                DispatchQueue.main.async {
                    self.senderProfilePicture.image = UIImage(data: imageData)
                }
            }
        } else {
            senderProfilePicture.image = Icons.userPictureNotFound
        }
    }
    
    private func loadText() {
        guard let message = messageToDisplay else { return }
        
        senderName.text = message.senderName
        dateLabel.text = message.stringDate.convertToddMMMDateformat()
        messageTextView.text = message.text
        messageTextView.dynamicHeight()
    }
    
    private func formatButtons(isTheLastMessage: Bool) {
        if !isTheLastMessage {
            buttonsHeightConstraint.constant = 0
            buttonsTopConstraint.constant = 0
        }
    }
}
