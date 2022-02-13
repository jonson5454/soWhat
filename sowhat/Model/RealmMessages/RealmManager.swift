//
//  RealmManager.swift
//  sowhat
//
//  Created by Ghulam Mujtaba on 12/02/2022.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    let realm = try! Realm()
    
    func saveToRealm<T: Object>(_ object:T) {
        
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            print("Error save to realm,", error.localizedDescription)
        }
    }
     
}
