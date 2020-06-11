//
//  FeedCollectionViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 9/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var eventProfileImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateBluredView: UIView!
    
    @IBAction func shareButton(_ sender: UIButton) {
        
    }
    
    func formatUI(feed: Feed, cellWidth: CGFloat){
        
    }
}
