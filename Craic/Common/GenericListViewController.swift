//
//  GenericListViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 16/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit


protocol FIRCellButtonProtocol: class {
    func didTapFavoriteVenueButton(sender: FIRObjectCell)
    func didTapFollowUserButton(sender: FIRObjectCell)
    func didTapAttendEventButton(sender:FIRObjectCell)
    func handleAcceptButton(sender: FIRObjectCell)
    func handleDeclineButton(sender: FIRObjectCell)
}

protocol FIRObjectCell where Self: UICollectionViewCell {
    //Object that wraps all inputs for UICollectionViewCells that conform to the FIRObjectCell protocol
    func formatCellUI(withData cellData: FIRCellInputObj, hasPermission: Bool)
    var delegate: FIRCellButtonProtocol? { get set }
}

protocol FIRObjectViewController where Self: UIViewController {
    // Used for setting data in cellForItemAt(atIndexPath)
    var firObj: FIRObjectProtocol? { get set }
}

class GenericListViewController<OBJ:FIRObjectProtocol, CELL:FIRObjectCell, VC:FIRObjectViewController>: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

// MARK: - Variables
    
    var genericCollectionView: UICollectionView!
    private var indicator: UIActivityIndicatorView!
    private var woopsView: UIView!
    let firebaseService = FirebaseService.shared
    private var resultList = [FIRObjectProtocol]()
    private let cellBorder: CGFloat = 12
    private var messageView = NotFoundMessageUIView()
    
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
        
        configureMessageView()
        indicator = UIActivityIndicatorView(style: .gray)
        self.view.addSubview(indicator)
        configureCollectionView()
        registerListCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.startAnimating()
        fetchData()
    }
    
    
// MARK: - Formating Views
    fileprivate func configureMessageView() {
        self.view.addSubview(messageView)
        messageView.anchorEdges(top: self.view.topAnchor,
                                left: self.view.leftAnchor,
                                right: self.view.rightAnchor,
                                bottom: self.view.bottomAnchor, padding: .zero)
        messageView.alpha = 0
    }
    
    func registerListCells() {
        genericCollectionView.register(UINib(nibName: searchData.cellID, bundle: .main), forCellWithReuseIdentifier: searchData.cellID)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        genericCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        genericCollectionView.dataSource = self
        genericCollectionView.delegate = self
        genericCollectionView.backgroundColor = Colors.lightBackgroundColor
        self.view.addSubview(genericCollectionView)
        genericCollectionView.anchorEdges(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, bottom: self.view.bottomAnchor, padding: .zero)
    }

 // MARK: - Logic

    //Function has to be overwritten for every subclass of the GenericListViewController
    func fetchData(){

    }
    
    func formatResult<T: FIRObjectProtocol>(forList list: [T]) {
        resultList.removeAll()
        resultList = list
        indicator.stopAnimating()
        DispatchQueue.main.async {
            if self.resultList.count > 0 {
                self.messageView.alpha = 0
                self.genericCollectionView.reloadData()
            } else {
                self.messageView.alpha = 1
                self.messageView.superview?.bringSubviewToFront(self.messageView)
            }
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
        cell.delegate = self
        
        // get obj for cell input(FIRObjectProtocol)
        guard let firObj = resultList[indexPath.row] as? OBJ else { return UICollectionViewCell() }
        
        // initialize FIRCellInputObj
        guard let cellData = FIRCellInputObj(withFIRObjectProtocol: firObj) else { return UICollectionViewCell() }

        //format cell
        cell.formatCellUI(withData: cellData, hasPermission: true)
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

extension GenericListViewController: FIRCellButtonProtocol, FollowUserProtocol, AttendEventProtocol, FavoriteVenueProtocol{
    func handleAcceptButton(sender: FIRObjectCell) {
        
    }
    
    func handleDeclineButton(sender: FIRObjectCell) {
        
    }
    
    func didTapFavoriteVenueButton(sender: FIRObjectCell) {
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
        if userCell.isFavorite {
            followUser(forFriend: user, loggedUser: loggedUser)
        } else {
            unfollowUser(forFriend: user, loggedUser: loggedUser)
        }
    }
    
    func didTapAttendEventButton(sender: FIRObjectCell) {
        guard let eventCell = sender as? EventCollectionViewCell else { return }
        guard let event = eventCell.event else { return }
        if eventCell.isAttending {
            attendEvent(forEvent: event, user: loggedUser)
        } else {
            unattendedEvent(forEvent: event, user: loggedUser)
        }
    }
}
