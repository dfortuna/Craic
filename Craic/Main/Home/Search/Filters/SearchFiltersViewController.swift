//
//  SearchFiltersViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

class SearchFiltersViewController: UIViewController {

    let cellsID = ["SearchType","EventCategory","VenueType","Price", "MusicStyle", "Features", "Cusine", "DressCode", "DistanceRadius", "OK Button"]
    var model = SearchModel()
    var searchFor: String? = "Events", category : String? = nil, venueType: String? = nil, price: String? = nil, musicStyle: String? = nil, features: String? = nil, cusine: String? = nil, dressCode: String? = nil, distance: String? = nil
    var filtersSet: (() -> Void)?
    
    @IBOutlet weak var mapButtonOtlet: UIButton!
    @IBOutlet weak var filtersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        formatUI()
        filtersTableView.reloadData()
    }
    
    func formatUI(){
        let filters = model.getAttributesDictionary()
        searchFor = filters["searchFor"]
        category = filters["category"]
        venueType = filters["venueType"]
        price = filters["priceRange"]
        musicStyle = filters["musicStyle"]
        features = filters["feature"]
        cusine = filters["cusine"]
        dressCode = filters["dressCode"]
        distance = filters["distance"]
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension SearchFiltersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = cellsID[indexPath.row]
        switch cellID {
        case "SearchType":
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.delegate = self
            cell.formatUI(labelText: "Search for:", list: model.searchForOptions, currentOption: searchFor)
            return cell
            
        case "EventCategory":
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCategoryTableViewCell", for: indexPath) as! EventCategoryTableViewCell
            cell.delegate = self
            cell.formatUI(categoryLabel: "Event Category:", categoryList: model.categoryOptions, category: category)
            return cell
            
        case "VenueType":
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.delegate = self
            cell.formatUI(labelText: "Venue Types:", list: model.venueTypeOptions, currentOption: venueType)
            return cell
            
        case "Price":
            let cell = tableView.dequeueReusableCell(withIdentifier: "PriceTableViewCell", for: indexPath) as! PriceTableViewCell
            cell.delegate = self
            cell.formatUI(currentPrice: price, list: model.priceRangeOptions)
            return cell
            
        case "MusicStyle":
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.delegate = self
            cell.formatUI(labelText: "Music Style:", list: model.musicStyleOptions, currentOption: musicStyle)
            return cell
            
        case "Features":
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.delegate = self
            cell.formatUI(labelText: "Features:", list: model.featureOptions, currentOption: features)
            return cell
            
        case "Cusine":
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.delegate = self
            cell.formatUI(labelText: "Cusine:", list: model.cusineOptions, currentOption: cusine)
            return cell
            
        case "DressCode":
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell", for: indexPath) as! GenericTableViewCell
            cell.delegate = self
            cell.formatUI(labelText: "Dress code:", list: model.dressCodeOptions, currentOption: dressCode)
            return cell
            
        case "DistanceRadius":
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceRadiusTableViewCell", for: indexPath) as! DistanceRadiusTableViewCell
            cell.delegate = self
            cell.formatUI(distance: distance)
            return cell
            
        case "OK Button":
            let cell = tableView.dequeueReusableCell(withIdentifier: "OkButtonTableViewControllerCell", for: indexPath) as! OkButtonTableViewControllerCell
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SearchFiltersViewController: GenericCellDelegate {
    func handleCategory(sender: GenericTableViewCell) {
        let description = sender.descriptionLabel.text
        switch description {
        case "Search for:":
            searchFor = sender.currentOption
        case "Venue Types:":
            venueType = sender.currentOption
        case "Music Style:":
            musicStyle = sender.currentOption
        case "Cusine:":
            cusine = sender.currentOption
        case "Dress code:":
            dressCode = sender.currentOption
        case "Features:":
            features = sender.currentOption
        default:
            break
        }
    }
}

extension SearchFiltersViewController: DistanceRadiusDelegate {
    func handleDistance(sender: DistanceRadiusTableViewCell) {
        distance = "\(sender.currentDistance)"
    }
}

extension SearchFiltersViewController: PriceTableViewCellDelegate {
    func handleprice(sender: PriceTableViewCell) {
        price = sender.currentPrice
    }
}

extension SearchFiltersViewController: EventCategoryDelegate {
    func handleCategory(sender: EventCategoryTableViewCell) {
        category = sender.currentCategory
    }
}

extension SearchFiltersViewController: OkButtonCellDelegate {
    func handleOkButton(sender: OkButtonTableViewControllerCell) {
        model.saveFilters(searchFor: searchFor, venueType: venueType, category: category, priceRange: price, feature: features, cusine: cusine, musicStyle: musicStyle, dressCode: dressCode, distance: distance)
        filtersSet?()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
