//
//  UserProfileViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    //MARK: - Variables
    private enum SearchType {
        case friends
        case events
        case favoriteVenues
    }
    
    private var currentSearchType = SearchType.events
    private let firebaseService = FirebaseService.shared
    private let coreLocationService = CoreLocationService.shared
    private var resultList = [FIRObjectProtocol]()
    private var profileImage = UIImage()
    private var loggedUser: User?
    
    //MARK: - UI Elements
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var fullNameAndAgeLabel: UILabel!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
    
    @IBAction func dismissUserProfileButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleUserLists(_ sender: UISegmentedControl) {
        guard let user = loggedUser else { return }
        if sender.selectedSegmentIndex == 0 {
            currentSearchType = .events
        } else if sender.selectedSegmentIndex == 1 {
            currentSearchType = .favoriteVenues
        } else {
            currentSearchType = .friends
        }
        fetchResultsForCurrentSearchType(user: user)
    }
    
    //MARK: - View Controler Life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userListsCollectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UserCollectionViewCell")
        userListsCollectionView.register(UINib(nibName: "EventCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EventCollectionViewCell")
        userListsCollectionView.register(UINib(nibName: "VenueCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "VenueCollectionViewCell")
        formatUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user = loggedUser else { return }
        fetchResultsForCurrentSearchType(user: user)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Logic
    
    func setData(forProfileImage profileImage: UIImage, andUser user: User) {
        self.profileImage = profileImage
        self.loggedUser = user
    }
    
    private func formatUI() {
        profilePicImageView.image = profileImage
        fullNameAndAgeLabel.text = loggedUser?.name
    }
    
    private func formatResult<T: FIRObjectProtocol>(forList list: [T]) {
        resultList.removeAll()
        resultList = list
        DispatchQueue.main.async {
            self.userListsCollectionView.reloadData()
        }
    }
 
    private func getEvents(forUserId userId: String) {
        firebaseService.fetchWithListener(from: .userEvents(ofUser: userId), returning: Event.self) { (result) in
            switch result{
            case .success(let events):
                self.formatResult(forList: events)
            case .failure(let error):
                print(error)//TODO! -  Message view (no events to show)
            }
        }
    }
    
    private func getFavoritesVenues(forUserId userId: String){
        firebaseService.fetchWithListener(from: .userFavorites(ofUser: userId), returning: Venue.self) { (result) in
            switch result{
            case .success(let venues):
                self.formatResult(forList: venues)
            case .failure(let error):
                print(error) //TODO! -  Message view (no venues to show)
            }
        }
    }
        
    private func getFriends(forUserId userId: String) {
        firebaseService.fetchDocumentsByKeyword(from: .friendship,
                                         returning: Friendship.self,
                                         keyword: userId,
                                         field: "friends") { (result) in
                                            switch result {
                                            case .failure(let error):
                                                print(error) //TODO! MESSAGE
                                            case .success(let friendships):
                                                self.formatResult(forList: friendships)
                                            }
        }
    }
    
    private func fetchResultsForCurrentSearchType(user: User ) {
        switch currentSearchType {
        case .events:
            getEvents(forUserId: user.id)
        case .favoriteVenues:
            getFavoritesVenues(forUserId: user.id)
        case .friends:
            getFriends(forUserId: user.id)
        }
    }
}

    //MARK: - CollectionViewDelegate
extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView (_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let user = loggedUser else { return UICollectionViewCell() }
        switch currentSearchType {
        case .friends:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as? UserCollectionViewCell else { return UICollectionViewCell() }
            guard let friendship = resultList[indexPath.row] as? Friendship else { return UICollectionViewCell() }
            guard let friend = Friend(friendship: friendship, userID: user.id) else { return UICollectionViewCell() }
            cell.delegate = self
            //TODO! - Realm Access
            cell.formatUI(friendData: friend, isFavorite: false)
            return cell
            
        case .events:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell else { return UICollectionViewCell() }
            guard let event = resultList[indexPath.row] as? Event else { return UICollectionViewCell() }
            
            let userDistance = coreLocationService.userDistanceToCoordinate(latitudeStr: event.latitude,
                                                                            longitudeStr: event.longitude)
            cell.delegate = self
            //TODO! - Realm Access
            cell.formatUI(event: event, isAttending: false, distance: userDistance)
            return cell
            
        case .favoriteVenues:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueCollectionViewCell", for: indexPath) as? VenueCollectionViewCell else { return UICollectionViewCell() }
            guard let venue = resultList[indexPath.row] as? Venue else { return UICollectionViewCell() }
            let isFavorite = false
            cell.delegate = self
            //TODO! - Realm Access
            cell.formatUI(venue: venue, isFavorite: isFavorite)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = loggedUser else { return }
        switch currentSearchType {
        case .friends:
            if let friendCell = collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell {
                var friendImage = Icons.userPictureNotFound
                if let friendProfileImage = friendCell.userProfilePictureImageView.image {
                    friendImage = friendProfileImage
                }
                let userProfile = UIStoryboard(name: "UserProfile", bundle: nil)
                    .instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                self.navigationController?.pushViewController(userProfile, animated: true)
                userProfile.setData(forProfileImage: friendImage, andUser: user)
            }
            
        case .events:
            if (collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell) != nil {
                
            }
            
        case .favoriteVenues:
            
            if (collectionView.cellForItem(at: indexPath) as? VenueCollectionViewCell) != nil {
                guard let venue = resultList[indexPath.row] as? Venue else { return }
                let venueProfile = UIStoryboard(name: "VenueProfile", bundle: nil)
                .instantiateViewController(withIdentifier: "VenueProfileViewController")
                    as! VenueProfileViewController
                self.navigationController?.pushViewController(venueProfile, animated: true)
                venueProfile.venue = venue
                
            }
        }
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = userListsCollectionView.frame.width - 12
        return CGSize(width: width , height: 120)
    }
}

//MARK: - VenueViewCellDelegate
extension UserProfileViewController: VenueCollectionViewCellProtocol, FavoriteVenueProtocol {
    
    func handleAddAsFavorite(sender: VenueCollectionViewCell) {
        guard let venue = sender.currentVenue else { return }
        guard let user = loggedUser else { return }
        
        if sender.isFavorite {
            followVenue(forVenue: venue, user: user)
        } else {
            unfollowVenue(forVenue: venue, user: user)
        }
    }
}

//MARK: - EventViewCellDelegate
extension UserProfileViewController: EventCollectionViewCellProtocol, AttendEventProtocol {
    func handleAttendButton(sender: EventCollectionViewCell) {
        guard let event = sender.currentEvent else { return }
        guard let user = loggedUser else { return }

        if sender.isAttending {
            attendEvent(forEvent: event, user: user)
        } else {
            unattendedEvent(forEvent: event, user: user)
        }
    }
}

//MARK: - UserViewCellDelegate
extension UserProfileViewController: UserCollectionViewCellProtocol, FollowUserProtocol {
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
