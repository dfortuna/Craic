//
//  GenericTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 16/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

protocol GenericCellDelegate: class {
    func handleCategory(sender: GenericTableViewCell)
}

class GenericTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pickedItemTextField: UITextField!
    var picker = UIPickerView()
    var range = [String]()
    var currentOption = ""
    weak var delegate: GenericCellDelegate?
    
    func formatUI(labelText: String, list: [String], currentOption: String?) {
        if let option = currentOption {
            pickedItemTextField.text = option
        } else {
            pickedItemTextField.placeholder = "-- Select --"
        }
        descriptionLabel.text = labelText
        range = list
        createPicker()
        createToolBar()
    }
    
    func createPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        pickedItemTextField.inputView = categoryPicker
    }
    
    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self,
                                         action: #selector(self.doneButtonCategoriesPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        pickedItemTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonCategoriesPicker() {
        endEditing(true)
    }
}

extension GenericTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return range[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return range.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentOption = range[row]
        pickedItemTextField.text = range[row]
        delegate?.handleCategory(sender: self)
    }
}
