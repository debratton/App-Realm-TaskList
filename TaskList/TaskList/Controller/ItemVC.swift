//
//  ItemVC.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import UIKit
import RealmSwift

class ItemVC: UIViewController {

    @IBOutlet weak var searchBarBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var passedCategory: Category?
    var items: Results<Item>?
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        loadItems(searchString: "")
    }
    
    func loadItems(searchString: String) {
        if let category = passedCategory{
            if let fetchedItems = Helper.searchItems(passedCategory: category, searchString: searchString){
                items = fetchedItems
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchBarBtnPressed(_ sender: UIBarButtonItem) {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Items..."
        definesPresentationContext = true
        self.present(searchController, animated: true, completion: nil)
    }
}

extension ItemVC: AddNewItem {
    func addItem(item: Item) {
        if let category = passedCategory {
            Helper.saveItem(category: category, item: item)
        }
        loadItems(searchString: "")
    }
}

extension ItemVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        if let name = passedCategory?.name {
            label.text = "Category: \(name)"
        }
        label.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numRows = items {
            return numRows.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentItem: Item
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        
        if items![indexPath.row].completed == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        currentItem = items![indexPath.row]
        cell.configureCell(item: currentItem)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let itemToDelete = items {
                let selectedItem = itemToDelete[indexPath.row]
                Helper.deleteItem(item: selectedItem)
                loadItems(searchString: "")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items![indexPath.row]
        performSegue(withIdentifier: "EditItem", sender: selectedItem)
        searchController.isActive = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditItem" {
            if let destinationVC = segue.destination as? AddEditItemVC {
                let mode = "Edit"
                destinationVC.mode = mode
                if let passedItem = sender as? Item {
                    destinationVC.passedItem = passedItem
                }
            }
        }
        
        if segue.identifier == "AddItem" {
            if let destinationVC = segue.destination as? AddEditItemVC {
                destinationVC.delegate = self
            }
        }
    }
}

extension ItemVC: SetItemSwitchState {
    func changeImportantSwitch(_ sender: ItemCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let item = items![indexPath!.row]
        let updateItem = Item()
        updateItem.itemID = item.itemID
        updateItem.name = item.name
        updateItem.completed = item.completed
        if isOn == true {
            updateItem.important = true
        } else {
            updateItem.important = false
        }
        Helper.updateItem(item: updateItem)
        loadItems(searchString: "")
    }
    
    func changeCompletedSwitch(_ sender: ItemCell, isOn: Bool) {
        let indexPath = self.tableView.indexPath(for: sender)
        let item = items![indexPath!.row]
        let updateItem = Item()
        updateItem.itemID = item.itemID
        updateItem.name = item.name
        updateItem.important = item.important
        if isOn == true {
            updateItem.completed = true
        } else {
            updateItem.completed = false
        }
        Helper.updateItem(item: updateItem)
        loadItems(searchString: "")
    }
}

extension ItemVC: UISearchBarDelegate, UISearchResultsUpdating {
    //MARK: Search Button
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.count == 0 {
                loadItems(searchString: "")
                DispatchQueue.main.async {
                    searchController.resignFirstResponder()
                }
            } else {
                if let searchText = searchController.searchBar.text {
                    loadItems(searchString: searchText)
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            loadItems(searchString: searchText)
        }
    }
    
    //MARK: Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchString = searchBar.text {
            if searchString.count == 0 {
                loadItems(searchString: "")
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else {
                if let searchText = searchBar.text {
                    loadItems(searchString: searchText)
                }
            }
        }
    }
}
