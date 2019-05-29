//
//  ItemCell.swift
//  TaskList
//
//  Created by David E Bratton on 5/27/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

protocol SetItemSwitchState {
    func changeImportantSwitch(_ sender: ItemCell, isOn: Bool)
    func changeCompletedSwitch(_ sender: ItemCell, isOn: Bool)
}

class ItemCell: UITableViewCell {

    var delegate: SetItemSwitchState!
    
    @IBOutlet weak var importantLabel: UILabel!
    @IBOutlet weak var importantSwitch: UISwitch!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var completedSwitch: UISwitch!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBAction func importantSwitchPressed(_ sender: UISwitch) {
        delegate.changeImportantSwitch(self, isOn: importantSwitch.isOn)
    }
    
    @IBAction func completedSwitchPressed(_ sender: UISwitch) {
        delegate.changeCompletedSwitch(self, isOn: completedSwitch.isOn)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(item: Item) {
        if item.important == true {
            itemNameLabel.text = "\(item.name)❗️"
        } else {
            itemNameLabel.text = "\(item.name)"
        }
        
        if item.important == true {
            importantSwitch.isOn = true
        } else {
            importantSwitch.isOn = false
        }
        
        if item.completed == true {
            completedSwitch.isOn = true
        } else {
            completedSwitch.isOn = false
        }
    }

}
