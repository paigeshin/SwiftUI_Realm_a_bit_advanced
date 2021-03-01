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
