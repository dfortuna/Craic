//
//  EventCollectionViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 2/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol EventCollectionViewCellProtocol: class {
    func handleAttendButton(sender:EventCollectionViewCell)
}

class EventCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: EventCollectionViewCellProtocol?
    var currentEvent: Event?
    var isAttending = false
    
    @IBOutlet weak var eventProfilePicImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    @IBOutlet weak var attendButtonOutlet: UIButton!
    @IBAction func attendButton(_ sender: UIButton) {
        isAttending = isAttending == false ? true : false
        setAttendButtonName()
        delegate?.handleAttendButton(sender: self)
    }
    
    fileprivate func formatprofilePicture(_ event: Event) {
        eventProfilePicImageView.image = Icons.eventPictureNotFound
        eventProfilePicImageView.backgroundColor = Colors.darkBackgroundColor
        eventProfilePicImageView.tintColor = Colors.cellLabelColor
        eventProfilePicImageView.contentMode = .center
        if let profilePicString = event.images["0"] {
            if let profImage = URL(string: profilePicString) {
                DispatchQueue.global().async {
                    guard let imagedata2 = try? Data(contentsOf: profImage)  else { return }
                    DispatchQueue.main.async {
                        self.eventProfilePicImageView.image = UIImage(data: imagedata2)
                        self.eventProfilePicImageView.backgroundColor = nil
                        self.eventProfilePicImageView.contentMode = .scaleAspectFill
                    }
                }
            }
        }
    }
    
    fileprivate func setAttendButtonName() {
        if isAttending {
            attendButtonOutlet.formatCustomButtonEnabled(forTitle: "Attending")
        } else {
            attendButtonOutlet.formatCustomButtonDisabled(forTitle: "Attend")
        }
    }
    
    func formatUI(event: Event, isAttending: Bool, distance: String?) {
        self.format()
        currentEvent = event
        eventNameLabel.attributedText = formatLabel(labelText: event.name)
        
        eventPriceLabel.text = event.price
        if let d = distance {
            distanceLabel.text = d
        } else {
            distanceLabel.text = ""
        }
        
        eventDateLabel.text = event.date
        
        formatprofilePicture(event)
        self.isAttending = isAttending
        setAttendButtonName()
    }
    
    func formatLabel(labelText: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [.strokeColor: UIColor.black,
                                                         .foregroundColor: UIColor.white,
                                                         .strokeWidth: -2.0]
        let attributedQuote = NSAttributedString(string: labelText, attributes: attributes)
        return attributedQuote
    }
}
