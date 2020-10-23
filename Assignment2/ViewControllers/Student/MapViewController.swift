//
//  MapViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 16/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    var StringLocation : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r = MKLocalSearch.Request()
        r.naturalLanguageQuery = StringLocation
        
        let search = MKLocalSearch (request : r)
        search.start { (response, error) in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            let region = MKCoordinateRegion(center: response.boundingRegion.center, latitudinalMeters: 5000, longitudinalMeters: 5000)
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 4000)
                        
            self.map.setCameraZoomRange(zoomRange, animated: true)
            self.map.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
            self.map.setCenter(response.boundingRegion.center, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = response.boundingRegion.center
            self.map.addAnnotation(annotation)
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
