//
//  FeedViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 4/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var FeedCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let firebaseService = FirebaseService.shared
    let loggedUser = UserSettings().getLoggedUser()
    private var feedPosts = [Feed]() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Feed"
        self.navigationController?.configureNavigationController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFeedPosts()
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let user = loggedUser else { return }
        firebaseService.removeListener(from: .userFeed(ofUser: user.id))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func fetchFeedPosts() {
        guard let user = loggedUser else { return }
        firebaseService.fetchWithListener(from: .userFeed(ofUser: user.id), returning: Feed.self) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let feedPosts):
                self.showResults(posts: feedPosts)
            }
        }
    }
    
    func showResults(posts: [Feed]) {
        DispatchQueue.main.async {
            self.feedPosts.removeAll()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.alpha = 0
            self.feedPosts = posts
        }
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellWidth = FeedCollectionView.frame.size.width - 16
        let feedpost = feedPosts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell
        cell?.formatUI(feed: feedpost, cellWidth: cellWidth)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feedpost = feedPosts[indexPath.row]
        let (event, venue) = extractContent(fromFeed: feedpost)
        if let event = event {
            let eventProfile = UIStoryboard(name: "EventProfile", bundle: nil)
            .instantiateViewController(withIdentifier: "EventProfileViewController")
                as! EventProfileViewController
            self.navigationController?.pushViewController(eventProfile, animated: true)
            eventProfile.firObj = event
        } else if let venue = venue {
            let venueProfile = UIStoryboard(name: "VenueProfile", bundle: nil)
            .instantiateViewController(withIdentifier: "VenueProfileViewController")
                as! VenueProfileViewController
            self.navigationController?.pushViewController(venueProfile, animated: true)
            venueProfile.firObj = venue 
        }
    }
    
    func extractContent(fromFeed feed: Feed) -> (Event?, Venue?) {
        guard let feedJson = try? feed.toJson(excluding: ["id"]) as [String: AnyObject]
            else { return (nil, nil)}
        if feed.feedType == FeedType.venueNewEvent.rawValue || feed.feedType == FeedType.friendsAttendingEvent.rawValue {
            guard let eventFromFeed = Event(with: feedJson) else { return (nil, nil) }
            return (eventFromFeed, nil)
        } else if feed.feedType == FeedType.friendsFollowingVenue.rawValue {
            guard let venueFromFeed = Venue(with: feedJson) else { return (nil, nil)}
            return (nil, venueFromFeed)
        } else {
            return (nil, nil)
        }
    }
}
