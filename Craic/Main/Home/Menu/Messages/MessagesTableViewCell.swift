//
//  MessagesTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 6/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderProfilePicture: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    private var isRead = false
    private var messageData: Message?
    
    func setUI(messageData: Message, isRead: Bool){
        self.messageData = messageData
        self.isRead = isRead
        
        guard let formatedDate = messageData.stringDate.convertToddMMMDateformat() else { return }
        if isRead {
            configureReadCell(name: messageData.senderName, date: formatedDate, text: messageData.text)
        } else {
            configureUnreadCell(name: messageData.senderName, date: formatedDate, text: messageData.text)
        }
        formatSenderPicture(forUrl: messageData.senderProfilePicture)
    }
   
// Read Cell - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    func configureReadCell(name: String, date: String, text: String){
        senderName.attributedText = formatReadString(text: name)
        messageDate.attributedText = formatReadString(text: date)
        message.attributedText = formatReadString(text: text)
    }
    
    private func formatReadString(text: String) -> NSMutableAttributedString {
        let regularFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                           NSAttributedString.Key.foregroundColor: Colors.cellLabelColor]
        let regularString = NSMutableAttributedString(string: text, attributes: regularFont)
        return regularString
    }
    
// Unread Cell - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    private func configureUnreadCell(name: String, date: String, text: String) {
        senderName.attributedText = formatUnreadString(text: name)
        messageDate.attributedText = formatUnreadString(text: date)
        message.text = text
        
//        let regularFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
//        message.attributedText = NSMutableAttributedString(string: text, attributes: regularFont)
    }
    
    private func formatUnreadString(text: String) -> NSMutableAttributedString {
        let boldFont = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),]
        let boldString = NSMutableAttributedString(string: text, attributes:boldFont)
        return boldString
    }
// - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    private func formatSenderPicture(forUrl url: String) {
        senderProfilePicture.layer.cornerRadius = 20
        if let profilePictureURL = URL(string: url) {
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
}
