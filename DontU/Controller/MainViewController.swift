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
    
    private var isArmed: Bool = false;
    private var numberOfArmedDevices = 0
    private var location: LocationService?
    private var currentAudioRouteUid: String?
    private var scheduler: Scheduler?
    
    @IBOutlet weak var btnChild: RoundButton!
    @IBOutlet weak var btnPet: RoundButton!
    @IBOutlet weak var btnOther: RoundButton!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var debug: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        location = LocationService.sharedInstance
        location?.locationManager.delegate = self
        
        // read current audio route
        currentAudioRouteUid = Route.getUid()
        
        
        scheduler = Scheduler()
    }
    
    /*
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "ContU"
        content.body = "Forget about me..."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        // content.sound = UNNotificationSound.default
        
        let soundName = UNNotificationSoundName("bell.mp3")
        content.sound = UNNotificationSound(named: soundName)

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    */
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            debugText.text += "loc: (\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude)) +\n"
            
            if currentAudioRouteUid != nil && currentAudioRouteUid != Route.getUid(){
                // set the alarm
                scheduler?.scheduleNotification()

                // reset current route UID
                currentAudioRouteUid = Route.getUid()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        btnChild.isEnabled = false
        btnPet.isEnabled = false
        btnOther.isEnabled = false
        if checkBluetoothConnection() == true{
            btnChild.isEnabled = true
            btnPet.isEnabled = true
            btnOther.isEnabled = true
        }
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
    
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    private func changeState(_ sender: UIButton)
    {
        // manage button state and arm the app
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            // sender.setImage(UIImage(named:"pets"), for: UIControl.State.normal);
            sender.backgroundColor = UIColor.orange
            numberOfArmedDevices += 1
            
        }
        else
        {
            // sender.setImage(UIImage(named:"child_friendly"), for: UIControl.State.normal);
            sender.backgroundColor = UIColor.white
            numberOfArmedDevices -= 1
        }
        
        
        if numberOfArmedDevices > 0 {
            // device is armed: start GPS localization
            location?.startUpdatingLocation()
            
        }else{
            // device is disarmed: stop GPS localization
            location?.stopUpdatingLocation()
        }
        
        
    }
    
    private func checkBluetoothConnection2() -> Bool {
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        // let port_name = userDefaults.object(forKey: "UID") as? String
        
        // bluetooth is not configured
        if uid == nil && uid == ""{
                return false
        }
        
        // read current audio route into variable out
        let avsession = AVAudioSession.sharedInstance()
        try! avsession.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetooth)
        try! avsession.setActive(true)
        let route  = avsession.currentRoute
        let out = route.outputs
        
        
        // if current audio connection if a Bluetooth One return true
        for element in out{
            if element.portType == AVAudioSession.Port.bluetoothLE || element.portType == AVAudioSession.Port.bluetoothA2DP || element.portType == AVAudioSession.Port.bluetoothHFP {
                // Is the current Bluetooth connection the one selected in preferences
                if uid == element.uid {
                    return true
                }
            }
        }
        
        return false
    }
    
    
    private func checkBluetoothConnection() -> Bool {
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        // let port_name = userDefaults.object(forKey: "UID") as? String
        
        // bluetooth is not configured
        if uid == nil && uid == ""{
                return false
        }
        
        if Route.isBluetooth(){
            d("bt")
            if Route.getUid() == uid{
                d(" = ")

                return true
            }else{
                d(" != ")

                return false
            }
        }
        return false
    }

    
    /*
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        if type == .began {
            // Interruption began, take appropriate actions
            d("Interruption began, take appropriate actions")
        }
        else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                    d("// Interruption Ended - playback should resume")
                } else {
                    // Interruption Ended - playback should NOT resume
                    d("// Interruption Ended - playback should NOT resume")
                }
            }
        }
    }
    */
    
    /*
    @objc func handleRouteChange(_ notification: Notification) {
        let reasonValue = (notification as NSNotification).userInfo![AVAudioSessionRouteChangeReasonKey] as! UInt
        let routeDescription = (notification as NSNotification).userInfo![AVAudioSessionRouteChangePreviousRouteKey] as! AVAudioSessionRouteDescription?

        NSLog("Route change:...")
        if let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) {
            switch reason {
            case .newDeviceAvailable:
                NSLog("     NewDeviceAvailable")
            case .oldDeviceUnavailable:
                NSLog("     OldDeviceUnavailable")
            case .categoryChange:
                NSLog("     CategoryChange")
                NSLog(" New Category: %@", AVAudioSession.sharedInstance().category.rawValue)
            case .override:
                NSLog("     Override")
            case .wakeFromSleep:
                NSLog("     WakeFromSleep")
            case .noSuitableRouteForCategory:
                NSLog("     NoSuitableRouteForCategory")
            case .routeConfigurationChange:
                NSLog("     RouteConfigurationChange")
            case .unknown:
                NSLog("     Unknown")
            @unknown default:
                NSLog("     UnknownDefault(%zu)", reasonValue)
            }
        } else {
            NSLog("     ReasonUnknown(%zu)", reasonValue)
        }

        if let prevRout = routeDescription {
            NSLog("Previous route:\n")
            NSLog("%@", prevRout)
            NSLog("Current route:\n")
            NSLog("%@\n", AVAudioSession.sharedInstance().currentRoute)
        }
    }
 */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
