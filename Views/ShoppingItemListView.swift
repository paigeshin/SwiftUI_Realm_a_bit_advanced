//
//  ShoppingItemListView.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

struct ShoppingItemListView: View {
    
    @EnvironmentObject var store: ShoppingStore
    @State private var shoppingFormPresented = false
    let items: [ShoppingItem]
    let boughtItems: [ShoppingItem]
//    let boughtItems = [ShoppingItem]()
    
    var body: some View {
        List {
            Section(header: Text("Items to shop")) {
                if items.isEmpty {
                    Text("Add some shopping items before you go grocery shopping")
                        .foregroundColor(.gray)
                }
                ForEach (items) { item in
                    ShoppingItemRow(shoppingItem: item)
                }
            }
            
            newItemButton
            
        }
        
        Section(header: Text("Already in cart")) {
            if boughtItems.isEmpty {
                Text("Cart")
            }
            ForEach(boughtItems) { item in
                ShoppingItemRow(shoppingItem: item)
            }
            .onDelete(perform: { indexSet in
                if let idx = indexSet.first {
                    store.delete(itemId: boughtItems[idx].id)
                }
            })
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Grocery Shopper")
        
    }
    
    var newItemButton: some View {
        Button(action: { shoppingFormPresented.toggle() }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add new item")
                    .bold()
            }
        }
        .foregroundColor(.orange)
        .sheet(isPresented: $shoppingFormPresented, content: {
            ShoppingFormView(form: ShoppingForm())
            .environmentObject(store)
        })
    }
    
}
