//
//  LogoffTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 7/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

protocol LogoffDelegate: class {
    func handleLogoff(sender: LogoffTableViewCell)
}

class LogoffTableViewCell: UITableViewCell {

    weak var delegate: LogoffDelegate?

    @IBAction func logoffButton(_ sender: UIButton) {
        delegate?.handleLogoff(sender: self)
    }
}
