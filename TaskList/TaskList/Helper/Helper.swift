//
//  Helper.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import Foundation
import RealmSwift

class Helper {
    static let realm = try! Realm()
    
    static func searchCategories(searchString: String) -> Results<Category>? {
        var categories: Results<Category>?
        categories = realm.objects(Category.self)
        if searchString != "" {
            let searchedCategories = categories?.filter("name CONTAINS[cd] %@", searchString).sorted(byKeyPath: "name", ascending: true)
            let sortedCategories = searchedCategories?.sorted(byKeyPath: "name", ascending: true)
            return sortedCategories
        } else {
            let sortedCategories = categories?.sorted(byKeyPath: "name", ascending: true)
            return sortedCategories
        }
    }
    
    static func searchItems(passedCategory: Category, searchString: String) -> Results<Item>? {
        if searchString != "" {
            let searchedItems = passedCategory.items.filter("name CONTAINS[cd] %@", searchString).sorted(byKeyPath: "name", ascending: true)
            return searchedItems
        } else {
            let searchedItems = passedCategory.items.sorted(byKeyPath: "name", ascending: true)
            return searchedItems
        }
    }
    
    static func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category: \(error.localizedDescription)")
        }
    }
    
    static func saveItem(category: Category, item: Item) {
        do {
            try realm.write {
                category.items.append(item)
            }
        } catch {
            print("Error Saving Item: \(error.localizedDescription)")
        }
    }
    
    static func updateCategory(category: Category) {
        let categoryID = category.categoryID
        let name = category.name
        let important = category.important
        let completed = category.completed
        do {
            try realm.write {
                realm.create(Category.self,
                             value: ["categoryID": categoryID,
                                     "name": name,
                                     "important": important,
                                     "completed": completed],
                             update: true)
            }
        } catch {
            print("Error Updating Category: \(error.localizedDescription)")
        }
    }
    
    static func updateItem(item: Item) {
        let itemID = item.itemID
        let name = item.name
        let important = item.important
        let completed = item.completed
        do {
            try realm.write {
                realm.create(Item.self,
                             value: ["itemID": itemID,
                                     "name": name,
                                     "important": important,
                                     "completed": completed],
                             update: true)
            }
        } catch {
            print("Error Updating Item: \(error.localizedDescription)")
        }
    }
    
    static func deleteCategory(category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        } catch {
            print("Error Deleting Category: \(error.localizedDescription)")
        }
    }
    
    static func deleteItem(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error Deleting Item: \(error.localizedDescription)")
        }
    }
}
