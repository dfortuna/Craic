//
//  eventProfilePicturesTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 9/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventProfilePicturesTableViewCell: UITableViewCell {
    
    private var picturesCollectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var pictures = [String]()
    
    func formatUI(pictures: [String: String]){
        self.backgroundColor = .orange
        self.pictures = Array(pictures.values)
        configureCollectionView()
        configurePageControl()
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        let coll = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        picturesCollectionView = coll
        self.addSubview(picturesCollectionView)
        picturesCollectionView.anchorEdges(top: self.topAnchor,
                                           left: self.leftAnchor,
                                           right: self.rightAnchor,
                                           bottom: self.bottomAnchor, padding: .zero)
        picturesCollectionView.delegate = self
        picturesCollectionView.dataSource = self
        picturesCollectionView.backgroundColor = .purple
        picturesCollectionView.showsHorizontalScrollIndicator = false
        picturesCollectionView.isPagingEnabled = true
        picturesCollectionView.register(HorizontalDisplayCollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalDisplayCollectionViewCell")
    }
    
    func configurePageControl() {
        let pc = UIPageControl()
        pc.numberOfPages = pictures.count
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = Colors.mainColor
        pc.pageIndicatorTintColor = Colors.lightBackgroundColor
        pageControl = pc
        self.addSubview(pageControl)
        pageControl.anchorEdges(top: nil, left: nil, right: nil, bottom: self.bottomAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        pageControl.anchorCenters(centerX: centerXAnchor, centerY: nil)
    }
}

extension EventProfilePicturesTableViewCell: UICollectionViewDelegate {
    
}

extension EventProfilePicturesTableViewCell: UICollectionViewDataSource {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / picturesCollectionView.frame.width)
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalDisplayCollectionViewCell", for: indexPath) as! HorizontalDisplayCollectionViewCell
        let picture = pictures[indexPath.row]
        cell.formatUI(picture: picture)
        return cell
    }
}

extension EventProfilePicturesTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: picturesCollectionView.frame.width,
                      height: picturesCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    } 
}
