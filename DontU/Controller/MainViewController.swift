//
//  ControlRoomViewController.swift
//  dontu
//
//  Created by nanna on 19/08/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation
import UserNotifications

class MainViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var debugText: UITextView!
    
    // private var isArmed: Bool = false;
    private var numberOfArmedDevices = 0
    private var location: Location?
    private var currentAudioRouteUid: String?
    private var scheduler: Scheduler?
    
    @IBOutlet weak var btnChild: RoundButton!
    @IBOutlet weak var btnPet: RoundButton!
    @IBOutlet weak var btnOther: RoundButton!
    
    
    // @IBOutlet weak var debug: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init a singleton location service
        location = Location.sharedInstance
        location?.locationManager.delegate = self
        
        // used to setup the alarm
        scheduler = Scheduler()
        
        // used to check changes in AudioRoute and enable/disable buttons
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleRouteChange),
                                       name: AVAudioSession.routeChangeNotification,
                                       object: nil)
        
        debugText.isHidden = !Global.debug
        
        // create a new style
        var style = ToastStyle()

        // this is just one of many style options
        style.messageColor = .orange

        // or perhaps you want to use this style for all toasts going forward?
        // just set the shared style and there's no need to provide the style again
        ToastManager.shared.style = style

        // toggle "tap to dismiss" functionality
        ToastManager.shared.isTapToDismissEnabled = true

        // toggle queueing behavior
        ToastManager.shared.isQueueEnabled = false
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if numberOfArmedDevices > 0 {
            // create a new style
            var style = ToastStyle()
            
            // this is just one of many style options
            style.messageColor = .green
            
            self.view.makeToast("App resumed (running)...", duration: 3.0, position: .bottom, style: style)
            startLocation()
        }else{
            _ = self.isValidBluetoothConnection()
        }
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if numberOfArmedDevices > 0 {
            alert(message: "App is now paused. Return to main window to resume")
            stopLocation()
        }
    }
    
    @IBAction func EnableChildControl(_ sender: UIButton) {
        changeState(sender)
    }

    @IBAction func EnablePetControl(_ sender: UIButton) {
        changeState(sender)
    }

    @IBAction func EnableOtherControl(_ sender: UIButton) {
        changeState(sender)
    }
    
    
    func isValidBluetoothConnection() -> Bool{
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        let portName = userDefaults.object(forKey: "PortName") as? String
        if location?.isUpdatingLocation == false{
            if uid == nil || uid == ""{
                self.view.makeToast("No Bluetooh connection configued yet. Select one in settings", duration: 5.0, position: .bottom)
                
                return false
            }

            if Route.isValidConnection() == false{
                self.view.makeToast("\(portName!) Audio Bluetooh is now disconnected.\nConnect to \(portName!) or select another one from Settings", duration: 3.0, position: .bottom)
                
                return false
            }else{
                // create a new style
                var style = ToastStyle()

                // this is just one of many style options
                style.messageColor = .green
                self.view.makeToast("Connected to \(Route.getPortName()!).", duration: 3.0, position: .bottom, style: style)
            }
        }
        return true
    }
    
    
    private func changeState(_ sender: UIButton)
    {
        if location?.isUpdatingLocation == false{
            if isValidBluetoothConnection() == false{
                return
            }
        }
        
        // read current audio route
        currentAudioRouteUid = Route.getUid()
        
        // manage button state and arm the app
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            sender.backgroundColor = UIColor.orange
            numberOfArmedDevices += 1
        }
        else
        {
            sender.backgroundColor = UIColor.white
            numberOfArmedDevices -= 1
        }
        
        // start GPS
        if numberOfArmedDevices > 0 {
            startLocation()
        }else{
            stopLocation()
        }
        
        
    }
    
    
    func startLocation() -> Void {
        // device is armed: start GPS localization
        d("start GPS")
        let userDefaults = UserDefaults.standard
        let distances: [Int] = [3, 5, 8, 13, 21]
        let index = userDefaults.integer(forKey: "Distance")
        d("\(distances[index])")
        
        location?.setDistanceFilter(distance: distances[index])
        location?.startUpdatingLocation()
    }
    
    func stopLocation(){
        // device is disarmed: stop GPS localization
        d("stop GPS")
        location?.stopUpdatingLocation()
    }
    
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            // @todo TBE
            debugText.text += "loc: (\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)) +\n"
            d("current: \(String(describing: currentAudioRouteUid)) Route.getUid(): \(String(describing: Route.getUid()))")
            
            
            if currentAudioRouteUid != nil && currentAudioRouteUid != Route.getUid(){
                // set the alarm
                scheduler?.scheduleNotification()
                // reset current route UID
                currentAudioRouteUid = Route.getUid()
            }
        }
    }
    
    
    @objc func handleRouteChange(_ notification: Notification) {
        DispatchQueue.main.async {
            self.isValidBluetoothConnection()
        }
    }
    
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
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
