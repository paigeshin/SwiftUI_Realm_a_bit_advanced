//
//  ShoppingFormView.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

struct ShoppingFormView: View {
    
    @EnvironmentObject var store: ShoppingStore //it contains CRUD Model
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var form: ShoppingForm //view model
    let quantityOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $form.title)
                
                Picker(selection: $form.quantity, label: Text("Quantity"), content: {
                    ForEach(quantityOptions, id: \.self) { option in
                        Text("\(option)")
                            .tag(option)
                    }
                })
                
                Section(header: Text("Notes")) {
                    TextField("", text: $form.notes)
                }
                
            }
            .navigationBarTitle("Shopping Form", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel", action: dismiss), trailing: Button("Save", action: save))
            
        }
    }
}

// MARK: - ACTIONS

extension ShoppingFormView {
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func save() {
        if form.updating, let id = form.shoppingItemId {
            store.updateItem(itemId: id, title: form.title, notes: form.notes, quantity: form.quantity)
        } else {
            store.create(title: form.title, notes: form.notes, quantity: form.quantity)
        }
        dismiss()
    }
    
}
