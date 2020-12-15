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
    private let firebase = FirebaseService.shared
    private let realmService = RealmService.shared
    private var threadss = [Thread]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Messages"
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userID = loggedUser?.id else { return }
        threadss.removeAll()
        fetchMessages(forUserID: userID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebase.removeListener(from: .message)
    }
    
    func fetchMessages(forUserID userID: String) {
        firebase.fetchDocumentsByKeyword(from: .message,
                                         returning: Message.self,
                                         keyword: userID,
                                         field: "messageBetweenUsers") { (result) in
                                        //TODO! = add sort by threadID
                                            switch result {
                                            case .success(let messages):
                                                self.groupThreads(messages: messages, userID: userID)
                                            case .failure(_):
                                                print("deu rum em achar as msgs")
                                            }
        }
    }
    
    private func groupThreads(messages: [Message], userID: String) {
        
        if !messages.isEmpty {
            
            //filter out invitation messages sent by user
            let filteredMessages = messages.filter{
                ($0.messageType == MessageType.chatMessage.rawValue) ||
                ($0.messageType != MessageType.chatMessage.rawValue && $0.receiverID == userID)
            }
            
            //sort messages by threadID
            let sortedMessages = filteredMessages.sorted { $0.threadID < $1.threadID }
            
            var threadMessagesSequence = [Int: Message]()
        
            //for the first check, currentThreadID and m.threadID must be the same
            guard let lastMessageThreadID = sortedMessages.first?.threadID else { return }
            var currentThreadID = lastMessageThreadID
            
            for m in sortedMessages {
                
                if m.threadID == currentThreadID {
                    //if its still the same thread, add message and corresponding sequence
                    threadMessagesSequence[m.messageNumber] = m
                } else {
                    formatThreads(sequence: threadMessagesSequence, currentThreadID: currentThreadID)
                    threadMessagesSequence = [Int: Message]()
                    threadMessagesSequence[m.messageNumber] = m
                }
                currentThreadID = m.threadID
            }
            formatThreads(sequence: threadMessagesSequence, currentThreadID: currentThreadID)
        }
        displayResults()
    }
    
    private func formatThreads(sequence: [Int: Message], currentThreadID: String) {
        // when new threadID, format thread:
        // get all messages of this thread and sequence
        let threadMessages = sequence.compactMap{ $0.value }
        
        // count how many unread messages for threadCell label
        var count = 0
        for tmessage in threadMessages {
            if (realmService.getDocument(PrimaryKey: tmessage.id, fromCollection: .dBMessage) == nil){
                count += 1
            }
        }
        
        // find date of last message to be used for sorting
        let lastMessage = threadMessages.max{ $0.messageNumber > $1.messageNumber}
        
        guard let lmessage = lastMessage else { return }
        let thread = Thread(id: currentThreadID,
                            replyList: sequence,
                            numericDateLastMessage: lmessage.numericDate,
                            stringDateLastMessage: lmessage.stringDate,
                            numberOfUnreadMessages: count)
        threadss.append(thread)
    }
    
    private func displayResults() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threadss.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let user = loggedUser else { return UITableViewCell() }
        let thread = threadss[indexPath.row]
        
        //all messages on a thread must have the same messageType
        guard let firstMessage = thread.replyList[0] else { return UITableViewCell() }
        guard let mType = MessageType.getType(type: firstMessage.messageType) else { return UITableViewCell() }
        
        switch mType {
        case .chatMessage:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageTableViewCell", for: indexPath) as! ChatMessageTableViewCell
            cell.setUI(thread: thread, user: user)
            return cell
        case .eventInvitation, .venueInvitation:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationMessageTableViewCell", for: indexPath) as! InvitationMessageTableViewCell
            cell.setUI(thread: thread)
            return cell
        case .friendshipRequest :
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestMessageTableViewCell", for: indexPath) as! FriendRequestMessageTableViewCell
            cell.formatUI(forMessage: firstMessage)
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let thread = threadss[indexPath.row]
        addReadMessagesToLocalDB(forThread: thread)
        
        //get the first message of the thread to validade its type. the whole thread will have the same type
        guard let firstMessage = thread.replyList.values.first else { return }
        let threadTypeString = firstMessage.messageType
        guard let threadType = MessageType.getType(type: threadTypeString) else { return }
        
        switch threadType {
        case .eventInvitation:
            //eventImvitation messages cant be replied, so thread has only 1 message and it should come with a
            //valid EventID
            guard let eventID = firstMessage.eventID else { return }
            
            //present EventViewController
            let eventProfile = UIStoryboard(name: "EventProfile", bundle: nil)
            .instantiateViewController(withIdentifier: "EventProfileViewController")
                as! EventProfileViewController
            self.navigationController?.pushViewController(eventProfile, animated: true)
            eventProfile.eventId = eventID
            
        case .venueInvitation:
            //same for .venueInvitation
            guard let venueID = firstMessage.venueID else { return }
            
            //present VenueViewController
            let venueProfile = UIStoryboard(name: "VenueProfile", bundle: nil)
            .instantiateViewController(withIdentifier: "VenueProfileViewController")
                as! VenueProfileViewController
            self.navigationController?.pushViewController(venueProfile, animated: true)
            venueProfile.venueID = venueID
            
        case .chatMessage:
            //present MessageDetailViewController
            let messageDetail = UIStoryboard(name: "Messages", bundle: nil)
            .instantiateViewController(withIdentifier: "MessageDetailViewController")
                as! MessageDetailViewController
            self.navigationController?.pushViewController(messageDetail, animated: true)
            guard let user = loggedUser else { return }
            messageDetail.setupUI(thread: thread, user: user)
            
        case .friendshipRequest:
            //present MessageDetailViewController
            let messageDetail = UIStoryboard(name: "UserProfile", bundle: nil)
            .instantiateViewController(withIdentifier: "MessageDetailViewController")
                as! MessageDetailViewController
            self.navigationController?.pushViewController(messageDetail, animated: true)
            guard let user = loggedUser else { return }
            messageDetail.setupUI(thread: thread, user: user)
            
        }
    
    }
    
    private func addReadMessagesToLocalDB(forThread thread: Thread) {
        let messages = thread.replyList.compactMap{ $0.value }
        for message in messages {
            let sentMessage = DBMessage(messageID: message.id)
            realmService.create(sentMessage)
        }
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            //find the thread to be deleted
            let threadToDelete = threadss[indexPath.row]
            //get the messages from the thread
            let threadMessages = threadToDelete.replyList.compactMap{ $0.value }
            
            firebase.batchDelete(forDocuments: threadMessages,
                                 reference: .message) { (result) in
                                    switch result {
                                    case .success(_):
                                        self.deleteLocalMessages(messages: threadMessages)
                                        //remove thread from array
                                        self.threadss.remove(at: indexPath.row)
                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                        tableView.endUpdates()

                                    case .failure(_):
                                        Alert.somethingWentWrong.call(onViewController: self)
                                    }
            }
        }
    }
    
    private func deleteLocalMessages(messages: [Message]) {
        //Delete every message from local Datatabase
        for message in messages {
            let localMessage = DBMessage(messageID: message.id)
            realmService.delete(localMessage)
        }
    }
}
