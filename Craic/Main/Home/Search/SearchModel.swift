//
//  SearchModel.swift
//  Project4
//
//  Created by Denis Fortuna on 14/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation
import UIKit

class SearchModel {
    
    private let defaults = UserDefaults.standard
    private let defaultDictionary = ["searchType": "Events"]
    private var attributesDictionary: [String: String] {
        get { return defaults.object(forKey: "attributesDictionary") as? [String: String] ?? defaultDictionary}
        set { defaults.set(newValue, forKey: "attributesDictionary")}
    }
        
    func saveFilters(searchFor: String?, venueType: String?, category: String?, priceRange: String?,
                     feature: String?, cusine: String?, musicStyle: String?, dressCode: String?,
                     distance: String?) {
        var dictionary = [String: String]()
        if let searchFor = searchFor { dictionary["searchFor"] = searchFor }
        if let venueType = venueType { dictionary["venueType"] = venueType }
        if let category = category { dictionary["category"] = category }
        if let priceRange = priceRange { dictionary["priceRange"] = priceRange }
        if let feature = feature { dictionary["feature"] = feature }
        if let cusine = cusine { dictionary["cusine"] = cusine }
        if let musicStyle = musicStyle { dictionary["musicStyle"] = musicStyle }
        if let dressCode = dressCode { dictionary["dressCode"] = dressCode }
        if let distance = distance { dictionary["distance"] = distance }
        attributesDictionary = dictionary
    }
    
    func getAttributesDictionary() -> [String: String] {
        return attributesDictionary
    }
    
    let searchForOptions = ["Events", "Venues"]
    
    let venueTypeOptions = ["-- Select --", "Nightclubs", "Bars", "Restaurants", "Theatres", "Art Galeries", "Stadium", "Parks", "Street Event", "Clubs"]
    
    let categoryOptions = ["-- Select --", "Musical", "Gastronomic", "Arts", "Sports", "Markets", "Business", "Night Out", "Religious", "Academic"]

    let priceRangeOptions = ["-- Select --", "Free", "Up to $20", "$21 - $100", "$101 - $200", "$200+"]

    let featureOptions = ["-- Select --", "Parking", "ATM", "Rooftop", "Beachfront"]
    
    let cusineOptions = ["-- Select --", "Mediterranean", "Vegan", "Vegeterian", "American", "British",
                  "Caribbean", "Chinese", "French", "Greek", "Indian", "Italian",
                  "Japanese", "Mexican", "Moroccan", "Spanish", "Thai", "Turkish",
                  "Vietnamese", "Korean", "Portuguese", "South American"]
    
    let musicStyleOptions = ["-- Select --", "Latin", "R&B", "Rock", "Eletronic", "Classical", "Pop", "Hip-Hop", "Country", "Folk", "Gospel", "Blues", "Jazz"]
    
    let dressCodeOptions = ["-- Select --", "Back Tie", "Casual", "Smart Casual", "Thematic"]
}
