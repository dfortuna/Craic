//
//  GenericListUIView.swift
//  Craic
//
//  Created by Denis Fortuna on 11/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

enum SearchType {
    case users
    case events
    case venues
}

protocol GenericListUIViewDelegate: class {
    func handleAddAsFavorite(sender:GenericListUIView)
}

class GenericListUIView: UIView {
    
    private var gLCollectionView: UICollectionView?
    private var searchType = SearchType.users
    private let firebaseService = FirebaseService.shared
    private var firebaseCollection = FIRCollectionsReference.event
    private var keyword: String?
    private var field: String?
    private var returningType: FIRObjectProtocol?
    private var resultList = [FIRObjectProtocol]() {
        didSet {
            
        }
    }

    init() {
        super.init(frame: CGRect())
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initializeSubviews(){
        let glCollView = UICollectionView()
        glCollView.frame = self.bounds
        gLCollectionView = glCollView
        self.addSubview(gLCollectionView!)
//        gLCollectionView?.delegate = self
//        gLCollectionView?.dataSource = self
    }
    
    func registerCells() {
        gLCollectionView?.register(UINib(nibName: "UserCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "UserCollectionViewCell")
        gLCollectionView?.register(UINib(nibName: "EventCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "EventCollectionViewCell")
        gLCollectionView?.register(UINib(nibName: "VenueCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "VenueCollectionViewCell")
    }
}

//extension GenericListUIView: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//}
//
//extension GenericListUIView: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//}
//
//extension GenericListUIView: UICollectionViewDelegateFlowLayout {
//
//}
