//
//  ShoppingItemRow.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

struct ShoppingItemRow: View {
    
    @EnvironmentObject var store: ShoppingStore
    @State private var shopppingFormPresented = false
    let shoppingItem: ShoppingItem
    
    var body: some View {
        HStack {
            Button(action: openUpdate, label: {
                Text("\(shoppingItem.quantity)")
                    .bold()
                    .padding(.horizontal, 4)
                
                VStack(alignment: .leading) {
                    Text(shoppingItem.title)
                        .font(.headline)
                    
                    Text(shoppingItem.notes)
                        .font(.subheadline)
                        .lineLimit(1)
                }
            })
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $shopppingFormPresented, content: {
                ShoppingFormView(form: ShoppingForm(self.shoppingItem))
                    .environmentObject(self.store)
            })
            
            Spacer()
            
            Button(action: buyItem, label: {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 20, height: 20)
            })
            
        }
    }
    
}

// MARK: - Actions
extension ShoppingItemRow {
    
    func openUpdate() {
        if !shoppingItem.bought {
            shopppingFormPresented.toggle()
        }
    }
    
    func buyItem() {
        withAnimation {
            if !shoppingItem.bought {
                store.updateBuy(shoppingItem: shoppingItem)
            }
        }
    }
    
}
