//
//  ShoppingItemDB.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import Foundation
import RealmSwift

class ShoppingItemDB: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var notes = ""
    @objc dynamic var quantity = 1
    @objc dynamic var bought = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}

enum ShoppingItemDBKeys: String {
    case id = "id"
    case title = "title"
    case notes = "notes"
    case quantity = "quantity"
    case bought = "bought"
}
