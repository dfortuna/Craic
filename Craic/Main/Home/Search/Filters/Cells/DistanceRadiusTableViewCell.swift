//
//  DistanceRadiusTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 16/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

protocol DistanceRadiusDelegate: class {
    func handleDistance(sender: DistanceRadiusTableViewCell)
}

class DistanceRadiusTableViewCell: UITableViewCell {
    
    weak var delegate: DistanceRadiusDelegate?
    var currentDistance = 0
    @IBOutlet weak var maxDistanceOutlet: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBAction func maxDistanceAction(_ sender: UISlider) {
        distanceLabel.text = "\(Int(sender.value)) km"
    }
    
    @IBAction func maxDistanceTouchUpInside(_ sender: UISlider) {
        currentDistance = Int(sender.value)
        delegate?.handleDistance(sender: self)
    }
    
    func formatUI(distance: String?) {
        let validStringDistance = distance ?? "0.0"
        let floatDistance = Float(validStringDistance) ?? 0.0
        maxDistanceOutlet.setValue(floatDistance, animated: false)
        distanceLabel.text = validStringDistance + " km"
    }
}
