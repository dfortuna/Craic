//
//  SettingsTableViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 6/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let loggedUser = UserSettings().getLoggedUser()
    let facebookService = FacebookService.shared
    var cellsID = ["Logoff"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationController?.configureNavigationController()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsID.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = cellsID[indexPath.row]
        
        switch cellID {
            
        case "Logoff":
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoffTableViewCell", for: indexPath) as! LogoffTableViewCell
            cell.delegate = self
            return cell

        default:
            return UITableViewCell()
        }
    }
}

extension SettingsTableViewController: LogoffDelegate {
    
    func handleLogoff(sender: LogoffTableViewCell) {
        facebookService.logoff()
        
        let login:UIViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(login, animated: true, completion: nil)
    }
    
}
