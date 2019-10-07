//
//  DebugViewController.swift
//  DontU
//
//  Created by nanna on 05/10/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

class DebugViewController: UIViewController, CLLocationManagerDelegate {

    private var location: LocationService?
    
    @IBOutlet weak var timeLabel: UITextField!
   
    @IBOutlet weak var debugText: UITextView!
    // var currentTime: Date?
    // private var time: Date?
    
    @IBOutlet weak var updateRoute: UILabel!
    
    /*
    func fetch(_ completion: () -> Void) {
      time = Date()
      completion()
    }
    */
    func updateUI() {
        guard updateRoute != nil  else {
            return
        }
        // updateRoute.text = getCurrentRoute()
        updateRoute.text = Route.getUid()
        d(Route.getUid())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location = LocationService.sharedInstance
        
        location?.locationManager.delegate = self
        
        location?.startUpdatingLocation()
        
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            print("loc: (\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
            debugText.text! += "loc: (\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude)) \n"
        }
    }
    
    @IBAction func didUpdateRoute(_ sender: Any) {
        d("premuteo")
        updateUI()
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

