//
//  LocationManager.swift
//  sowhat
//
//  Created by a on 2/15/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation:CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        //request location access
        requestLocationAccess()
    }
    
    //MARK: Permission
    func requestLocationAccess() {
        
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
        } else {
            print("we have location manager")
        }
    }
    
    func startUpdating() {
        locationManager!.startUpdatingLocation()
    }
    
    func stopUpdating() {
        
        if locationManager != nil {
            locationManager!.stopUpdatingLocation()
        }
    }
    
    //: MARK: - Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last!.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if #available(iOS 14.0, *) {
            if manager.authorizationStatus == .notDetermined {
                self.locationManager!.requestWhenInUseAuthorization()
            }
        }
    }
}
