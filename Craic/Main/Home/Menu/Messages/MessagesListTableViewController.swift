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
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Messages"
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMessages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        firebase.removeListener(from: .userMessages(ofUser: userID))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchMessages() {
//        firebase.fetchWithListener(from: .userMessages(ofUser: userID), returning: Message.self) { (result) in
//            switch result {
//            case .failure(let error):
//                print(error)
//            case .success(let messagesResult):
//                self.messages = messagesResult
//                self.tableView.reloadData()
//            }
//        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! MessagesTableViewCell
        let message = messages[indexPath.row]
        cell.setUI(messageData: message)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = messages[indexPath.row]
        guard let messageType = MessageType.getType(type: cell.messageType) else { return }
        switch messageType {
        case .eventInvitation:
            firebase.getDocument(documentID: cell.eventID, documentType: Event.self, fromCollection: .event) { (result) in
                switch result{
                case .failure(_):
                    //TODO! - Message view (no event to show)
                    print()
                case .success(let event):
                    let eventVC = UIStoryboard(name: "EventProfile", bundle: nil).instantiateViewController(withIdentifier: "EventProfileViewController") as! EventProfileViewController
                    eventVC.firObj = event
                }
            }
        case .shortMessage:
            fallthrough
        case .advertising, .inform:
            let messageDetailVC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "MessageDetailViewController") as! MessageDetailViewController
            messageDetailVC.setupUI(message: cell)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let user = loggedUser else { return }
        if editingStyle == .delete {
            let messageID = messages[indexPath.row].id
            firebase.delete(documentID: messageID, in: .userMessages(ofUser: user.id)) { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                    //TODO! - ALERT: Something went wrong message
                    Alert.somethingWentWrong.call(onViewController: self)
                case .success(_):
                    self.messages.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                }
            }
        }    
    }
}
