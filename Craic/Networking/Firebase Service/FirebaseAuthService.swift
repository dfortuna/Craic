//
//  FirebaseAuthService.swift
//  Project4
//
//  Created by Denis Fortuna on 5/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuthService {
    
    static let shared = FirebaseAuthService()
    
    func authenticateFacebookUser(withToken token: String, callback: @escaping (Result<AuthDataResult?, FirebaseError>) -> () ) {
        let credentials = FacebookAuthProvider.credential(withAccessToken: token)
        Auth.auth().signIn(with: credentials) { (user, error) in
            Auth.auth().signIn(with: credentials) { (result, error) in
                if error != nil {
                    callback(.failure(FirebaseError.userNotAuthenticated))
                } else if result != nil {
                    callback(.success(result))
                } else {
                    callback(.failure(FirebaseError.userNotAuthenticated))
                }
            }
        }
    }
    
//    func createUser(fbUserID: String, values: [String:String], callback: @escaping (Result<User, FirebaseError>) -> ()) {
//        refUsers.child(fbUserID).setValue(values) { (error, reference) in
//            if error != nil {
//                callback(.failure(FirebaseError.facebookLogin))
//            }
//        }
//    }
}
