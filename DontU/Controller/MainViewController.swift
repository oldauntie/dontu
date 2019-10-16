//  Created by Old Auntie (www.oldauntie.org).
//  Copyright © 2019 OldAuntie. All rights reserved.
//


import UIKit
import AVFoundation
import CoreLocation
import UserNotifications

class MainViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    private var numberOfArmedDevices = 0
    private var location: Location?
    private var currentAudioRouteName: String?
    private var scheduler: Scheduler?
    private var isOtherButtonActivated: Bool = false
    
    @IBOutlet weak var btnChild: RoundButton!
    @IBOutlet weak var btnPet: RoundButton!
    @IBOutlet weak var btnOther: RoundButton!
    
    @IBOutlet weak var lblBluetoothStatus: UILabel!
    // used for debug purpose only
    @IBOutlet weak var txtDebug: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init a singleton location service
        location = Location.sharedInstance
        location?.locationManager.delegate = self
        
        // used to setup the alarm
        scheduler = Scheduler.sharedInstance
        
        // used to check changes in AudioRoute and enable/disable buttons
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleRouteChange),
                                       name: AVAudioSession.routeChangeNotification,
                                       object: nil)
        
        // hide / show debug textView
        txtDebug.isHidden = !Global.debug
        
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
        
        // manage keyboard behaviour
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        _ = self.isValidBluetoothConnection()
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
        // enable / disable "other" message
        isOtherButtonActivated = !isOtherButtonActivated
    }
    
    
    func isValidBluetoothConnection() -> Bool{
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        // let uid = userDefaults.object(forKey: "UID") as? String
        let portName = userDefaults.object(forKey: "PortName") as? String
        if location?.isUpdatingLocation == false{
            if portName == nil || portName == ""{
                self.view.makeToast("No Bluetooh connection configued yet. Select one in settings", duration: 5.0, position: .bottom)
                
                self.lblBluetoothStatus.text = "Not configued yet"
                return false
            }

            if Route.isValidBluetoothConnection() == false{
                self.view.makeToast("\(portName!) Car Audio Kit is disconnected.\nConnect to \(portName!) or select another one from Settings", duration: 3.0, position: .bottom)
                
                self.lblBluetoothStatus.text = "Disconnected"
                
                return false
            }else{
                // create a new style
                var style = ToastStyle()

                // this is just one of many style options
                style.messageColor = .green
                self.view.makeToast("Connected to \(Route.getPortName()!).", duration: 3.0, position: .bottom, style: style)
                
                self.lblBluetoothStatus.text = "Connected to \(Route.getPortName()!)"
            }
        }
        return true
    }
    
    
    private func changeState(_ sender: UIButton)
    {
        // check if it is connected to the right bluetooth device
        if location?.isUpdatingLocation == false{
            if isValidBluetoothConnection() == false{
                return
            }
        }
        
        // read current audio route
        currentAudioRouteName = Route.getPortName()
        
        // manage button state and arm the app
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            sender.backgroundColor = .systemTeal
            numberOfArmedDevices += 1
        }
        else
        {
            sender.backgroundColor = .white
            numberOfArmedDevices -= 1
        }
        
        // @todo tbe
        dd(txtDebug, numberOfArmedDevices)
        
        // start / stop GPS services
        if numberOfArmedDevices > 0 {
            startLocation()
            
            // disable settings
            toggleSettingsButton(enabled: false)
        }else{
            stopLocation()

            // enable settings button
            toggleSettingsButton(enabled: true)
        }
    }
    
    
    func toggleSettingsButton(enabled: Bool) -> Void {
        // get tab bar item to control settings button
        let tabBarControllerItems = self.tabBarController?.tabBar.items
        
        // disable Settings button
        if let tabArray = tabBarControllerItems {
            let settings_button = tabArray[1]
            
            settings_button.isEnabled = enabled
        }
    }
    
    func reset(){
        btnChild.backgroundColor = .white
        btnPet.backgroundColor = .white
        btnOther.backgroundColor = .white
        
        btnChild.isSelected = false
        btnPet.isSelected = false
        btnOther.isSelected = false
        
        numberOfArmedDevices = 0
        isOtherButtonActivated = false
        
        // reset current route UID
        currentAudioRouteName = Route.getPortName()
        
        // enable settings button
        toggleSettingsButton(enabled: true)
        
        // reset bluetooth
        isValidBluetoothConnection()
        
        // @todo tbe
        dd(txtDebug, numberOfArmedDevices)
        dd(txtDebug, currentAudioRouteName)
    }
    
    func startLocation() -> Void {
        // if location is not running starts GPS localization
        if location?.isUpdatingLocation == false{
            dd(txtDebug, "start GPS")
            let userDefaults = UserDefaults.standard
            let distances: [Int] = [3, 5, 8, 13, 21]
            let index = userDefaults.integer(forKey: "Distance")
            
            // set the grace distance
            location?.setDistanceFilter(distance: distances[index])
            location?.startUpdatingLocation()
        }
    }
    
    func stopLocation(){
        // device is disarmed: stop GPS localization
        dd(txtDebug, "stop GPS")
        location?.stopUpdatingLocation()
    }
    
    // delegate invoked while updating GPS
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            // @todo
            dd(txtDebug, "loc: (\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude))")
            
            // check if route is changed and fire alarm
            if currentAudioRouteName != nil && currentAudioRouteName !=
                Route.getPortName(){
                // set the alarm
                scheduler?.scheduleNotification()
                
                
                // stop GPS
                self.stopLocation()
                
                // create and show the alert message
                var message = "You are forgetting something behind you"
                let userDefaults = UserDefaults.standard
                let otherText = userDefaults.object(forKey: "Other") as? String
                
                // add other text from settings
                if isOtherButtonActivated == true && otherText != "" {
                    // read from user default in settings form
                    message += "\n\( otherText! )"
                }
                
                
                
                // Make toast with an image, title, and completion closure
                self.view.makeToast(message, duration: 3600.0, position: .center, title: "Warning !!!", image: UIImage(named: "dontu.png")) { didTap in
                    if didTap {
                        // @todo: for debug purpose only
                        // d("completion from tap")
                        // reset the GUI and the logic
                        self.scheduler?.stopAllNotification()
                        
                        // reset App Gui and params
                        self.reset()
                    } else {
                        // @todo: for debug purpose only
                        // d("completion without tap")
                    }
                }

            }
        }
    }
    
    @objc func handleRouteChange(_ notification: Notification) {
        DispatchQueue.main.async {
            _ = self.isValidBluetoothConnection()
        }
    }
    
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
