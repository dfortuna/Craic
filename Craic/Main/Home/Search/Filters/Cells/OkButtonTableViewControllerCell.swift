//
//  OkButtonTableViewControllerCell.swift
//  Project4
//
//  Created by Denis Fortuna on 31/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

protocol OkButtonCellDelegate: class {
    func handleOkButton(sender: OkButtonTableViewControllerCell)
}

class OkButtonTableViewControllerCell: UITableViewCell {
    
    weak var delegate: OkButtonCellDelegate?
    @IBAction func okButton(_ sender: UIButton) {
        delegate?.handleOkButton(sender: self)
    }
}
