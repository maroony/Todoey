//
//  Category.swift
//  Todoey
//
//  Created by Andy on 30.10.18.
//  Copyright © 2018 Andy Schoenemann. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  @objc dynamic var color: String = ""
  let items = List<Item>()
}
