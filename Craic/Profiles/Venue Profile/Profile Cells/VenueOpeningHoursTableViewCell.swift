//
//  VenueOpeningHoursTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 11/4/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class VenueOpeningHoursTableViewCell: UITableViewCell {

    @IBOutlet weak var openingTimeLabel: UILabel!
    
    func formatUI(forVenue venue: Venue) {
        let list = formatList(forHours: venue.openingHours)
        openingTimeLabel.text = list
    }
    
    func formatList(forHours hours: String) -> String {
        var flags = ""
        var formatedDay = ""
        var formatedWeek = ""
        var previousLetter = ""

        for t in hours {
            
            if t.isLetter {
                flags = flags + "L"
            } else if t.isNumber {
                flags = flags + "N"
            } else if t == " " {
                flags = flags + "S"
            }
            
            formatedDay = formatedDay + previousLetter
            
            var lastFlags = ""
            if flags.count >= 3 {
                var consumableFlags = flags
                for _ in 1...3 {
                    if let lf = consumableFlags.popLast() {
                        lastFlags = lastFlags + String(lf)
                    }
                }

                if lastFlags == "LSN" {
                    formatedWeek += "\(formatedDay)" + "\n"
                    formatedDay = ""
                }
            }
            previousLetter = String(t)
        }
        formatedWeek += formatedDay
        return formatedWeek
    }
    
}
