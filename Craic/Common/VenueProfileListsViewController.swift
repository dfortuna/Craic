//
//  VenueProfileListsViewController.swift
//  Craic
//
//  Created by Denis Fortuna on 13/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

struct GenericSearch <T:FIRObjectProtocol> {
    var firebaseCollection: FIRCollectionsReference
    var returningType: T.Type
    var fields: String?
    var keyword: String?
    var loggedUser: User
    var searchType: SearchType
    var isSortingByFriends: Bool
}


class VenueProfileListsViewController<T:FIRObjectProtocol>: UIViewController {
    
//MARK: - Variables
    
    private var searchData: GenericSearch<T>?
    @IBOutlet weak var genericListUIView: GenericListUIView!

//MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        genericListUIView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }

//MARK: - Logic
    func setData(fromGenericSearchData genericSearch: GenericSearch<T>) {
        self.searchData = genericSearch
    }
    
    private func fetchData() {
        guard let sd = searchData else { return }
        genericListUIView.fetchData(firebaseCollection: sd.firebaseCollection,
                                    returningType: sd.returningType,
                                    fields: sd.fields,
                                    keyword: sd.keyword,
                                    forUser: sd.loggedUser,
                                    searchType: sd.searchType,
                                    isSortingByFriends: sd.isSortingByFriends)
    }
}

//MARK: - GenericListUIViewDelegate
extension VenueProfileListsViewController: GenericListUIViewDelegate {
    func didTapGenericCell(sender: GenericListUIView) {
        let (user, venue, event) = sender.getCellTappedResultData()
        if let user = user {
            
        }
        if let venue = venue {
            
        }
        if let event = event {
            
        }
    }
}
