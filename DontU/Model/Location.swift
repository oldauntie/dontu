//  Created by Old Auntie (www.oldauntie.org).
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import Foundation
import CoreLocation

class Location: NSObject, CLLocationManagerDelegate{
    
    public static var sharedInstance = Location()
    let locationManager: CLLocationManager
    
    var isUpdatingLocation = false
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func setDistanceFilter(distance: Int) -> Void{
        locationManager.distanceFilter = CLLocationDistance(distance)
    }
    
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            isUpdatingLocation = true
        }else{
            // show an error
            d("ERROR")
        }
    }
    
    func stopUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
            isUpdatingLocation = false
        }else{
            // show an error
            d("ERROR")
        }
    }
}
