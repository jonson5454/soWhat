//
//  MapViewController.swift
//  sowhat
//
//  Created by Ghulam Mujtaba on 16/02/2022.
//

import UIKit
import MapKit


class MapViewController: UIViewController {

    //MARK: - Vars
    var location: CLLocation?
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTitle()
        configureMapView()
        configureLeftBarButton()
    }

    //MARK: - Configuration
    private func configureMapView() {
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        mapView.showsUserLocation = true
        
        if location != nil {
            mapView.setCenter(location!.coordinate, animated: false)
            mapView.addAnnotation(MapAnnotation(title: "User Location", coordinate: location!.coordinate))
        }
        
        view.addSubview(mapView)
    }
    
    private func configureTitle() {
        self.title = "Map View"
    }
    
    private func configureLeftBarButton() {
        if #available(iOS 13.0, *) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        }
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
