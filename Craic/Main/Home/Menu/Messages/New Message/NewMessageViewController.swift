//
//  NewMessageViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 17/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

protocol NewMessageProtocol: class {
    func messsageStatus(sentMessage: Message?, error: FirebaseError?)
}

class NewMessageViewController: UIViewController {
    
    //compulsory fields to be injected
    private var receivingUser: User?
    private var loggedUser: User?
    private var messageToReply: Message?
    
    //fields to receive different data whether it's a new message or a reply
    private var messageID = String()    // always UUID, but same id as threadID if its a reply
    private var threadTitle = String() // the message subject (or the threadSubject if this message is a reply)
    private var threadID = String()     // threadID is the messageID of the first message
    private var messageNumber = 0       // numer of the reply
    private var replyingMessageID: String?
    private var usersChatting = [String]()
    
    private let firebaseService = FirebaseService.shared
    private let realmService = RealmService.shared
    weak var delegate: NewMessageProtocol?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var messageSubject: UITextField!
    
    @IBAction func sendButton(_ sender: Any) {
        guard let message = formatMessage() else { return }
        if !messageTextView.text.isEmpty && !toTextField.text!.isEmpty {
            writeMessageToDB(message: message)
            sendMessage(message: message)
        }
    }
      
    override func viewDidLoad() {
        messageTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let receiver = receivingUser else { return }
        formatUI(receiver)
    }
    
    fileprivate func formatUI(_ receiver: User) {
        containerView.layer.cornerRadius = 15
        
        toTextField.text = "To: \(receiver.name)"
        toTextField.isUserInteractionEnabled = false
        
        messageTextView.text = "Message..."
        messageTextView.textColor = .lightGray
        
        if let mr = messageToReply {
            //Reply message
            messageSubject.text = mr.threadTitle
            messageSubject.isUserInteractionEnabled = false
        }
    }
    
    func configure(sender: User, receiver: User, messageToReply: Message?) {
        self.loggedUser = sender
        self.receivingUser = receiver
        self.messageToReply = messageToReply
        self.messageID = UUID().uuidString
        
        //if new message, messageToReply will be nil
        if let mr = messageToReply {
            //Reply message
            
            threadTitle = "Re: \(mr.threadTitle)"
            threadID = mr.threadID
            messageNumber =  mr.messageNumber + 1
            replyingMessageID = mr.id
            usersChatting = mr.messageBetweenUsers
        } else {
            //New message
            
            //threadTitle = from Subject Textfield..
            threadID = messageID
            messageNumber = 0
            replyingMessageID = nil
            usersChatting = [sender.id, receiver.id]
        }
    }
    
    private func formatMessage() -> Message? {
        guard let user = loggedUser else { return nil }
        guard let receiver = receivingUser else { return nil }
        
        guard let _ = toTextField.text,
            !messageTextView.text.isEmpty else { return nil }
            
        if let s = messageSubject.text, !s.isEmpty {
            threadTitle = s
        } else {
            threadTitle = "(no subject)"
        }
         
        if !messageTextView.text.isEmpty {
            let message = Message(with:
                ["id": messageID,
                 "messageBetweenUsers": usersChatting,
                 
                 "senderID": user.id,
                 "senderName": user.name,
                 "senderProfilePicture": user.profileImage,
                 
                 "receiverID": receiver.id,
                 "receiverName": receiver.name,
                 "receiverProfilePicture": receiver.profileImage,
                 
                 "text": messageTextView.text as Any,
                 "threadTitle": threadTitle,
                 "numericDate": Date().getNumericDate() as Any,
                 "stringDate": Date().getStringDate(),
                 "threadID": threadID,
                 "messageNumber": messageNumber,
                 "messageType": MessageType.chatMessage.rawValue ] as [String: AnyObject])
            return message
        } else {
          //TODO!
            return nil
        }
    }
    
    private func sendMessage(message: Message) {
        firebaseService.create(for: message,
                               in: .message) { (result) in
                                switch result {
                                case .success(_):
                                    self.handleResult(sentMessage: message, error: nil)
                                case .failure(let error):
                                    self.handleResult(sentMessage: nil, error: error)
                                }
        }
    }
    
    private func handleResult(sentMessage: Message?, error: FirebaseError?) {
        DispatchQueue.main.async {
            self.delegate?.messsageStatus(sentMessage: sentMessage, error: error)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //save message written to local database
    private func writeMessageToDB(message: Message) {
//        guard let numericDate = Date().getNumericDate() else { return }
//        let stringDate = Date().getStringDate()
        let replyingMessage = LocalMessage(messageID: messageID)
        realmService.create(replyingMessage)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension NewMessageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        messageTextView.text = ""
        messageTextView.textColor = .black
    }
}
