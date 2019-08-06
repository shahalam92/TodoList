//
//  Category.swift
//  TodoList
//
//  Created by xdMM20181201 on 05/08/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    @objc dynamic var color:String = ""
    var items = List<Item>()
    
}
