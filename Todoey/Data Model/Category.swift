//
//  Category.swift
//  Todoey
//
//  Created by Juan Martin Giusti on 5/15/19.
//  Copyright © 2019 Juan Martin Giusti. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    var items = List<Item>()
}
