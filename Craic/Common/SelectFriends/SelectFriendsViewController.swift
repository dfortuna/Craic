//
//  SelectFriendsViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 11/8/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class SelectFriendsViewController: UIViewController {
    
    private var loggedUser: User?
    private var friends = [User]()
    private var eventToInvite: Event?
    private var venueToInvite: Venue?
    private var selectedFriends = [User]()
    private var firebaseService = FirebaseService.shared
    
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var inviteButtonOutlet: UIButton!
    
    @IBAction func inviteButtom(_ sender: UIButton) {
        let type = eventToInvite != nil ? MessageType.eventInvitation : MessageType.venueInvitation
        
        for sfriend in selectedFriends {
            guard let invitationMessage = formatMessage(forReceiver: sfriend, andMessageType: type) else { return }
            sendInvitation(message: invitationMessage)
        }
    }
    
    
    private func formatMessage(forReceiver receiver: User, andMessageType messageType: MessageType) -> Message? {
        
        guard let sender = loggedUser else { return nil }
        
        let messageID = UUID().uuidString
        let usersChatting = [sender.id, receiver.id]
        var invitationText = ""
        
        switch messageType {
        case .eventInvitation:
            guard let event = eventToInvite else { break }
            invitationText = "\(sender.name) invited you to \(event.hostName)'s event \(event.name)"
        case .venueInvitation:
            guard let venue = venueToInvite else { break }
            invitationText = "\(sender.name) invited you to like \(venue.name)"
        default:
            break
        }
        
        var message = Message(with:
            ["id": messageID,
             "messageBetweenUsers": usersChatting,
             "senderID": sender.id,
             "senderName": sender.name,
             "senderProfilePicture": sender.profileImage,
             "receiverID": receiver.id,
             "receiverName": receiver.name,
             "receiverProfilePicture": receiver.profileImage,
             "text": invitationText,
             "threadTitle": "",
             "numericDate": Date().getNumericDate() as Any,
             "stringDate": Date().getStringDate(),
             "threadID": messageID,
             "messageNumber": 0,
             "messageType": messageType.rawValue] as [String: AnyObject])
        message?.eventID = eventToInvite?.id
        message?.eventName = eventToInvite?.name
        message?.eventHost = eventToInvite?.hostName
        message?.venueID = venueToInvite?.id
        message?.venueName = venueToInvite?.name
        
        return message
    }
    
    private func sendInvitation(message: Message){
        firebaseService.create(for: message,
                               in: .message) { (result) in
                                self.handleResult(result: result)
        }
    }
    
    private func handleResult(result: Result<String, FirebaseError>) {
        DispatchQueue.main.async {
            switch result {
            case .success(_):
                Alert.messageSent.call(onViewController: self)
            case .failure(_):
                Alert.somethingWentWrong.call(onViewController: self)
            }
            self.selectedFriends.removeAll()
            self.friendsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Invite Friends" 
        friendsTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        inviteButtonOutlet.layer.borderWidth = 3
        inviteButtonOutlet.layer.cornerRadius = 15
        inviteButtonOutlet.layer.borderColor = Colors.mainColor?.cgColor
        fetchFriends()
    }
    
    func formatUI(forUser user: User, andVenue venue: Venue?, orEvent event: Event?) {
        loggedUser = user
        eventToInvite = event
        venueToInvite = venue
    }
    
    private func fetchFriends() {
        guard let user = loggedUser else { return }
        firebaseService.fetchDocumentsByKeyword(from: .friendship,
                                                returning: Friendship.self,
                                                keyword: user.id,
                                                field: "friends") { (result) in
                                                switch result {
                                                case .failure(let error):
                                                    //TODO! -  Message view (no friends to show)
                                                    print(error)
                                                case .success(let friendships):
                                                    self.formatFriends(from: friendships, userID: user.id)
                                                }
        }
    }
    
    private func formatFriends(from friendships: [Friendship], userID: String){
        for friendship in friendships {
            if let friend = User(friendship: friendship, userID: userID) {
                friends.append(friend)
            }
        }
        formatList()
    }
    
    fileprivate func formatList() {
        DispatchQueue.main.async {
            self.friendsTableView.reloadData()
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.alpha = 0
        }
    }
}

extension SelectFriendsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sFriend = friends[indexPath.row]
        
        if (selectedFriends.filter{ $0.id == sFriend.id }.isEmpty) {
            //if friend selected is not in the selectedFriends array, add it
            selectedFriends.append(sFriend)
        } else {
            //if friend selected is already in the selectedFriends array, remove it
            selectedFriends = selectedFriends.filter{ $0.id != sFriend.id }
        }
        friendsTableView.reloadData()
    }
}

extension SelectFriendsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let friend = friends[indexPath.row]
        
        //check if friend is already been selected
        let isSelected = !selectedFriends.filter{ $0.id == friend.id }.isEmpty
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectFriendsTableViewCell", for: indexPath) as! SelectFriendsTableViewCell
        cell.formatUI(user: friend, isSelected: isSelected)
        return cell
    }
}
