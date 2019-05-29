//
//  Item.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var itemID = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var important: Bool = false
    @objc dynamic var completed: Bool = false
    var category = LinkingObjects(fromType: Category.self, property: "items")
    
    override static func primaryKey() -> String? {
        return "itemID"
    }
}
