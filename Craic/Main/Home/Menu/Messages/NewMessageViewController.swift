//
//  NewMessageViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 17/7/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

class NewMessageViewController: UIViewController {
    
    private var receiver: User?
    private var sender: User?
    private var messageType = String()
    private let firebaseService = FirebaseService.shared
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!

    @IBAction func sendButton(_ sender: Any) {
        guard let message = formatMessage() else { return }
        sendMessage(message: message)
    }
      
    override func viewDidLoad() {
        messageTextView.delegate = self
        toTextField.isUserInteractionEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let receiver = receiver else { return }
        formatUI(receiver)
    }
    
    fileprivate func formatUI(_ receiver: User) {
        containerView.layer.cornerRadius = 15
        toTextField.text = "To: \(receiver.name)"
        messageTextView.text = "Message..."
        messageTextView.textColor = .lightGray
    }
    
    func configure(sender: User, receiver: User, messageType: MessageType) {
        self.sender = sender
        self.receiver = receiver
        self.messageType = messageType.rawValue
    }
    
    private func formatMessage() -> Message? {
        guard let sender = sender else { return nil }
        guard let receiver = receiver else { return nil }
        
        guard let _ = toTextField.text,
            !messageTextView.text.isEmpty else { return nil }
        
        if !messageTextView.text.isEmpty {
            let messageID = UUID().uuidString
            let message = Message(with:
                ["id": messageID,
                 "senderID": sender.id,
                 "senderName": sender.name,
                 "senderProfilePicture": sender.profileImage,
                 "receiverID": receiver.id,
                 "receiverName": receiver.name,
                 "receiverProfilePicture": receiver.profileImage,
                 "text": messageTextView.text,
                 "numericDate": Date().getNumericDate(),
                 "stringDate": Date().getStringDate(),
                 "replyingMessageID": nil,
                 "messageNumber": 0,
                 "messageType": messageType ] as [String: AnyObject])
            return message
        } else {
          //TODO!
            return nil
        }
    }
    
    private func sendMessage(message: Message) {
        if !messageTextView.text.isEmpty && !toTextField.text!.isEmpty {
            firebaseService.create(for: message,
                                   in: .message) { (result) in
                                    switch result {
                                    case .success(_):
                                        DispatchQueue.main.async {
                                            Alert.messageSent.call(onViewController: self)
                                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                                        }
                                    case .failure(_):
                                        Alert.somethingWentWrong.call(onViewController: self)
                                    }
            }
        }
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
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        print("terminou")
//        let bottom = NSMakeRange
//        messageTextView.scrollRangeToVisible(<#T##range: NSRange##NSRange#>)
    }
    
    
}
