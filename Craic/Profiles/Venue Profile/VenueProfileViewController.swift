//
//  VenueProfileViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class VenueProfileViewController: UIViewController, FIRObjectViewController {
    
    var firObj: FIRObjectProtocol?
    @IBOutlet weak var venueProfileTableView: UITableView!
    private var currentCellIds = ["Main", "Info"]
    let loggedUser = UserSettings().getLoggedUser()
    var venue: Venue?

    override func viewDidLoad() {
        super.viewDidLoad()
        venueProfileTableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height,
                                                       left: 0,
                                                       bottom: 0,
                                                       right: 0)
        venueProfileTableView.tableFooterView = UIView(frame: CGRect.zero)
        formatUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        venueProfileTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func formatUI() {
        guard let venue = venue else { return }
        
        if !venue.openingHours.isEmpty {
            currentCellIds.append("OpeningHours")
        }
        if venue.images.count > 2 {
            currentCellIds.append("Galery")
        }
        if venue.hasEvents {
            currentCellIds.append("Events")
        }
        if venue.hasFollowers {
            currentCellIds.append("Followers")
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
        guard let venue = venue else { return UITableViewCell() }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "VenueGenericTableViewCell", for: indexPath) as? VenueGenericTableViewCell
            cell?.formatUI(label: "Galery")
            return cell!
        case "Events":
            let cell = tableView.dequeueReusableCell(withIdentifier: "VenueGenericTableViewCell", for: indexPath) as? VenueGenericTableViewCell
            cell?.formatUI(label: "Events")
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VenueGenericTableViewCell", for: indexPath) as? VenueGenericTableViewCell
            cell?.formatUI(label: "Followers")
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellId = currentCellIds[indexPath.row]
        
        guard let user = loggedUser else { return }
        
        switch cellId {
        case "Galery":
            print()
        case "Events":
            
            let geneircListVC = GenericListViewController<Event, EventCollectionViewCell, EventProfileViewController>()
            geneircListVC.setData(isASortedList: false,
                                   viewForCollsTopConstraint: nil,
                                   loggedUser: user,
                                   searchType: .events,
                                   controllerTitle: "Events")
            self.navigationController?.pushViewController(geneircListVC, animated: true)

            
        case "Followers":
            print()
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
