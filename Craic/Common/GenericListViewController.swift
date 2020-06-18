//
//  GenericListViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 16/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol FIRObjectCell where Self: UICollectionViewCell {
    //Object that wraps all inputs for UICollectionViewCells that conform to the FIRObjectCell protocol
    func formatCellUI(withData cellData: FIRCellInputObj)
}

protocol FIRObjectViewController where Self: UIViewController {
    // Used for setting data in cellForItemAt(atIndexPath)
    var firObj: FIRObjectProtocol? { get set }
}

class GenericListViewController<OBJ:FIRObjectProtocol, CELL:FIRObjectCell, VC:FIRObjectViewController>: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

// MARK: - Variables
    
    private var genericCollectionView: UICollectionView!
    let firebaseService = FirebaseService.shared
    private var resultList = [FIRObjectProtocol]()
    private let cellBorder: CGFloat = 12
    
    //input (to be set before viewDidLoad)
    private var isASortedList: Bool!
    private weak var viewForCollsTopConstraint: UIView?  // genericCollectionView's top anchor
    private var searchData: SearchData!
    private var loggedUser: User!
    private var controllerTitle: String?
    var objID: String?
    
 // MARK: - Inicialization
    
    func setData(isASortedList: Bool, viewForCollsTopConstraint: UIView?, loggedUser: User, searchType: SearchType, controllerTitle: String?, objectID: String?) {
        self.isASortedList = isASortedList
        self.viewForCollsTopConstraint = viewForCollsTopConstraint
        self.loggedUser = loggedUser
        self.searchData = searchType.getCellData()
        self.controllerTitle = controllerTitle
        self.objID = objectID
    }
    
// MARK: - View Controller Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = controllerTitle
        layoutSubviews()
        registerListCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    private func registerListCells() {
        genericCollectionView.register(UINib(nibName: searchData.cellID, bundle: .main), forCellWithReuseIdentifier: searchData.cellID)
    }
    
    private func layoutSubviews() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        genericCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        genericCollectionView.dataSource = self
        genericCollectionView.delegate = self
        genericCollectionView.backgroundColor = Colors.lightBackgroundColor
        self.view.addSubview(genericCollectionView)
    }

 // MARK: - Logic

    //Function has to be overwritten for every subclass of the GenericListViewController
    func fetchData(){

    }
    
    func formatResult<T: FIRObjectProtocol>(forList list: [T]) {
        resultList.removeAll()
        resultList = list
        DispatchQueue.main.async {
            self.genericCollectionView.reloadData()
        }
    }

    
 //MARK: - CollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isASortedList ? 2 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue cell as generic CELL(FIRObjectCell)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchData.cellID, for: indexPath) as? CELL else { return UICollectionViewCell() }

        // get obj for cell input(FIRObjectProtocol)
        guard let firObj = resultList[indexPath.row] as? OBJ else { return UICollectionViewCell() }

        // initialize FIRCellInputObj
        guard let cellData = FIRCellInputObj(withFIRObjectProtocol: firObj) else { return UICollectionViewCell() }

        //format cell
        cell.formatCellUI(withData: cellData)
        return cell
    }
    
//MARK: - CollectionView Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = genericCollectionView.frame.width - cellBorder
        return CGSize(width: width , height: searchData.cellHeight)
    }
    
//MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cellObj = resultList[indexPath.row] as? OBJ else { return }
        guard let profileVC = UIStoryboard(name: searchData.profileStoryboardName, bundle: nil).instantiateViewController(withIdentifier: searchData.viewControllerID) as? VC else { return }
        
        self.navigationController?.pushViewController(profileVC, animated: true)
        profileVC.firObj = cellObj
    }
}

//MARK: - VenueViewCellDelegate
extension GenericListViewController: VenueCollectionViewCellProtocol, FavoriteVenueProtocol {
    func handleAddAsFavorite(sender: VenueCollectionViewCell) {
        guard let venue = sender.venue else { return }
        if sender.isFavorite {
            followVenue(forVenue: venue, user: loggedUser)
        } else {
            unfollowVenue(forVenue: venue, user: loggedUser)
        }
    }
}

//MARK: - EventViewCellDelegate
extension GenericListViewController: EventCollectionViewCellProtocol, AttendEventProtocol {
    func handleAttendButton(sender: EventCollectionViewCell) {
        guard let event = sender.event else { return }
        if sender.isAttending {
            attendEvent(forEvent: event, user: loggedUser)
        } else {
            unattendedEvent(forEvent: event, user: loggedUser)
        }
    }
}

//MARK: - UserViewCellDelegate
extension GenericListViewController: UserCollectionViewCellProtocol, FollowUserProtocol {
    func handleFavoriteToggle(sender: UserCollectionViewCell) {
        guard let user = sender.user else { return }
        if sender.isFavorite {
            followUser(forFriend: user, loggedUser: loggedUser)
        } else {
            unfollowUser(forFriend: user, loggedUser: loggedUser)
        }
    }
}
