//
//  EventCollectionViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 2/5/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell, FIRObjectCell {
    
    var event: Event?
    var distance: String!
    var isAttending = false
    weak var delegate: FIRCellButtonProtocol?
    
    @IBOutlet weak var eventProfilePicImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var attendButtonOutlet: UIButton!
    
    @IBAction func attendButton(_ sender: UIButton) {
        isAttending = isAttending == false ? true : false
        setAttendButtonName()
        delegate?.didTapAttendEventButton(sender: self)
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
    
    func formatCellUI(withData cellData: FIRCellInputObj) {
        self.format()
        guard let event = cellData.event else { return }
        self.event = event 
        eventNameLabel.attributedText = formatLabel(labelText: event.name)
        eventPriceLabel.text = event.price
        distanceLabel.text = cellData.distance
        eventDateLabel.text = event.date
        
        formatprofilePicture(event)
        self.isAttending = cellData.isAttending ?? false
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
