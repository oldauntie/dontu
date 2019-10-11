//  Created by Old Auntie (www.oldauntie.org).
//  Copyright © 2019 OldAuntie. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
