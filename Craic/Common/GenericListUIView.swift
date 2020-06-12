//
//  GenericListUIView.swift
//  Craic
//
//  Created by Denis Fortuna on 11/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

enum SearchType {
    case users
    case events
    case venues
}

protocol GenericListUIViewDelegate: class {
    func didTapGenericCell(sender: GenericListUIView)
}

class GenericListUIView: UIView {
    
//MARK: - Variables

    weak var delegate: GenericListUIViewDelegate?
    private var gLCollectionView: UICollectionView!
    private let firebaseService = FirebaseService.shared
    private let coreLocationService = CoreLocationService.shared
    
    //Input vars
    private var loggedUser: User?
    private var searchType = SearchType.users
    private var isSortingByFriends = false
    private var resultList = [FIRObjectProtocol]()
    
    //Output vars
    private var user: User?
    private var event: Event?
    private var venue: Venue?

//MARK: - Inicialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initializeSubviews(){
        let glCollView = UICollectionView()
        glCollView.frame = self.bounds
        gLCollectionView = glCollView
        self.addSubview(gLCollectionView!)
        gLCollectionView.delegate = self
        gLCollectionView.dataSource = self
    }
    
    private func registerCells() {
        gLCollectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UserCollectionViewCell")
        gLCollectionView.register(UINib(nibName: "EventCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EventCollectionViewCell")
        gLCollectionView.register(UINib(nibName: "VenueCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "VenueCollectionViewCell")
    }
    
//MARK: - Input and feching data
    func fetchData<T:FIRObjectProtocol>(firebaseCollection: FIRCollectionsReference,
                                        returningType: T.Type,
                                        fields: String?,
                                        keyword: String?,
                                        forUser user: User,
                                        searchType: SearchType,
                                        isSortingByFriends: Bool) {
        
        if let kw = keyword, let f = fields {
            firebaseService.fetchDocumentsByKeyword(from: firebaseCollection,
                                             returning: returningType,
                                             keyword: kw,
                                             field: f ) { (result) in
                                                switch result {
                                                case .failure(let error):
                                                    print(error)// TODO MESSAGE
                                                case .success(let list):
                                                    self.formatResult(forList: list)
                                                }
            }
        } else {
            firebaseService.fetchWithListener(from: firebaseCollection,
                                              returning: returningType) { (result) in
                                                switch result {
                                                case .failure(let error):
                                                    print(error)// TODO MESSAGE
                                                case .success(let list):
                                                    self.formatResult(forList: list)
                                                }
            }
        }
    }
    
    private func formatResult<T: FIRObjectProtocol>(forList list: [T]) {
        resultList.removeAll()
        resultList = list
        DispatchQueue.main.async {
            self.gLCollectionView.reloadData()
        }
    }
    
//MARK: - Output Data
    func getCellTappedResultData() -> (User?, Venue?, Event?) {
        return (user, venue, event)
    }
}

//MARK: - CollectionView Delegate
extension GenericListUIView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let tappedCell = collectionView.cellForItem(at: indexPath) else { return }
        switch tappedCell {
        case is UserCollectionViewCell:
            user = resultList[indexPath.row] as? User
            guard let userProfilePic = (tappedCell as! UserCollectionViewCell).userProfilePictureImageView.image else { return }
            
        case is VenueCollectionViewCell:
            venue = resultList[indexPath.row] as? Venue
            
        case is EventCollectionViewCell:
            event = resultList[indexPath.row] as? Event
            
        default:
            break
        }
        delegate?.didTapGenericCell(sender: self)
    }
}

//MARK: - CollectionView DataSource
extension GenericListUIView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        isSortingByFriends ? 2 : 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        resultList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let user = loggedUser else { return UICollectionViewCell() }
        switch searchType {
        case .events:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as? EventCollectionViewCell else { return UICollectionViewCell() }
            guard let event = resultList[indexPath.row] as? Event else { return UICollectionViewCell() }
            let userDistance = coreLocationService.userDistanceToCoordinate(latitudeStr: event.latitude,
                                                                            longitudeStr: event.longitude)
            cell.delegate = self
            //TODO Realm
            cell.formatUI(event: event, isAttending: false, distance: userDistance)
            return cell
            
        case .users:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as? UserCollectionViewCell else { return UICollectionViewCell() }
            guard let friendship = resultList[indexPath.row] as? Friendship else { return UICollectionViewCell() }
            guard let friend = Friend(friendship: friendship, userID: user.id) else { return UICollectionViewCell() }
            cell.delegate = self
            //TODO Realm
            cell.formatUI(friendData: friend, isFavorite: false)
            return cell
            
        case .venues:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueCollectionViewCell", for: indexPath) as? VenueCollectionViewCell else { return UICollectionViewCell() }
            guard let venue = resultList[indexPath.row] as? Venue else { return UICollectionViewCell() }
            let isFavorite = false
            cell.delegate = self
            //TODO Realm
            cell.formatUI(venue: venue, isFavorite: isFavorite)
            return cell
        }
    }
}

//MARK: - CollectionView Delegate Flow Layout
extension GenericListUIView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize {
        
//        guard let coll = gLCollectionView else { return CGSize(width: 0, height: 0) }
        let width = gLCollectionView.frame.width - 12
        return CGSize(width: width , height: 120)
    }
}

//MARK: - VenueViewCellDelegate
extension GenericListUIView: VenueCollectionViewCellProtocol, FavoriteVenueProtocol {
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
extension GenericListUIView: EventCollectionViewCellProtocol, AttendEventProtocol {
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
extension GenericListUIView: UserCollectionViewCellProtocol, FollowUserProtocol {
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
