# Sequence

1. Import from [`https://github.com/realm/realm-cocoa.git`](https://github.com/realm/realm-cocoa.git)
2. Initialize Realm
3. Define Realm Database Model with Enum
4. Define Model which maps `Realm Database Model`
5. Define DB Controller which mostly contains `CRUD` MODEL (Named Storage)
6. Define Individual ViewModel

# Realm Import Address

- Framework Import Address

[https://github.com/realm/realm-cocoa.git](https://github.com/realm/realm-cocoa.git)

# Initialize Realm

```swift
//
//  RealmPersistenceInitializer.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import Foundation
import RealmSwift

class RealmPersistent {
    
    static func initializer() -> Realm {
        do {
            let realm = try Realm()
            return realm
        } catch let error {
            fatalError("Failed to open Realm error: \(error.localizedDescription)")
        }
    }
    
}
```

# Model & Enum

- DB Model

```swift
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

// Create enum to avoid mistakes                                                                                                                
enum ShoppingItemDBKeys: String {
    case id = "id"
    case title = "title"
    case notes = "notes"
    case boguht = "bought"
    case quantity = "quantity"
}
```

- Mapping Data Model

```swift
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
```

# Logic

```swift
//
//  ShoppingItemStore.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import Foundation
import RealmSwift

final class ShoppingStore: ObservableObject {
    
    private var itemResults: Results<ShoppingItemDB>
    private var boughtItemResults: Results<ShoppingItemDB>
    
    var items: [ShoppingItem] {
        itemResults.map(ShoppingItem.init)
    }
    
    var boughtItem: [ShoppingItem] {
        boughtItemResults.map(ShoppingItem.init)
    }
    
    init(realm: Realm) {
        itemResults = realm.objects(ShoppingItemDB.self)
            .filter("bought = false")
        
        boughtItemResults = realm.objects(ShoppingItemDB.self)
            .filter("bought = true")
    }
    
    
    
}

// MARK: - CRUD Operations
extension ShoppingStore {
    
    func create(title: String, notes: String, quantity: Int) {
        
        objectWillChange.send()
        
        do {
            let realm = try Realm()
            let shoppingItemDB = ShoppingItemDB()
            shoppingItemDB.id = UUID().hashValue //int value
            shoppingItemDB.title = title
            shoppingItemDB.notes = notes
            shoppingItemDB.quantity = quantity
            
            try realm.write {
                realm.add(shoppingItemDB)
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func updateBuy(shoppingItem: ShoppingItem) {
        
        objectWillChange.send()
        
        do {
            let realm = try Realm()
            try realm.write {
                    realm.create(
                        ShoppingItemDB.self,
                        value: [
                            ShoppingItemDBKeys.id.rawValue: shoppingItem.id,
                            ShoppingItemDBKeys.bought.rawValue: !shoppingItem.bought
                        ],
                        update: .modified
                    )
            }
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func updateItem(itemId: Int, title: String, notes: String, quantity: Int) {
        
        objectWillChange.send()
        
        do {
            let realm = try Realm()
            try realm.write {
                    realm.create(
                        ShoppingItemDB.self,
                        value: [
                            ShoppingItemDBKeys.id.rawValue: itemId,
                            ShoppingItemDBKeys.title.rawValue: title,
                            ShoppingItemDBKeys.notes.rawValue: notes,
                            ShoppingItemDBKeys.quantity.rawValue: quantity
                        ],
                        update: .modified
                    )
            }
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
    func delete(itemId: Int) {
        
        objectWillChange.send()
        
        guard let shoppingItemDB = boughtItemResults.first (where: {$0.id == itemId}) else {
            return
        }
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(shoppingItemDB)
            }
        } catch let err {
            print(err.localizedDescription)
        }
        
    }
    
}
```

# Attach as Environment Object

```swift
//
//  SwiftUI_REALMApp.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

@main
struct SwiftUI_REALMApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ShoppingStore(realm: RealmPersistent.initializer()))
        }
    }
    
}
```

# Define ViewModel

```swift
//
//  ShoppingForm.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import Foundation

class ShoppingForm: ObservableObject {
    
    @Published var title = ""
    @Published var notes = ""
    @Published var quantity = 1
    
    var shoppingItemId: Int?
    
    var updating: Bool {
        shoppingItemId != nil
    }
    
    init() {
        
    }
    
    init(_ shoppingItem: ShoppingItem) {
        shoppingItemId = shoppingItem.id
        title = shoppingItem.title
        notes = shoppingItem.notes
        quantity = shoppingItem.quantity
    }
    
}
```

# Views

### App

```swift
//
//  SwiftUI_REALMApp.swift
//  SwiftUI_REALM
//
//  Created by paige shin on 2021/03/01.
//

import SwiftUI

@main
struct SwiftUI_REALMApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ShoppingStore(realm: RealmPersistent.initializer()))
        }
    }
    
}
```

### ContentView

```swift
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
```

### ListView

```swift
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
```

### RowView

```swift
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
```

### FormView - modal

```swift
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
```