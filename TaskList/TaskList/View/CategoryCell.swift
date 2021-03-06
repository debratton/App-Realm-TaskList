//
//  CategoryCell.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

protocol SetSwitchState {
    func changeImportantSwitch(_ sender: CategoryCell, isOn: Bool)
    func changeDoneSwitch(_ sender: CategoryCell, isOn: Bool)
}

class CategoryCell: UITableViewCell {

    var delegate: SetSwitchState!
    
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBAction func importantSwitchPressed(_ sender: UISwitch) {
        delegate.changeImportantSwitch(self, isOn: importantSwitch.isOn)
    }
    
    @IBAction func completedSwitchPressed(_ sender: UISwitch) {
        delegate.changeDoneSwitch(self, isOn: completedSwitch.isOn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(category: Category) {
        if category.important == true {
            categoryLabel.text = "\(category.name)❗️"
        } else {
            categoryLabel.text = "\(category.name)"
        }
        
        if category.important == true {
            importantSwitch.isOn = true
        } else {
            importantSwitch.isOn = false
        }
        
        if category.completed == true {
            completedSwitch.isOn = true
        } else {
            completedSwitch.isOn = false
        }
    }
}
