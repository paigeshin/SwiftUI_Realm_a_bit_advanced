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
