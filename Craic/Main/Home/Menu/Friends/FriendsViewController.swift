//
//  FriendsViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 29/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    

    var testData = TestData.shared
    
    var firebase = FirebaseService.shared
    var friends = [User]()
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
        return .lightContent
    }
    
    func getFriendsList(userId: String) {
        
        firebase.fetchDocumentsByKeyword(from: .friendship,
                                         returning: Friendship.self,
                                         keyword: userId,
                                         field: "friends") { (result) in
                                            switch result {
                                            case .failure(let error):
                                                //TODO! -  Message view (no friends to show)
                                                print(error)
                                            case .success(let friendships):
                                                self.formatFriends(from: friendships, userID: userId)
                                            }
        }
    }

    func formatFriends(from friendships: [Friendship], userID: String){
        for friendship in friendships {
            if let friend = User(friendship: friendship, userID: userID) {
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
        cell?.delegate = self
        let friend = friends[indexPath.row]
        
        guard let obj = FIRCellInputObj(withFIRObjectProtocol: friend) else { return UICollectionViewCell()}
        cell?.formatCellUI(withData: obj)
         return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let friendCell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
            let friend = friends[indexPath.row]
            var friendImage = Icons.userPictureNotFound
            if let friendProfileImage = friendCell.userProfilePictureImageView.image {
                friendImage = friendProfileImage
            }
            let userProfile = UIStoryboard(name: "UserProfile", bundle: nil)
                .instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
            self.navigationController?.pushViewController(userProfile, animated: true)
            userProfile.firObj = friend
        }
    }
}

extension FriendsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = friendsCollectionView.frame.width - 12
        return CGSize(width: width , height: 120)
    }
}

extension FriendsViewController: FIRCellButtonProtocol, FollowUserProtocol{
    
    func didTapFavoriteVenueButton(sender: FIRObjectCell) {}
    
    func didTapAttendEventButton(sender: FIRObjectCell) {}
    
    func didTapFollowUserButton(sender: FIRObjectCell) {
        guard let userCell = sender as? UserCollectionViewCell else { return }
        guard let user = userCell.user else { return }
        guard let loggedUser = loggedUser else { return }
        if userCell.isFavorite {
            followUser(forFriend: user, loggedUser: loggedUser)
        } else {
            unfollowUser(forFriend: user, loggedUser: loggedUser)
        }
    }
}
