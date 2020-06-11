//
//  GenericListViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 10/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

//import UIKit
//
//enum SearchType {
//    case user
//    case venue
//    case event
//}
//
//class GenericListViewController: UIViewController {
//
//    pr
//    private var collView: UICollectionView?
//    private var searchType = SearchType.event
//    private var loggedUser: User?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collView?.register(UINib(nibName: "UserCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UserCollectionViewCell")
//        collView?.register(UINib(nibName: "EventCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EventCollectionViewCell")
//        collView?.register(UINib(nibName: "VenueCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "VenueCollectionViewCell")
//    }
//
//    func setData(user: User, coll: UICollectionView, searchType: SearchType, collectionReference: FIRCollectionsReference){
//
//    }
//}
//
////MARK: - CollectionViewDelegateFlowLayout
//extension GenericListViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        guard let gCollView = collView else { return CGSize() }
//        switch self.searchType {
//        case .event:
//            let width = gCollView.frame.width - 12
//            return CGSize(width: width , height: 120)
//        case .user:
//            let width = gCollView.frame.width - 12
//            return CGSize(width: width , height: 120)
//        case .venue:
//            let width = gCollView.frame.width - 12
//            return CGSize(width: width , height: 120)
//        }
//    }
//}
//
////MARK: - VenueViewCellDelegate
//extension GenericListViewController: VenueCollectionViewCellProtocol, FavoriteVenueProtocol {
//
//    func handleAddAsFavorite(sender: VenueCollectionViewCell) {
//        guard let venue = sender.currentVenue else { return }
//        guard let user = loggedUser else { return }
//
//        if sender.isFavorite {
//            followVenue(forVenue: venue, user: user)
//        } else {
//            unfollowVenue(forVenue: venue, user: user)
//        }
//    }
//}
//
////MARK: - EventViewCellDelegate
//extension GenericListViewController: EventCollectionViewCellProtocol, AttendEventProtocol {
//    func handleAttendButton(sender: EventCollectionViewCell) {
//        guard let event = sender.currentEvent else { return }
//        guard let user = loggedUser else { return }
//
//        if sender.isAttending {
//            attendEvent(forEvent: event, user: user)
//        } else {
//            unattendedEvent(forEvent: event, user: user)
//        }
//    }
//}
//
////MARK: - UserViewCellDelegate
//extension GenericListViewController: UserCollectionViewCellProtocol, FollowUserProtocol {
//    func handleFavoriteToggle(sender: UserCollectionViewCell) {
//
//        guard let friend = sender.friend else { return }
//        guard let userFriend = User(with: ["id": friend.friendID as AnyObject,
//                                           "name": friend.name as AnyObject,
//                                           "profileImage": friend.profilePic as AnyObject]) else { return }
//
//        guard let user = loggedUser else { return }
//
//        if sender.isFavorite {
//            followUser(forFriend: userFriend, loggedUser: user)
//        } else {
//            unfollowUser(forFriend: userFriend, loggedUser: user)
//        }
//    }
//}
