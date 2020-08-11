//
//  MessageDetailUIViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 15/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    
    private var messages = [Message]()
    private var loggedUser: User?
    private let firebaseService = FirebaseService.shared
    private let realmService = RealmService.shared
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    override func viewDidLoad() {
        messagesTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        messagesTableView.reloadData()
    }
    
    func setupUI(thread: Thread, user: User) {
        self.loggedUser = user
        let messagesToDisplay = thread.replyList.compactMap{ $0.value }.sorted{ $0.numericDate < $1.numericDate}
        let threadTitle = messagesToDisplay[0].threadTitle
        formatThreadTitleCell(threadTitle: threadTitle)
        messagesToDisplay.forEach{ messages.append($0)}
    }
    
    func formatThreadTitleCell(threadTitle: String) {
        let emptyMessage = Message(withTitle: threadTitle)
        messages.append(emptyMessage)
    }
}

extension MessageDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let lastIndex = messages.count - 1
        let message = messages[indexPath.row]
        
        if message.id == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleTableViewCell", for: indexPath) as? titleTableViewCell
            let isAThread = message.id == message.threadID ? false : true
            cell?.formatUI(title: message.threadTitle, isAThread: isAThread)
            return cell ?? UITableViewCell()
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesDetailTableViewCell", for: indexPath) as? MessagesDetailTableViewCell
            cell?.delegate = self
            
            let isButtonEnable = indexPath.row == lastIndex ? true : false
            cell?.formatUI(forMessage: message, buttonsEnable: isButtonEnable)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cellTitle = cell as? titleTableViewCell {
            self.title = cellTitle.messageTitle
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is titleTableViewCell {
            self.title = ""
        }
    }
}

extension MessageDetailViewController: MessageDetailProtocol {
    
    func handleDeleteMessage(sender: MessagesDetailTableViewCell) {
        guard let cellMessage = sender.messageToDisplay else { return }
        deleteMessageOnRemoteDatabase(cellMessage)
    }
    
    fileprivate func deleteMessageOnRemoteDatabase(_ cellMessage: Message) {
        firebaseService.delete(documentID: cellMessage.id,
                               in: .message) { (result) in
                                switch result {
                                case .success(_):
                                    self.deleteMessageOnLocalDatabase(message: cellMessage)
                                case .failure(_):
                                    Alert.somethingWentWrong.call(onViewController: self)
                                }
        }
    }
    
    fileprivate func deleteMessageOnLocalDatabase(message: Message) {
        let localMessage = LocalMessage(messageID: message.id)
        realmService.deleteObject(ofPrimaryKey: localMessage.messageID, fromCollection: .localMessage)
        updateTableView(message)
    }
    
    fileprivate func updateTableView(_ message: Message) {
        messages = messages.filter{ $0.id != message.id}
        if messages.count == 1 {
            navigationController?.popViewController(animated: true)
        } else {
            DispatchQueue.main.async {
                self.messagesTableView.reloadData()
            }
        }
    }
    
    func handleReplyMesage(sender: MessagesDetailTableViewCell) {
        guard let messageToReply = sender.messageToDisplay else { return }
        
        let newMessage = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
        newMessage.delegate = self
        self.navigationController?.present(newMessage, animated: true)
        
        guard let user = loggedUser else { return }
        guard let receiver = User(with: (["id": messageToReply.senderID,
                                         "name": messageToReply.senderName,
                                         "profileImage": messageToReply.senderProfilePicture] as [String: AnyObject])) else { return }
        newMessage.configure(sender: user, receiver: receiver, messageToReply: messageToReply)
    }
}

//Receive message written on NewMessageViewController and added to the local and remote DB
// It needs to show it on screen and show alert
extension MessageDetailViewController: NewMessageProtocol {
    func messsageStatus(sentMessage: Message?, error: FirebaseError?) {
        if sentMessage != nil && error == nil {
            guard let sMessage = sentMessage else { return }
            Alert.messageSent.call(onViewController: self)
            self.messages.append(sMessage)
            self.messagesTableView.reloadData()
        } else {
            Alert.somethingWentWrong.call(onViewController: self)
        }
    }
}


