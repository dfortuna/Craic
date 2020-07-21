//
//  MessagesListTableViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 15/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class MessagesListTableViewController: UITableViewController {
    
    var loggedUser: User?
    let firebase = FirebaseService.shared
    private let realmService = RealmService.shared
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Messages"
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userID = loggedUser?.id else { return }
        if messages.isEmpty {
            fetchMessages(forUserID: userID)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebase.removeListener(from: .message)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchMessages(forUserID userID: String) {
        firebase.queryDocuments(from: .message,
                                returning: Message.self,
                                operatorKeyValue: [(key: "receiverID", op: "==", value: userID)],
                                orderByField: "numericDate",
                                descending: true) { (result) in
                                switch result {
                                case .success(let messages):
                                    self.fornatResultmessages(resultMessages: messages)
                                case .failure(_):
                                    print()
                                }
        }
    }
    
    private func fornatResultmessages(resultMessages: [Message]) {
        DispatchQueue.main.async {
            self.messages = resultMessages
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesTableViewCell", for: indexPath) as! MessagesTableViewCell
        let message = messages[indexPath.row]
        if let _ = realmService.getDocument(PrimaryKey: message.id, fromCollection: .message) {
            cell.setUI(messageData: message, isRead: true)
        } else {
            cell.setUI(messageData: message, isRead: false)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let msgForCell = messages[indexPath.row]
        
        //when the cell is selected, check if message id is already in the db
        //if not, add it to the db
        if (realmService.getDocument(PrimaryKey: msgForCell.id, fromCollection: .message) == nil) {
            let realmMessage = ReadMessage(messageID: msgForCell.id,
                                           senderName: msgForCell.senderName,
                                           senderProfilePicture: msgForCell.senderProfilePicture)
            realmService.create(realmMessage)
            
            if let  cell = tableView.cellForRow(at: indexPath) as? MessagesTableViewCell {
                cell.configureReadCell(name: msgForCell.senderName, date: msgForCell.stringDate, text: msgForCell.text)
            }
        }

        let messageDetailVC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
        self.navigationController?.pushViewController(messageDetailVC, animated: true)
        messageDetailVC.setupUI(message: msgForCell)
    }
        
//        guard let messageType = MessageType.getType(type: cell.messageType) else { return }
//
//
//        switch messageType {
//        case .eventInvitation:
//            firebase.getDocument(documentID: cell.eventID, documentType: Event.self, fromCollection: .event) { (result) in
//                switch result{
//                case .failure(_):
//                    //TODO! - Message view (no event to show)
//                    print()
//                case .success(let event):
//                    let eventVC = UIStoryboard(name: "EventProfile", bundle: nil).instantiateViewController(withIdentifier: "EventProfileViewController") as! EventProfileViewController
//                    eventVC.firObj = event
//                }
//            }
//        case .shortMessage:
//            fallthrough
//        case .advertising, .inform:
//            let messageDetailVC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
//            messageDetailVC.setupUI(message: cell)
//        }
//    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard let user = loggedUser else { return }
//        if editingStyle == .delete {
//            let messageID = messages[indexPath.row].id
//            firebase.delete(documentID: messageID, in: .userMessages(ofUser: user.id)) { (result) in
//                switch result {
//                case .failure(let error):
//                    print(error)
//                    //TODO! - ALERT: Something went wrong message
//                    Alert.somethingWentWrong.call(onViewController: self)
//                case .success(_):
//                    self.messages.remove(at: indexPath.row)
//                    tableView.deleteRows(at: [indexPath], with: .fade)
//                    tableView.endUpdates()
//                }
//            }
//        }    
//    }
}
