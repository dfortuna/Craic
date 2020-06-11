//
//  PriceTableViewCell.swift
//  Project4
//
//  Created by Denis Fortuna on 16/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import UIKit

protocol PriceTableViewCellDelegate: class {
    func handleprice(sender: PriceTableViewCell)
}

class PriceTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    var priceRange = [String]()
    var pricePicker = UIPickerView()
    weak var delegate: PriceTableViewCellDelegate?
    var currentPrice = ""
    
    func formatUI(currentPrice: String?, list: [String]) {
        priceRange = list
        setprice(price: currentPrice)
        createPicker()
        createToolBar()
    }
    
    func setprice(price: String?) {
        if let price = price {
            currentPrice = price
            priceRangeTextField.text = price
            switch price {
            case "Free":
                priceDollarLabel.text =  "Free"
            case "Up to $20":
                priceDollarLabel.text =  "$"
            case "$21 - $100":
                priceDollarLabel.text =  "$$"
            case "$101 - $200":
                priceDollarLabel.text =  "$$$"
            case "$200+":
                priceDollarLabel.text =  "$$$$"
            default:
                priceDollarLabel.text =  "???"
            }
        } else {
            currentPrice = ""
            priceRangeTextField.placeholder = "-- Select --"
        }
    }
    
    @IBOutlet weak var priceRangeTextField: UITextField!
    @IBOutlet weak var priceDollarLabel: UILabel!
    
    func createPicker() {
        let categoryPicker = UIPickerView()
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        priceRangeTextField.inputView = categoryPicker
    }
    
    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self,
                                         action: #selector(self.doneButtonCategoriesPicker))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        priceRangeTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonCategoriesPicker() {
        endEditing(true)
    }
}

extension PriceTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priceRange[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priceRange.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = priceRange[row]
        setprice(price: selected)
        delegate?.handleprice(sender: self)
    }
}
