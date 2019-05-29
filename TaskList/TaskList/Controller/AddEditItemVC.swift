//
//  AddEditItemVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/28/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

protocol AddNewItem {
    func addItem(item: Item)
}

class AddEditItemVC: UIViewController {

    @IBOutlet weak var itemNameText: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    var passedItem: Item!
    var mode = ""
    var delegate: AddNewItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == "Edit" {
            self.title = "Edit - Item"
        }
        
        if let editItem = passedItem {
            itemNameText.text = editItem.name
            if editItem.important == true {
                importantSwitch.isOn = true
            } else {
                importantSwitch.isOn = false
            }
            
            if editItem.completed == true {
                completedSwitch.isOn = true
            } else {
                completedSwitch.isOn = false
            }
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
        if mode == "Edit" {
            if itemNameText.text != "" {
                if let passedItem = passedItem {
                    let updateItem = Item()
                    updateItem.itemID = passedItem.itemID
                    updateItem.name = itemNameText.text!
                    updateItem.important = importantSwitch.isOn
                    updateItem.completed = completedSwitch.isOn
                    Helper.updateItem(item: updateItem)
                    navigationController?.popViewController(animated: true)
                }
             }else {
                presentAlert(alert: "Item Name is Required!")
            }
        } else {
            if itemNameText.text != "" {
                let newItem = Item()
                if let itemName = itemNameText.text {
                    newItem.name = itemName
                    newItem.important = importantSwitch.isOn
                    newItem.completed = completedSwitch.isOn
                    delegate!.addItem(item: newItem)
                    navigationController?.popViewController(animated: true)
                }
                
            } else {
                presentAlert(alert: "Item Name is Required!")
            }
        }
    }
    

}
