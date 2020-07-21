//
//  VenueProfileViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class VenueProfileViewController: UIViewController, FIRObjectViewController {
    
    //GenericList calls VenueProfileViewController passing a Venue obj to firObj
    // When called from a EventProfileViewController, VenueProfileViewController gets venueID passed in
    var firObj: FIRObjectProtocol?
    var venueID: String?
    
    private let firebaseService = FirebaseService.shared
    private let realmService = RealmService.shared
    private let loggedUser = UserSettings().getLoggedUser()
    private var currentCellIds = ["Main", "Info"]
    
    @IBOutlet weak var venueProfileTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //place tableview under status bar
        venueProfileTableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height,
                                                       left: 0,
                                                       bottom: 0,
                                                       right: 0)
        venueProfileTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if let venue = firObj as? Venue {
            listData(forVenue: venue)
        } else if venueID != nil {
            fetchVenueData(venueID: venueID!)
        } else {
            //TODO!
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        currentCellIds = ["Main", "Info"]
    }
    
    private func addRows(venue: Venue) {
        
        if !venue.openingHours.isEmpty {
            currentCellIds.append("OpeningHours")
        }
        if venue.images.count > 2 {
            currentCellIds.append("Galery")
        }
        if venue.upcomingEvents > 0 {
            currentCellIds.append("Events")
        }

        let favoriteVenue = realmService.getDocument(PrimaryKey: venue.id, fromCollection: .favoriteVenue)
        if (venue.followers > 0 ) || (favoriteVenue != nil) {
            currentCellIds.append("Followers")
        }
    }
    
    private func fetchVenueData(venueID: String) {
        firebaseService.getDocument(documentID: venueID, documentType: Venue.self, fromCollection: .venue) {
            [unowned self] (result) in
            switch result {
            case .success(let venue):
                self.listData(forVenue: venue)
            case .failure(_):
                //TODO! :
                print()
            }
        }
    }
    
    private func listData(forVenue venue: Venue){
        DispatchQueue.main.async {
            self.firObj = venue
            self.addRows(venue: venue)
            self.venueProfileTableView.reloadData()
        }
    }
}

extension VenueProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentCellIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let venue = firObj as? Venue else { return UITableViewCell() }
        let cellId = currentCellIds[indexPath.row]
        switch cellId {
        case "Main":
            let cell = tableView.dequeueReusableCell(withIdentifier: "VenueMainTableViewCell", for: indexPath) as? VenueMainTableViewCell
            cell?.delegate = self
            cell?.formatUI(forVenue: venue, isFavorite: false)
            return cell!
        case "Info":
            let cell = tableView.dequeueReusableCell(withIdentifier: "VenueInfoTableViewCell", for: indexPath) as? VenueInfoTableViewCell
            cell?.formatUI(forVenue: venue)
            return cell!
        case "OpeningHours":
            let cell = tableView.dequeueReusableCell(withIdentifier: "VenueOpeningHoursTableViewCell", for: indexPath) as? VenueOpeningHoursTableViewCell
            cell?.formatUI(forVenue: venue)
            return cell!
        case "Galery":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegueToListTableViewCell", for: indexPath) as? SegueToListTableViewCell
            cell?.formatUI(label: "Galery")
            return cell!
        case "Events":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegueToListTableViewCell", for: indexPath) as? SegueToListTableViewCell
            cell?.formatUI(label: "Events")
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegueToListTableViewCell", for: indexPath) as? SegueToListTableViewCell
            cell?.formatUI(label: "Followers")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = loggedUser else { return }
        guard let venue = firObj as? Venue else { return }
        
        let cellId = currentCellIds[indexPath.row]
        switch cellId {
        case "Galery":
            print()
            
        case "Events":
            let geneircListVC = VenueEventsViewController()
            geneircListVC.setData(isASortedList: false,
                                   viewForCollsTopConstraint: nil,
                                   loggedUser: user,
                                   searchType: .events,
                                   controllerTitle: "Upcoming Events",
                                   objectID: venue.id)
            self.navigationController?.pushViewController(geneircListVC, animated: true)

        case "Followers":
            let geneircListVC = VenueFollowersViewController()
            geneircListVC.setData(isASortedList: false,
                                   viewForCollsTopConstraint: nil,
                                   loggedUser: user,
                                   searchType: .users,
                                   controllerTitle: "Followers",
                                   objectID: venue.id)
            self.navigationController?.pushViewController(geneircListVC, animated: true)
            
        default:
            break
        }
    }
}

extension VenueProfileViewController: VenueProfileMainCellDelegate, FavoriteVenueProtocol {
    
    func handleIsFavoriteToggleButton(sender: VenueMainTableViewCell) {
        guard let venue = sender.currentVenue else { return }
        guard let user = loggedUser else { return }
        
        if sender.isFavoriteVenue {
            followVenue(forVenue: venue, user: user)
        } else {
            unfollowVenue(forVenue: venue, user: user)
        }
    }
    
    func handleBackButton(sender: VenueMainTableViewCell) {
        self.navigationController?.popViewController(animated: true)
    }
}
