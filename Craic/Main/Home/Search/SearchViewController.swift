//
//  SearchViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 14/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    enum SearchType {
        case events
        case venues
    }
    var searchType = SearchType.events
    let firestore = FirebaseService.shared
    let coreLocationService = CoreLocationService.shared
    var resultList = [FIRObjectProtocol]()
    
    let loggedUser = UserSettings().getLoggedUser()
    var filters = SearchModel().getAttributesDictionary()
    var isSearchingForEvents = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Search"
        seacrhCollectionView.register(UINib(nibName: "EventCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EventCollectionViewCell")
        seacrhCollectionView.register(UINib(nibName: "VenueCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "VenueCollectionViewCell")
        self.navigationController?.configureNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchResults()
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func fetchResults() {
        let formatedFilters = filters.filter{$0.value != "-- Select --"}
        if formatedFilters["searchFor"] == "Events" {
            searchType = .events
            self.navigationItem.title = "Events"
            getEvents(fromFormatedFilters: formatedFilters)
        } else {
            searchType = .venues
            self.navigationItem.title = "Venues"
            getVenues(fromFormatedFilters: formatedFilters)
        }
    }

    func getEvents(fromFormatedFilters filters: [String: String]) {
        firestore.queryDocuments(from: .event, returning: Event.self, queryFields: filters) { (results) in
            switch results {
            case .success(let events):
                self.formatResult(forList: events)
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error) //TODO! - Message view (no events to show)
                }
            }
        }
    }
    
    func getVenues(fromFormatedFilters filters: [String: String]) {
        firestore.queryDocuments(from: .venue, returning: Venue.self, queryFields: filters) { (result) in
            switch result {
            case .success(let venues):
                self.formatResult(forList: venues)
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error) //TODO! - Message view (no venues to show)
                }
            }
        }
    }
    
    func formatResult<T: FIRObjectProtocol>(forList list: [T]) {
        resultList.removeAll()
        resultList = list
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.alpha = 0
            self.seacrhCollectionView.reloadData()
        }
    }

    @IBOutlet weak var seacrhCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func showFilters(_ sender: UIBarButtonItem) {
        let filtersVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchFiltersViewController") as! SearchFiltersViewController
        self.navigationController?.present(filtersVC, animated: true)
        filtersVC.filtersSet = {
            self.filters = SearchModel().getAttributesDictionary()
            self.fetchResults()
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch searchType {
        case .events:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", for: indexPath) as! EventCollectionViewCell
            guard let event = resultList[indexPath.row] as? Event else { return UICollectionViewCell() }
            cell.delegate = self
            guard let obj = FIRCellInputObj(withFIRObjectProtocol: event) else { return UICollectionViewCell()}
            cell.formatCellUI(withData: obj)
            return cell
            
        case .venues:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueCollectionViewCell", for: indexPath) as! VenueCollectionViewCell
            guard let venue = resultList[indexPath.row] as? Venue else { return UICollectionViewCell() }
            cell.delegate = self
            
            guard let obj = FIRCellInputObj(withFIRObjectProtocol: venue) else { return UICollectionViewCell()}
            cell.formatCellUI(withData: obj)
            return cell
        }
    }
}


extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch searchType {
        case .events:
            guard let event = resultList[indexPath.row] as? Event else { return }
            
            let eventProfile = UIStoryboard(name: "EventProfile", bundle: nil)
            .instantiateViewController(withIdentifier: "EventProfileViewController")
                as! EventProfileViewController
            self.navigationController?.pushViewController(eventProfile, animated: true)
            eventProfile.event = event
        case .venues:
            guard let venue = resultList[indexPath.row] as? Venue else { return }
            let venueProfile = UIStoryboard(name: "VenueProfile", bundle: nil)
            .instantiateViewController(withIdentifier: "VenueProfileViewController")
                as! VenueProfileViewController
            self.navigationController?.pushViewController(venueProfile, animated: true)
            venueProfile.venue = venue
        }
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = seacrhCollectionView.frame.width - 16
        if resultList[indexPath.row] is Event {
            return CGSize(width: width , height: 120)
        } else if resultList[indexPath.row] is Venue {
            return CGSize(width: width , height: 120)
        } else {
            return CGSize()
        }
    }
}
    
extension SearchViewController: EventCollectionViewCellProtocol, AttendEventProtocol {
    func handleAttendButton(sender: EventCollectionViewCell) {
        guard let event = sender.event else { return }
        guard let user = loggedUser else { return }
        
        if sender.isAttending {
            attendEvent(forEvent: event, user: user)
        } else {
            unattendedEvent(forEvent: event, user: user)
        }
    }
    
    func handleShareButton(sender: EventCollectionViewCell) {
        
    }
}

extension SearchViewController: VenueCollectionViewCellProtocol, FavoriteVenueProtocol {
    func handleAddAsFavorite(sender: VenueCollectionViewCell) {
        guard let venue = sender.venue else { return }
        guard let user = loggedUser else { return }

        if sender.isFavorite {
            followVenue(forVenue: venue, user: user)
        } else {
            unfollowVenue(forVenue: venue, user: user)
        }
    }
}
