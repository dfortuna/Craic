//
//  MainViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 3/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let facebookService = FacebookService.shared
    let firebaseService = FirebaseService.shared
    let coreLocationService = CoreLocationService.shared
    let appMetaDataDocId = "000"
    let databaseVersion = 1.2
    
    override func viewDidLoad() {
        coreLocationService.checkLocationServices() // check authorizations and format current location
        getMetaData()
    }
    
    
    // MARK: - Database version

    //Fetch Metadata collection to check DB version and format cities
    func getMetaData() {
        firebaseService.getDocument(documentID: appMetaDataDocId,
                                    documentType: Metadata.self,
                                    fromCollection: .metadata) { (result) in
                                        switch result {
                                        case .failure(let error):
                                            //TODO - allert Try again later..
                                            print("getMetaData ", error)
                                        case .success(let metadata):
                                            self.checkAppVersion(metadata: metadata)
                                        }
        }
    }
    
    
    func checkAppVersion(metadata: Metadata) {
        if metadata.appDatabaseVersion > databaseVersion {
            //TODO - Alert update app version
        } else {
            checkIfUserIsLogged()
            formatCiyToDatabase(metadata: metadata)
        }
    }
    
    
    // MARK: - User Logged
    //Check if user has a Facebook token. If so, present HomeTableView controller, otherwise, it goes to Login flow
    func checkIfUserIsLogged() {
        if facebookService.token != nil {
            DispatchQueue.main.async {
                let viewController:UIViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabBarController")
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = viewController
            }
        } else {
            DispatchQueue.main.async {
                let viewController:UIViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.window?.rootViewController = viewController
            }
        }
    }
    
    // MARK: - user location
    
    func formatCiyToDatabase(metadata: Metadata) {
        findUserCityToDatabase { (result) in
            switch result {
            case .failure(let error):
                print(error) // TODO - check this
            case .success(let currentAddress):
                self.formatMetadataToDatabase(metadata: metadata, currentAddress: currentAddress)
            }
        }
    }
    
    func formatMetadataToDatabase(metadata: Metadata, currentAddress: Address) {
        guard let currentCity = currentAddress.city else { return }
        var metadataCities = metadata.cities
        
        if !metadataCities.contains(currentCity) {
            metadataCities.append(currentCity)
        }
        let cities: [String: AnyObject] = ["cities": metadataCities as AnyObject]
        self.addUserCityToDatabase(cities: cities)
    }
    
    func findUserCityToDatabase(callback: @escaping (Result<Address, Error>) -> ()) {
        coreLocationService.getUserCity { (result) in
            switch result {
            case .failure(let error):
                callback(.failure(error))
            case.success(let userAddress):
                callback(.success(userAddress))
            }
        }
    }
    
    func addUserCityToDatabase(cities: [String: AnyObject]) {
        firebaseService.updateMergeData(objectID: appMetaDataDocId,
                                        in: .metadata,
                                        dataToUpdate: cities) { (result) in
                                            switch result {
                                            case .failure(let errorMessage):
                                                print(errorMessage)
                                            case .success(let sucessMessge):
                                                print(sucessMessge)
                                            }
        }
    }
}
