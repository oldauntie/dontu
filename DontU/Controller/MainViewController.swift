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

import UIKit
import AVFoundation
import CoreLocation
import UserNotifications

class MainViewController: UIViewController, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    // private var isArmed: Bool = false;
    private var numberOfArmedDevices = 0
    private var location: Location?
    // private var currentAudioRouteUid: String?
    private var currentAudioRouteName: String?
    private var scheduler: Scheduler?
    
    @IBOutlet weak var btnChild: RoundButton!
    @IBOutlet weak var btnPet: RoundButton!
    @IBOutlet weak var btnOther: RoundButton!
    
    // used for debug purpose only
    @IBOutlet weak var debugText: UITextView!

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
        
        // hide / show debug textView
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

            if Route.isValidBluetoothConnection() == false{
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
        currentAudioRouteName = Route.getPortName()
        
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
        
        // start / stop GPS services
        if numberOfArmedDevices > 0 {
            startLocation()
            
            // disable Settings button
            let tabBarControllerItems = self.tabBarController?.tabBar.items

            if let tabArray = tabBarControllerItems {
                let tabBarItem1 = tabArray[1]
                
                tabBarItem1.isEnabled = false
            }
        }else{
            stopLocation()
            
            // enable Settings button
            let tabBarControllerItems = self.tabBarController?.tabBar.items

            if let tabArray = tabBarControllerItems {
                let tabBarItem1 = tabArray[1]
                
                tabBarItem1.isEnabled = true
            }
        }
        
        
    }
    
    
    func startLocation() -> Void {
        // device is armed: start GPS localization
        d("start GPS")
        let userDefaults = UserDefaults.standard
        let distances: [Int] = [3, 5, 8, 13, 21]
        let index = userDefaults.integer(forKey: "Distance")
        
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
            
            // check if route is changed
            if currentAudioRouteName != nil && currentAudioRouteName != Route.getPortName(){
                // set the alarm
                scheduler?.scheduleNotification()
                // reset current route UID
                currentAudioRouteName = Route.getPortName()
            }
        }
    }
    
    
    @objc func handleRouteChange(_ notification: Notification) {
        //d(Route.getPortName(), label: "Name")
        d(Route.getCurrentRoute())
        
        DispatchQueue.main.async {
            _ = self.isValidBluetoothConnection()
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
