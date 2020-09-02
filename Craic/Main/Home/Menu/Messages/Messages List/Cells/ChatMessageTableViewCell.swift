//
//  ChatMessageTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 6/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderProfilePicture: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var unreadMessagesLabel: UILabel!
    
    private var isRead = false
    private var thread: Thread?
    private var loggedUser: User?
    
    func setUI(thread: Thread, user: User){
        self.thread = thread
        self.loggedUser = user
        
        //find last received message in the thread
        let receivedMessages = thread.replyList.compactMap{$0.value}
        let lastRMessage = receivedMessages.max { $0.messageNumber > $1.messageNumber }
        
        guard let sName = lastRMessage?.senderName,
            let pPicture = lastRMessage?.senderProfilePicture,
            let mText = lastRMessage?.text else { return }
        
        let cellMessage = formatCellMessage(forThread: thread, andLoggedUser: user)
        formatSenderPicture(forUrl: pPicture)
        let formatedDate = thread.stringDateLastMessage.convertToddMMMDateformat() ?? ""
        
        if thread.numberOfUnreadMessages > 0 {
            //configure unReadThread
            unreadMessagesLabel.layer.cornerRadius = 13
            unreadMessagesLabel.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            unreadMessagesLabel.layer.masksToBounds = true
            unreadMessagesLabel.textColor = .white
            unreadMessagesLabel.text =  String(thread.numberOfUnreadMessages)
            
            configureUnreadCell(name: sName, date: formatedDate, text: cellMessage)
        } else {
            //configure read cell
            unreadMessagesLabel.alpha = 0
            configureReadCell(name: sName, date: formatedDate, text: cellMessage)
        }
        message.dynamicHeight()
    }
   
// Read Cell - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    private func configureReadCell(name: String, date: String, text: String){
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
    }
    
    private func formatUnreadString(text: String) -> NSMutableAttributedString {
        let boldFont = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17),]
        let boldString = NSMutableAttributedString(string: text, attributes:boldFont)
        return boldString
    }
// - - - - - -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    private func formatCellMessage(forThread thread: Thread, andLoggedUser user: User) -> String {
        
        let lastIndex = thread.replyList.compactMap{ $0.key }.max()
        guard let lIndex = lastIndex,
              let lastMessage = thread.replyList[lIndex] else { return String()}
        
        let cellMessage = lastMessage.senderID == user.id ? "You: \(lastMessage.text)" : lastMessage.text
        return cellMessage
    }
    
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
