//
//  InvitationMessageTableViewCell.swift
//  Craic
//
//  Created by Denis Fortuna on 15/8/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class InvitationMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderProfilePicture: UIImageView!
    @IBOutlet weak var invitationMessageLabel: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    
    func setUI(thread: Thread){
        guard let message = thread.replyList.compactMap({$0.value}).first else { return }
        
        formatSenderPicture(forUrl: message.senderProfilePicture)
        guard let date = message.stringDate.convertToddMMMDateformat() else { return }
        
        if thread.numberOfUnreadMessages > 0 {
            invitationMessageLabel.attributedText = getUnreadMessageAccordingToInvitationType(forMessage: message)
            messageDate.text = date
        } else {
            invitationMessageLabel.attributedText = formatReadMessage(forText: message.text)
            messageDate.attributedText = formatReadMessage(forText: date)
        }
        invitationMessageLabel.dynamicHeight()
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
    
    private func formatUnreadEventInvitation(forMessage message: Message,
                                             andAttribute attribute: [NSAttributedString.Key: Any]) -> NSMutableAttributedString? {
        
        //find words that will be bold and their length
        let senderLength = message.senderName.count
        
        guard let eventHost = message.eventHost else { return nil }
        let hostLength = eventHost.count
        
        guard let eventName = message.eventName else { return nil }
        
        //set mutable attributed invitation string with no attributes
        let invitationText = NSMutableAttributedString(string: "\(message.senderName) invited you to \(eventHost)'s event \(eventName)")
        
        //NSRange will be the positions that wont receive the boldFontAttribute
        //" invited you to " = 16 positions
        //"'s event " = 9 positions

        invitationText.addAttributes(attribute, range: NSRange(location: senderLength,
                                                                       length: 16 + hostLength))
        invitationText.addAttributes(attribute, range: NSRange(location: senderLength + 16 + hostLength,
                                                                       length: 9))
        return invitationText
    }
    
    
    private func formatUnreadVenueInvitation(forMessage message: Message,
                                             andAttribute attribute: [NSAttributedString.Key: Any]) -> NSMutableAttributedString? {
        
        //find words that will be bold and their length
        let senderLength = message.senderName.count
        guard let venueName = message.venueName else { return nil }
        
        //set mutable attributed invitation string with no attributes
        let invitationText = NSMutableAttributedString(string: "\(message.senderName) invited you to like \(venueName)")
        
        //NSRange will be the positions that wont receive the boldFontAttribute
        //" invited you to like " = 21 positions

        invitationText.addAttributes(attribute, range: NSRange(location: senderLength,
                                                                       length: 21))
        return invitationText
    }
    
    
    private func getUnreadMessageAccordingToInvitationType(forMessage message: Message) -> (NSMutableAttributedString?){
        
        //set bold font attribute
        let boldFontAttribute: [NSAttributedString.Key: Any] =
            [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        
        switch message.messageType {
        case MessageType.eventInvitation.rawValue:
            return formatUnreadEventInvitation(forMessage: message, andAttribute: boldFontAttribute)
        case MessageType.venueInvitation.rawValue:
            return formatUnreadVenueInvitation(forMessage: message, andAttribute: boldFontAttribute)
        default:
            return nil
        }
    }
    
    
    private func formatReadMessage(forText text: String) -> NSMutableAttributedString {
        let regularFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                           NSAttributedString.Key.foregroundColor: Colors.cellLabelColor]
        let regularString = NSMutableAttributedString(string: text, attributes: regularFont)
        return regularString
    }
}
