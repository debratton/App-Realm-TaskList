//
//  CategoryVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {

    @IBOutlet weak var searchBarBtn: UIBarButtonItem!
    @IBOutlet weak var categoryItemSwitch: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func categoryItemSwitchPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func searchBarBtnPressed(_ sender: UIBarButtonItem) {
    }
    

}

