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
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateUI()
    }
    
    func updateUI() -> Void{
        /*
        btnChild.isEnabled = false
        btnPet.isEnabled = false
        btnOther.isEnabled = false
        if checkBluetoothConnection() == true{
            btnChild.isEnabled = true
            btnPet.isEnabled = true
            btnOther.isEnabled = true
        }
        */
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
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        if location?.isUpdatingLocation == false{
            if uid == nil || uid == ""{
                alert(message: "No Bluetooh connection configued yet. Select one in settings", title: "Warning")
                return
            }

            if checkBluetoothConnection() == false{
                alert(message: "Phone is not connected to Car Audio Bluetooh. Connect the phone or select another one in settings", title: "Warning")
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
            // sender.setImage(UIImage(named:"child_friendly"), for: UIControl.State.normal);
            sender.backgroundColor = UIColor.white
            numberOfArmedDevices -= 1
        }
        
        // start GPS
        if numberOfArmedDevices > 0 {
            // device is armed: start GPS localization
            d("start GPS")
            location?.startUpdatingLocation()
            
        }else{
            // device is disarmed: stop GPS localization
            d("stop GPS")
            location?.stopUpdatingLocation()
        }
        
        
    }
    
    private func checkBluetoothConnection() -> Bool {
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        
        if Route.isBluetooth(){
            if Route.getUid() == uid{
                return true
            }else{
                return false
            }
        }
        return false
    }

    
    
    @objc func handleRouteChange(_ notification: Notification) {
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
