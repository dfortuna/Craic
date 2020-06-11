//
//  MessageDetailUIViewController.swift
//  Project4
//
//  Created by Denis Fortuna on 15/3/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI(message: Message) {
        senderUILabel.text = message.senderName
        dateTimeUILabel.text = message.date
        titleUILabel.text = message.title
        longMessageUITextView.text = message.longMessage
    }
    
    @IBOutlet weak var senderUILabel: UILabel!
    @IBOutlet weak var dateTimeUILabel: UILabel!
    @IBOutlet weak var titleUILabel: UILabel!
    @IBOutlet weak var longMessageUITextView: UITextView!
     
}
