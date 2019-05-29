//
//  AddEditCategoryVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

class AddEditCategoryVC: UIViewController {

    @IBOutlet weak var categoryNameText: UITextField!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    var passedCategory: Category?
    var mode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if mode == "Edit" {
            self.title = "Edit - Category"
        }
        if let editCategory = passedCategory {
            categoryNameText.text = editCategory.name
            if editCategory.important == true {
                importantSwitch.isOn = true
            } else {
                importantSwitch.isOn = false
            }
            
            if editCategory.completed == true {
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
    
    @IBAction func saveCategoryBtnPressed(_ sender: UIBarButtonItem) {
        if mode == "Edit" {
            if categoryNameText.text != "" {
                if let passedCategory = passedCategory {
                    let updateCategory = Category()
                    updateCategory.categoryID = passedCategory.categoryID
                    updateCategory.name = categoryNameText.text!
                    updateCategory.important = importantSwitch.isOn
                    updateCategory.completed = completedSwitch.isOn
                    Helper.updateCategory(category: updateCategory)
                    navigationController?.popViewController(animated: true)
                }
            } else {
                presentAlert(alert: "Category Name is Required!")
            }
        } else {
            if categoryNameText.text != "" {
                let newCategory = Category()
                if let categoryName = categoryNameText.text {
                    newCategory.name = categoryName
                    newCategory.important = importantSwitch.isOn
                    newCategory.completed = completedSwitch.isOn
                    Helper.saveCategory(category: newCategory)
                    navigationController?.popViewController(animated: true)
                }
            } else {
                presentAlert(alert: "Category name is required!!")
            }
        }
    }
    
}

