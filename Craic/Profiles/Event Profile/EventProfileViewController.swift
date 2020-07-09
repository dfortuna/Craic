//
//  EventProfileViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventProfileViewController: UIViewController, FIRObjectViewController {
    
    var firObj: FIRObjectProtocol?
    var cellIds = ["eventProfilePictures",
                   "EventDateNameTableViewCell"]
    let loggedUser = UserSettings().getLoggedUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        eventDataTableView.contentInset = UIEdgeInsets(top: -UIApplication.shared.statusBarFrame.size.height,
                                                       left: 0,
                                                       bottom: 0,
                                                       right: 0)
        eventDataTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        formatUI()
        eventDataTableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        cellIds = ["eventProfilePictures", "EventDateNameTableViewCell"]
    }
    
    @IBOutlet weak var eventDataTableView: UITableView!
    
    private func formatUI() {
        guard let event = firObj as? Event else { return }
        if !event.description.isEmpty{
            cellIds.append("EventDescriptionTableViewCell")
        }
        if ((event.address != nil) && (event.address != "")) || (!event.price.isEmpty) {
            cellIds.append("EventInfoTableViewCell")
        }
        if event.attendees > 0{
            cellIds.append("Attendees")
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension EventProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellId = cellIds[indexPath.row]
        switch cellId {
        case "eventProfilePictures":
            return 267
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellId = cellIds[indexPath.row]
        switch cellId {
        case "eventProfilePictures":
            return 267
        default:
            return UITableView.automaticDimension
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = firObj as? Event else { return UITableViewCell() }
        let cellId = cellIds[indexPath.row]
        switch cellId {
        case "eventProfilePictures":
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventProfilePicturesTableViewCell", for: indexPath) as? EventProfilePicturesTableViewCell
            cell?.formatUI(pictures: event.images)
            return cell!
            
        case "EventDateNameTableViewCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDateNameTableViewCell", for: indexPath) as? EventDateNameTableViewCell
            cell?.delegate = self
            cell?.formatUI(name: event.name, date: event.date, hostName: event.hostName)
            return cell!

        case "EventDescriptionTableViewCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventDescriptionTableViewCell", for: indexPath) as? EventDescriptionTableViewCell
            cell?.formatUI(description: event.description)
            return cell!
            
        case "EventInfoTableViewCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventInfoTableViewCell", for: indexPath) as? EventInfoTableViewCell
            
            cell?.formatUI(time: event.time,
                           phone: event.phone ?? "",
                           price: event.price,
                           address: event.address ?? "")
            return cell!
            
        case "Attendees":
            let cell = tableView.dequeueReusableCell(withIdentifier: "SegueToListTableViewCell", for: indexPath) as? SegueToListTableViewCell
            cell?.formatUI(label: "Attendees")
            return cell!
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let event = firObj as? Event else { return }
        guard let user = loggedUser else { return }
        if cellIds[indexPath.row] == "Attendees" {
            let genericListVC = EventAttendees()
            
            genericListVC.setData(isASortedList: false,
                                  viewForCollsTopConstraint: nil,
                                  loggedUser: user,
                                  searchType: .users,
                                  controllerTitle: "Attendees",
                                  objectID: event.id)
            self.navigationController?.pushViewController(genericListVC, animated: true)
        }
    }
}

extension EventProfileViewController: eventProfileNameCellProtocol {
    func showHost(sender: EventDateNameTableViewCell) {
        guard let event = firObj as? Event else { return }
        
        let venueProfile = UIStoryboard(name: "VenueProfile", bundle: nil)
        .instantiateViewController(withIdentifier: "VenueProfileViewController")
            as! VenueProfileViewController
        self.navigationController?.pushViewController(venueProfile, animated: true)
        venueProfile.venueID = event.hostID
    }
}

