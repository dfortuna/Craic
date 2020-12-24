//
//  MenuViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 6/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var menuTableView: UITableView!

    let loggedUser = UserSettings().getLoggedUser()
    private let menuCellNames = ["Friends", "Favorites", "Agenda", "Messages"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.configureNavigationController()
        menuTableView.tableFooterView = UIView(frame: CGRect.zero)
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func userProfilePicTapped(_ sender: UITapGestureRecognizer) {
        guard let user = loggedUser else { return }
        let userProfileVC = UIStoryboard(name: "UserProfile", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        self.navigationController?.pushViewController(userProfileVC, animated: true)
        userProfileVC.firObj = user
    }

    private func updateUI(){
        guard let user = loggedUser else { return }
        userNameLabel.text = user.name
        loadProfilePic(fromURLString: user.profileImage)
    }

    private func loadProfilePic(fromURLString urlString: String) {
        if let profImage = URL(string: urlString) {
            DispatchQueue.global().async {
                guard let imagedata2 = try? Data(contentsOf: profImage)  else { return }
                DispatchQueue.main.async {
                    self.profilePicImageView.image = UIImage(data: imagedata2)
                }
            }
        }
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuCellNames.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell
        let cellName = menuCellNames[indexPath.row]
        
        cell?.upDateUI(cellName: cellName)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let user = loggedUser else { return }
        let cellID = indexPath.row
        switch cellID {
        case 0:            
            let geneircListVC = FriendsViewController()
            geneircListVC.setData(isASortedList: false,
                                   viewForCollsTopConstraint: nil,
                                   loggedUser: user,
                                   searchType: .users,
                                   controllerTitle: "Friends",
                                   objectID: user.id)
            self.navigationController?.pushViewController(geneircListVC, animated: true)
            
        case 1:
            let geneircListVC = FavoritesViewController()
            geneircListVC.setData(isASortedList: false,
                                   viewForCollsTopConstraint: nil,
                                   loggedUser: user,
                                   searchType: .venues,
                                   controllerTitle: "Favorites",
                                   objectID: user.id)
            self.navigationController?.pushViewController(geneircListVC, animated: true)
        
        case 2:
            let geneircListVC = AgendaViewController()
            geneircListVC.setData(isASortedList: false,
                                   viewForCollsTopConstraint: nil,
                                   loggedUser: user,
                                   searchType: .events,
                                   controllerTitle: "Agenda",
                                   objectID: user.id)
            self.navigationController?.pushViewController(geneircListVC, animated: true)

        case 3:
            let messagesVC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "MessagesListTableViewController") as! MessagesListTableViewController
            self.navigationController?.pushViewController(messagesVC, animated: true)
            messagesVC.loggedUser = user
        default:
            break
        }
    }
}
