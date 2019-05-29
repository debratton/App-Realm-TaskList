//
//  CategoryVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UIViewController {

    @IBOutlet weak var searchBarBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var modeSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var categories: Results<Category>?
    var searchController = UISearchController(searchResultsController: nil)
    var mode = "Categories"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        loadCategories(searchString: "")
    }
    
    func loadCategories(searchString: String) {
        if let fetchedCategories = Helper.searchCategories(searchString: searchString) {
            categories = fetchedCategories
            tableView.reloadData()
        }
    }
    
    @IBAction func modeItemSwitchPressed(_ sender: UISwitch) {
        if modeSwitch.isOn == true {
            mode = "Categories"
            tableView.reloadData()
        } else {
            mode = "Items"
            tableView.reloadData()
        }
    }
    
    @IBAction func searchBarBtnPressed(_ sender: UIBarButtonItem) {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Categories..."
        definesPresentationContext = true
        self.present(searchController, animated: true, completion: nil)
    }
}

extension CategoryVC: SetSwitchState {
    func changeImportantSwitch(_ sender: CategoryCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let category = categories![indexPath!.row]
        let updateCategory = Category()
        updateCategory.categoryID = category.categoryID
        updateCategory.name = category.name
        updateCategory.completed = category.completed
        if isOn == true {
            //Helper.updateSwitchCategory(category: category, passedSwitch: "Important", passedValue: true)
            updateCategory.important = true
        } else {
            //Helper.updateSwitchCategory(category: category, passedSwitch: "Important", passedValue: false)
            updateCategory.important = false
        }
        Helper.updateCategory(category: updateCategory)
        loadCategories(searchString: "")
    }
    
    func changeDoneSwitch(_ sender: CategoryCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let category = categories![indexPath!.row]
        let updateCategory = Category()
        updateCategory.categoryID = category.categoryID
        updateCategory.name = category.name
        updateCategory.important = category.important
        if isOn == true {
            //Helper.updateSwitchCategory(category: category, passedSwitch: "Completed", passedValue: true)
            updateCategory.completed = true
        } else {
            //Helper.updateSwitchCategory(category: category, passedSwitch: "Completed", passedValue: false)
            updateCategory.completed = false
        }
        Helper.updateCategory(category: updateCategory)
        loadCategories(searchString: "")
    }
}

extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Mode: \(mode)"
        label.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numRows = categories {
            return numRows.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCategory: Category
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        if categories![indexPath.row].completed == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        currentCategory = categories![indexPath.row]
        cell.configureCell(category: currentCategory)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let categoryToDelete = categories {
                let selectedCategory = categoryToDelete[indexPath.row]
                Helper.deleteCategory(category: selectedCategory)
                loadCategories(searchString: "")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == "Categories" {
            let selectedCategory = categories![indexPath.row]
            performSegue(withIdentifier: "EditCategory", sender: selectedCategory)
            searchController.isActive = false
        }
        
        if mode == "Items"  {
            let selectedCategory = categories![indexPath.row]
            performSegue(withIdentifier: "GoToItems", sender: selectedCategory)
            searchController.isActive = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditCategory" {
            if let destinationVC = segue.destination as? AddEditCategoryVC {
                let mode = "Edit"
                destinationVC.mode = mode
                if let passedCategory = sender as? Category {
                    destinationVC.passedCategory = passedCategory
                }
            }
        }
        
        if segue.identifier == "GoToItems" {
            if let destinationVC = segue.destination as? ItemVC {
                if let passedCategory = sender as? Category {
                    destinationVC.passedCategory = passedCategory
                }
            }
        }
    }
}

extension CategoryVC: UISearchBarDelegate, UISearchResultsUpdating {
    //MARK: Search Button
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.count == 0 {
                loadCategories(searchString: "")
                DispatchQueue.main.async {
                    searchController.resignFirstResponder()
                }
            } else {
                if let searchText = searchController.searchBar.text {
                    loadCategories(searchString: searchText)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            loadCategories(searchString: searchText)
        }
    }
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = searchBar.text {
            if searchString.count == 0 {
                loadCategories(searchString: "")
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else {
                if let searchText = searchBar.text {
                    loadCategories(searchString: searchText)
                }
            }
        }
    }
}
