//
//  FacebookService.swift
//  theCraic3
//
//  Created by Denis Fortuna on 4/5/18.
//  Copyright © 2018 Denis. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class FacebookService: NSObject {
    
    static let shared = FacebookService()
    var token: AccessToken? {
        get {
            return  AccessToken.current
        }
   }
//    let appURL = URL(string: "fb://profile/1536425579779197")!
//    let webURL = URL(string: "https://web.facebook.com/The-Craic-App-1536425579779197")!
    let readPermissions = ["user_friends", "email", "user_gender"]
    let parametersForGraphRequest = ["fields": "id, name, first_name, last_name, email, gender, picture.type(large), friends"]
    
    func getLogginButton() -> FBLoginButton {
        return FBLoginButton()
    }
    
    func login(fromViewController viewController: UIViewController!, callback: @escaping (Result<String, FacebookError>) -> ()) {
        LoginManager().logIn(permissions: readPermissions, from: viewController) { (result, error) in
            if error != nil {
                callback(.failure(FacebookError.facebookLogin))
                print("FaceBookService - login error \(String(describing: error))")
                return
            } else {
                guard let fbToken = AccessToken.current else {
                    callback(.failure(FacebookError.facebookLogin))
                    return
                }
                callback(.success(fbToken.tokenString))
            }
        }
    }
    
    func graphRequest(callback: @escaping (Result<[String: AnyObject], FacebookError>) -> ()) {
        GraphRequest(graphPath: "/me", parameters: parametersForGraphRequest).start { (connection, result, error) in
            if error != nil {
                callback(.failure(FacebookError.facebookLogin))
            } else {
                guard let myProfile = result as? [String : AnyObject] else {
                    callback(.failure(FacebookError.facebookLogin))
                    return
                }
                callback(.success(myProfile))
            }
        }
    }
    
    func logoff() {
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    
//    func contact() {
//        let application = UIApplication.shared
//        if application.canOpenURL(appURL as URL) {
//            application.open(appURL as URL)
//        } else {
//            application.open(webURL as URL)
//        }
//    }
    
}

extension FacebookService: LoginButtonDelegate{
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print("error facebook login \(error!.localizedDescription)")
            return
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        loginButton.permissions = readPermissions
    }
}

