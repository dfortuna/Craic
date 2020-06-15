//
//  FavoritesViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 5/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var loggedUser: User?
    private let firestore = FirebaseService.shared
    private var favorites = [Venue]()
    @IBOutlet weak var favoriteListCollectionView: UICollectionView!
    @IBOutlet weak var activtyIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Favorites"
        self.navigationController?.isNavigationBarHidden = false
//        navigationController?.navigationBar.prefersLargeTitles = true
        favoriteListCollectionView.register(UINib(nibName: "VenueCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "VenueCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let userId = loggedUser?.id else { return }
        fetchUserFavoriteVenues(forUserId: userId)
        activtyIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let userId = loggedUser?.id else { return }
        firestore.removeListener(from: .userFavorites(ofUser: userId))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchUserFavoriteVenues(forUserId userId: String){
        firestore.fetchWithListener(from: .userFavorites(ofUser: userId), returning: Venue.self) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let venues):
                self.formatResult(forList: venues)
            }
        }
    }
    
    func formatResult(forList list: [Venue]) {
        favorites.removeAll()
        favorites = list
        DispatchQueue.main.async {
            self.activtyIndicator.stopAnimating()
            self.activtyIndicator.alpha = 0
            self.favoriteListCollectionView.reloadData()
        }
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VenueCollectionViewCell", for: indexPath) as! VenueCollectionViewCell
        let venue = favorites[indexPath.row]
        cell.delegate = self
        //TODO! - Realm Access
        let isFavorite = false
        //************************
        cell.formatUI(venue: venue, isFavorite: isFavorite)
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let venue = favorites[indexPath.row]
        let venueProfile = UIStoryboard(name: "VenueProfile", bundle: nil)
        .instantiateViewController(withIdentifier: "VenueProfileViewController")
            as! VenueProfileViewController
        self.navigationController?.pushViewController(venueProfile, animated: true)
        venueProfile.venue = venue
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = favoriteListCollectionView.frame.width - 16
        return CGSize(width: width , height: 120)
    }
}

extension FavoritesViewController: VenueCollectionViewCellProtocol, FavoriteVenueProtocol {
    func handleAddAsFavorite(sender: VenueCollectionViewCell) {
        guard let venue = sender.currentVenue else { return }
        guard let user = loggedUser else { return }

        if sender.isFavorite {
            followVenue(forVenue: venue, user: user)
        } else {
            unfollowVenue(forVenue: venue, user: user)
        }
    }
}
