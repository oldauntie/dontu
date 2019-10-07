//
//  LocaitonService.swift
//  DontU
//
//  Created by nanna on 06/10/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate{
    
    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    // var locationDataArray: [CLLocation]
    // var useFilter: Bool
    
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        // locationDataArray = [CLLocation]()
        
        // useFilter = true
        
        super.init()
        
        locationManager.delegate = self
        
    }
    
    
    func startUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            // show an error
            d("ERRORE")
        }
    }
    
    func stopUpdatingLocation(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
        }else{
            // show an error
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            // print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
        }
    }
}
