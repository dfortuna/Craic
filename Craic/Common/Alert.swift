//
//  Alert.swift
//  Craic
//
//  Created by Denis Fortuna on 13/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

enum Alert {
    case somethingWentWrong
    case locationAccessDisable
    case locationRestricted
    case updateAppVersion
    case unableToReachServer
    case facebokConnectionError
    case messageSent
    case friendshipRequestSent
    case cancelFriendship(friendName: String)
    
    func call(onViewController vc: UIViewController) {
        switch self {
        case .somethingWentWrong:
            showMessageAlert(on: vc, with: "Oops", message: "Something went wrong. Please try again later.")
        case .locationAccessDisable:
            showMessageAlert(on: vc, with: "Your location services is disable", message: "Craic needs your location to find the bests spots near you.")
        case .locationRestricted:
            showMessageAlert(on: vc, with: "Your location services is disable", message: nil)
        case .updateAppVersion:
            showMessageAlert(on: vc, with: "Sorry, this Craic version is too old.", message: "Please, update Craic on Apple Store to enjoy the new features.")
        case .unableToReachServer:
            showMessageAlert(on: vc, with: "Oops, server out of reach", message: "Please, check you internet connection or try again later.")
        case .facebokConnectionError:
            showMessageAlert(on: vc, with: "Oops, Facebook out of reach", message: "Please, check you internet connection or try again later.")
        case .messageSent:
            showMessageAlert(on: vc, with: "", message: "Your message was sent.")
        case .friendshipRequestSent:
            showMessageAlert(on: vc, with: "", message: "Friendship request has been sent already.")
        default:
            break
        }
    }
    
    private func showMessageAlert(on vc: UIViewController, with title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func call(onViewController vc: UIViewController, callback: @escaping (String) -> Void) {
        switch self {
        case .cancelFriendship(let friendName):
            showOkCancelAlert(on: vc,
                              with: "",
                              message: "Are you sure you want to remove \(friendName) as your friend?") { name in
                                callback(name)
            }
        default:
            break
        }
    }
        
    private func showOkCancelAlert(on vc: UIViewController,
                                   with title: String?,
                                   message: String?,
                                   callback: @escaping (String) -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
            UIAlertAction in
            callback("Ok")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            callback("Cancel")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }
}
