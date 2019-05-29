//
//  Category.swift
//  TaskList
//
//  Created by David E Bratton on 5/25/19.
//  Copyright © 2019 David Bratton. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var categoryID = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var important: Bool = false
    @objc dynamic var completed: Bool = false
    let items = List<Item>()
    
    override static func primaryKey() -> String? {
        return "categoryID"
    }
}
