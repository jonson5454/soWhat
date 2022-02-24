//
//  LocalGallery.swift
//  sowhat
//
//  Created by a on 2/24/22.
//

import Foundation
import RealmSwift

class LocalGallery: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var imageName = ""
    
    convenience init(_ id: String, _ imageName: String) {
        self.init()
        self.id = id
        self.imageName = imageName
    }
}
