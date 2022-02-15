//
//  MapAnnotation.swift
//  sowhat
//
//  Created by Ghulam Mujtaba on 16/02/2022.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
