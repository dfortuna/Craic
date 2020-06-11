//
//  EventCategoryTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 16/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

protocol EventCategoryDelegate: class {
    func handleCategory(sender: EventCategoryTableViewCell)
}

class EventCategoryTableViewCell: UITableViewCell {

    var categories = [String]()
    weak var delegate: EventCategoryDelegate?
    var currentCategory = ""

    @IBOutlet weak var searchCategoryTextField: UITextField!
    @IBOutlet weak var categoryImageView: UIImageView!

    func formatUI(categoryLabel: String, categoryList: [String], category: String?) {
        categories = categoryList
        currentCategory = categoryLabel
        
        if let category = category {
            searchCategoryTextField.text = category
        } else {
            searchCategoryTextField.placeholder = "-- Select --"
        }
        
        createCategoryPicker()
        createToolBar()
    }
    
    func createCategoryPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        searchCategoryTextField.inputView = categoryPicker
    }
    
    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self,
                                         action: #selector(self.doneButtonCategoriesPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        searchCategoryTextField.inputAccessoryView = toolbar
    }

    @objc func doneButtonCategoriesPicker() {
        endEditing(true)
    }

    func setCategoryIcon(category: String) {
        if category != "-- Select --" {
            categoryImageView.image = UIImage(named: category)
            categoryImageView.tintColor = UIColor.red
            currentCategory = category
            searchCategoryTextField.text = category
        }
    }
}

extension EventCategoryTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = categories[row]
        setCategoryIcon(category: selected)
        delegate?.handleCategory(sender: self)
    }
}
