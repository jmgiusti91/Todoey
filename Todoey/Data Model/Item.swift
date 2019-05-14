//
//  Item.swift
//  Todoey
//
//  Created by Juan Martin Giusti on 5/14/19.
//  Copyright © 2019 Juan Martin Giusti. All rights reserved.
//

import Foundation

class Item: Encodable {
    var title: String = ""
    var done: Bool = false
}
