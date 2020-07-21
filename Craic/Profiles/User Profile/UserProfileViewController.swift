//
//  UserProfileViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, FIRObjectViewController {
    var firObj: FIRObjectProtocol?
    
    
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
    private let loggedUser = UserSettings().getLoggedUser()
    
    //MARK: - UI Elements
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var fullNameAndAgeLabel: UILabel!
    @IBOutlet weak var userListsCollectionView: UICollectionView!
    
    @IBAction func dismissUserProfileButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendMessageButton(_ sender: UIButton) {
        guard let sender = loggedUser else { return }
        guard let receiver = firObj as? User else { return }
        
        let newMessage = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "NewMessageViewController") as! NewMessageViewController
        
        self.navigationController?.present(newMessage, animated: true)
        newMessage.configure(sender: sender, receiver: receiver, messageType: .shortMessage)
    }
    
    @IBAction func toggleUserLists(_ sender: UISegmentedControl) {
        guard let user = firObj as? User else { return }
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
        guard let user = firObj as? User else { return }
        formatUI(forUser: user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        guard let user = firObj as? User else { return }
        fetchResultsForCurrentSearchType(user: user)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Logic
    private func formatProfilePicture(forUser user: User) {
        if let profilePictureURL = URL(string: user.profileImage) {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: profilePictureURL)  else { return }
                DispatchQueue.main.async {
                    self.profilePicImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            profilePicImageView.image = Icons.userPictureNotFound
        }
    }
    
    private func formatUI(forUser user: User) {
        fullNameAndAgeLabel.text = user.name
        formatProfilePicture(forUser: user)
    }
    
    private func formatResult<T: FIRObjectProtocol>(forList list: [T]) {
        resultList.removeAll()
        resultList = list
        DispatchQueue.main.async {
            self.userListsCollectionView.reloadData()
        }
    }
 
    private func getEvents(forUserId userId: String) {
        firebaseService.fetchWithListener(from: .userAgenda(ofUser: userId), returning: UserAgenda.self) { (result) in
            switch result{
            case .success(let userAgenda):
                let event = userAgenda.compactMap { $0.getEvent() }
                self.formatResult(forList: event)
            case .failure(let error):
                print("** ERROR **")
                print(error)//TODO! -  Message view (no events to show)
            }
        }
    }
    
    private func getFavoritesVenues(forUserId userId: String){
        firebaseService.fetchWithListener(from: .userFavorites(ofUser: userId), returning: UserFavorites.self) { (result) in
            switch result{
            case .success(let userFavorites):
                let venues = userFavorites.compactMap { $0.getFavoriteVenue() }
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
        guard let user = firObj as? User else { return UICollectionViewCell() }
        let hasPermission = user.id == loggedUser?.id ? true : false
        switch currentSearchType {
        case .friends:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as? UserCollectionViewCell else { return UICollectionViewCell() }
            guard let friendship = resultList[indexPath.row] as? Friendship else { return UICollectionViewCell() }
            guard let friend = User(friendship: friendship, userID: user.id) else { return UICollectionViewCell() }
            cell.delegate = self
            
            guard let obj = FIRCellInputObj(withFIRObjectProtocol: friend) else { return UICollectionViewCell()}
            cell.formatCellUI(withData: obj, hasPermission: hasPermission)
            return cell
            
        case .events:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell else { return UICollectionViewCell() }
            guard let event = resultList[indexPath.row] as? Event else { return UICollectionViewCell() }
            cell.delegate = self
            
            guard let obj = FIRCellInputObj(withFIRObjectProtocol: event) else { return UICollectionViewCell()}
            cell.formatCellUI(withData: obj, hasPermission: hasPermission)
            return cell
            
        case .favoriteVenues:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueCollectionViewCell", for: indexPath) as? VenueCollectionViewCell else { return UICollectionViewCell() }
            guard let venue = resultList[indexPath.row] as? Venue else { return UICollectionViewCell() }
            cell.delegate = self
            
            guard let obj = FIRCellInputObj(withFIRObjectProtocol: venue) else { return UICollectionViewCell()}
            cell.formatCellUI(withData: obj, hasPermission: hasPermission)
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch currentSearchType {
        case .friends:
            if (collectionView.cellForItem(at: indexPath) as? UserCollectionViewCell) != nil {
                guard let user = firObj as? User else { return }
                guard let friendship = resultList[indexPath.row] as? Friendship else { return }
                guard let friend = User(friendship: friendship, userID: user.id) else { return }
                let userProfile = UIStoryboard(name: "UserProfile", bundle: nil)
                    .instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                self.navigationController?.pushViewController(userProfile, animated: true)
                userProfile.firObj = friend
            }
            
        case .events:
            if (collectionView.cellForItem(at: indexPath) as? EventCollectionViewCell) != nil {
                guard let event = resultList[indexPath.row] as? Event else { return }
                let eventProfile = UIStoryboard(name: "EventProfile", bundle: nil)
                .instantiateViewController(withIdentifier: "EventProfileViewController")
                    as! EventProfileViewController
                self.navigationController?.pushViewController(eventProfile, animated: true)
                eventProfile.firObj = event
            }
            
        case .favoriteVenues:
            
            if (collectionView.cellForItem(at: indexPath) as? VenueCollectionViewCell) != nil {
                guard let venue = resultList[indexPath.row] as? Venue else { return }
                let venueProfile = UIStoryboard(name: "VenueProfile", bundle: nil)
                .instantiateViewController(withIdentifier: "VenueProfileViewController")
                    as! VenueProfileViewController
                self.navigationController?.pushViewController(venueProfile, animated: true)
                venueProfile.venueID = venue.id
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

extension UserProfileViewController: FIRCellButtonProtocol, FollowUserProtocol, AttendEventProtocol, FavoriteVenueProtocol{
    func didTapFavoriteVenueButton(sender: FIRObjectCell) {
        guard let loggedUser = firObj as? User else { return }
        guard let venueCell = sender as? VenueCollectionViewCell else { return }
        guard let venue = venueCell.venue else { return }
        if venueCell.isFavorite {
            followVenue(forVenue: venue, user: loggedUser)
        } else {
            unfollowVenue(forVenue: venue, user: loggedUser)
        }
    }
    
    func didTapFollowUserButton(sender: FIRObjectCell) {
        guard let userCell = sender as? UserCollectionViewCell else { return }
        guard let user = userCell.user else { return }
        guard let loggedUser = firObj as? User else { return }
        if userCell.isFavorite {
            followUser(forFriend: user, loggedUser: loggedUser)
        } else {
            unfollowUser(forFriend: user, loggedUser: loggedUser)
        }
    }
    
    func didTapAttendEventButton(sender: FIRObjectCell) {
        guard let eventCell = sender as? EventCollectionViewCell else { return }
        guard let event = eventCell.event else { return }
        guard let loggedUser = firObj as? User else { return }
        if eventCell.isAttending {
            attendEvent(forEvent: event, user: loggedUser)
        } else {
            unattendedEvent(forEvent: event, user: loggedUser)
        }
    }
}
