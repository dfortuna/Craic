//
//  FriendsViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 29/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    var firebase = FirebaseService.shared
    var friends = [Friend]()
    var loggedUser: User?
    
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friends"
        friendsCollectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UserCollectionViewCell")
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userID = loggedUser?.id else { return }
        getFriendsList(userId: userID)
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firebase.removeListener(from: FIRCollectionsReference.user)
        friends.removeAll()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        print("******um teste maroto 222")
        return .lightContent
    }
    
    func getFriendsList(userId: String) {
        
        firebase.fetchDocumentsByKeyword(from: .friendship,
                                         returning: Friendship.self,
                                         keyword: userId,
                                         field: "friends") { (result) in
                                            switch result {
                                            case .failure(let error):
                                                //TODO - "no friends yet" image
                                                print(error)
                                            case .success(let friendships):
                                                self.formatFriends(from: friendships, userID: userId)
                                            }
        }
    }

    func formatFriends(from friendships: [Friendship], userID: String){
        for friendship in friendships {
            if let friend = Friend(friendship: friendship, userID: userID) {
                friends.append(friend)
            }
        }
        formatList()
    }
    
    fileprivate func formatList() {
        DispatchQueue.main.async {
            self.friendsCollectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.alpha = 0 
        }
    }
}

extension FriendsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as? UserCollectionViewCell
        let height = cell?.userProfilePictureImageView.bounds.height
        let width = cell?.userProfilePictureImageView.bounds.width
        cell?.delegate = self
        let friend = friends[indexPath.row]
        cell?.formatUI(friendData: friend, isFavorite: false) //TODO
         return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let friendCell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
            let friend = friends[indexPath.row]
            guard let user = User(with: ["id": friend.friendID as AnyObject,
                                         "name": friend.name as AnyObject,
                                         "profileImage": friend.profilePic as AnyObject]) else { return }
            
            var friendImage = Icons.userPictureNotFound
            if let friendProfileImage = friendCell.userProfilePictureImageView.image {
                friendImage = friendProfileImage
            }
            let userProfile = UIStoryboard(name: "UserProfile", bundle: nil)
                .instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController

            self.navigationController?.pushViewController(userProfile, animated: true)
            
            userProfile.setData(forProfileImage: friendImage, andUser: user)
        }
    }
}

extension FriendsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = friendsCollectionView.frame.width - 12
        print("%%%%% Freinds cell width", width )
        return CGSize(width: width , height: 120)
    }
}


extension FriendsViewController: UserCollectionViewCellProtocol, FollowUserProtocol {
    func handleFavoriteToggle(sender: UserCollectionViewCell) {
        
        guard let friend = sender.friend else { return }
        guard let userFriend = User(with: ["id": friend.friendID as AnyObject,
                                           "name": friend.name as AnyObject,
                                           "profileImage": friend.profilePic as AnyObject]) else { return }
        
        guard let user = loggedUser else { return }

        if sender.isFavorite {
            followUser(forFriend: userFriend, loggedUser: user)
        } else {
            unfollowUser(forFriend: userFriend, loggedUser: user)
        }
    }
}
