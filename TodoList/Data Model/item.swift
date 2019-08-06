//
//  Item.swift
//  TodoList
//
//  Created by xdMM20181201 on 05/08/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
