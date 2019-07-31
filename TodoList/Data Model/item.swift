//
//  item.swift
//  TodoList
//
//  Created by xdMM20181201 on 31/07/19.
//  Copyright © 2019 xdMM20181201. All rights reserved.
//

import Foundation

class Item :Encodable,Decodable{
    var title:String = ""
    var done:Bool = false
}
