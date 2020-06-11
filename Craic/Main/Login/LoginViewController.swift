//
//  LoginViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 3/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let firebaseAuth = FirebaseAuthService.shared
    let firestore = FirebaseService.shared
    let facebookService = FacebookService.shared
    var userSettings = UserSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        facebookService.login(fromViewController: self) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let token):
                self.authenticateFacebookUSer(withToken: token)
            }
        }
    }
    
    func authenticateFacebookUSer(withToken token: String) {
        firebaseAuth.authenticateFacebookUser(withToken: token) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success( _):
                self.requestAccessForUserPublicData()
            }
        }
    }
    
    func requestAccessForUserPublicData() {
        facebookService.graphRequest { (result) in
            switch result {
            case .failure(let error):
                print(error)  //TODO: Alert for access denied
            case .success(let fbUser):
                self.formatFacebookUser(fbUser: fbUser)
            }
        }
    }
    
    func formatFacebookUser(fbUser: [String: AnyObject]) {
        guard let user = User(with: fbUser) else { return }
        self.getFriendsForFriendshipCollection(fbUser: fbUser, user: user)
        addUser(user: user)
    }
    
    func getFriendsForFriendshipCollection(fbUser: [String : AnyObject], user: User){
        let friendsdata = fbUser["friends"] as? [String:Any] ?? [String:Any]()
        if let friendsDictionary = friendsdata["data"] as? [[String: String]] {
            for fbFriend in friendsDictionary {
                self.formatFriendship(forUser: user, friend: fbFriend)
            }
        }
    }
    
    func formatFriendship(forUser user: User, friend: [String: String]){
        var friendshipData = friend
        friendshipData["userId"] = user.id
        friendshipData["userName"] = user.name
        friendshipData["userProfilePicture"] = user.profileImage
        guard let friendship = Friendship(with: friendshipData as [String : AnyObject]) else {
            print("Unable to set friendship ", user.id, " ", friend[""])
            return
        }
        setFriendship(friendship: friendship)
    }
    
    func setFriendship(friendship: Friendship) {
        firestore.create(for: friendship, in: .friendship) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
                print("friendship added")
            }
        }
    }
    
    func addUser(user: User) {
        firestore.create(for: user, in: .user) { (result) in
            switch result {
            case .failure(let error):
                print(error) //TODO - check this
            case .success( _):
                self.userSettings.setLoggedUser(forUser: user)
                self.instantiateRootViewController()
            }
        }
    }
    
    func instantiateRootViewController() {
        let viewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = viewController
    }
}
