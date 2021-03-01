//
//  ShoppingItem.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import Foundation

struct ShoppingItem: Identifiable {
    let id: Int
    let title: String
    let notes: String
    let bought: Bool
    let quantity: Int
}

// MARK: - init
// DB Item을 mapping 해준다. 
extension ShoppingItem {
    
    init(shoppignItemDB: ShoppingItemDB) {
        id = shoppignItemDB.id
        title = shoppignItemDB.title
        notes = shoppignItemDB.notes
        bought = shoppignItemDB.bought
        quantity = shoppignItemDB.quantity
    }
    
}

