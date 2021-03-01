//
//  ContentView.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var store: ShoppingStore
    
    var body: some View {
        NavigationView {
            ShoppingItemListView(items: store.items, boughtItems: store.boughtItems)
        }
    }
}


