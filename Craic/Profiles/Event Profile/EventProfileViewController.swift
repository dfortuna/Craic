//
//  EventProfileViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventProfileViewController: UIViewController {
    
    var cellIds = ["eventProfilePictures"]
    var event: Event?

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
        self.tabBarController?.tabBar.isHidden = true
        formatUI()
        eventDataTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBOutlet weak var eventDataTableView: UITableView!
    
    private func formatUI() {
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension EventProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellIds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = event else { return UITableViewCell() }
        let cellId = cellIds[indexPath.row]
        switch cellId {
        case "eventProfilePictures":
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventProfilePicturesTableViewCell", for: indexPath) as? EventProfilePicturesTableViewCell
            cell?.formatUI(image: event.images)
            return cell!
        default:
            break
        }
        return UITableViewCell()
    }
}
