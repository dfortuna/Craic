//
//  CoreLocationService.swift
//  Project4
//
//  Created by Denis Fortuna on 23/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct Address {
    let streetName: String?
    let streetNumeber: String?
    let postalCode: String?
    let city: String?
    let region: String?
    let country: String?
}

class CoreLocationService: NSObject {
    
    private override init() {}
    static let shared = CoreLocationService()
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var alertMessage: Alert? = nil
    
//TODO! - Check LOCATION
//    private lazy var locationManager: CLLocationManager = {
//
//        let manager = CLLocationManager()
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        manager.delegate = self
//        return manager
//    }()
    
    // Check if the user has enable Location services in Settings
    // execute this at MainVC
    func checkLocationServices() -> Alert? {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManger()
            alertMessage = checkAuthorizations()
        } else {
            //TODO! - ALERT: Enable location services
            alertMessage = Alert.locationAccessDisable
        }
        return alertMessage
    }
    
    private func setupLocationManger() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkAuthorizations() -> Alert? {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            //Not going to ask for this one
            return nil
        case .authorizedWhenInUse:
            currentLocation = locationManager.location
            locationManager.startUpdatingLocation()
//            locationManager.requestLocation()
            return nil
        case .denied:
            locationManager.requestWhenInUseAuthorization()
            return nil
        case .notDetermined:
            // request the permission
            locationManager.requestWhenInUseAuthorization()
            return nil
        case .restricted:
            //the user cant change the statuts(parental control)
            //TODO! - ALERT: location services disable
            return Alert.locationRestricted
        default:
            return nil
        }
    }
    
    func getUserCity(callback: @escaping (Result<Address, Error>) -> ()) {
        
        guard let userLocation = currentLocation else {return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error == nil {
                guard let placemark = placemarks?.first else { return }
                
                let address = Address(streetName: placemark.thoroughfare,
                                      streetNumeber: placemark.subThoroughfare,
                                      postalCode: placemark.postalCode,
                                      city: placemark.locality,
                                      region: placemark.country,
                                      country: placemark.country)
                callback(.success(address))
            } else {
                callback(.failure(error!))
            }
        }
    }
    
    func userDistanceToCoordinate(latitudeStr: String?, longitudeStr: String?) -> String? {
        // Converting Latitude and Longitude from DB in String? format to Coordinates in CLLocationDegrees
        guard let latStr = latitudeStr, let lonStr = longitudeStr else { return nil }
        guard let latitudeDouble = Double(latStr) else { return nil }
        guard let longitudeDouble = Double(lonStr) else { return nil }
        guard let lat = CLLocationDegrees(exactly: latitudeDouble) else {return nil }
        guard let lon = CLLocationDegrees(exactly: longitudeDouble) else {return nil }
        
        // Combining coordinates in CLLocationDegrees to create a CLLocation
        let location = CLLocation(latitude: lat, longitude: lon)
        print()
        print("******** CLLocation: ", location)
        
        guard let userLocation = currentLocation else {return nil }
        print("******** userLocation: ", userLocation)
        print()
        
        let distance = userLocation.distance(from: location)
        return String(distance)
    }
    
}

extension CoreLocationService: CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        alertMessage = checkAuthorizations()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            print("didnt get user location")
            return
        }
        currentLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorMessage = "Im so sorry!"
        print(errorMessage)
        print(error)
    }
    
}
