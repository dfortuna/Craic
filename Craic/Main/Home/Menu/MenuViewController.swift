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
    private let menuCellNames = ["Friends", "Favorites", "Messages"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.configureNavigationController()
        menuTableView.tableFooterView = UIView(frame: CGRect.zero)
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
            let friendVC = UIStoryboard(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "FriendsViewController") as! FriendsViewController
                self.navigationController?.pushViewController(friendVC, animated: true)
            friendVC.loggedUser =  user
            
        case 1:
            let favoritesVC = UIStoryboard(name: "Favorites", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
            self.navigationController?.pushViewController(favoritesVC, animated: true)
            favoritesVC.loggedUser = user
        
        case 2:
            let messagesVC = UIStoryboard(name: "Messages", bundle: nil).instantiateViewController(withIdentifier: "MessagesListTableViewController") as! MessagesListTableViewController
            self.navigationController?.pushViewController(messagesVC, animated: true)
            messagesVC.loggedUser = user 

        default:
            break
        }
    }
}
