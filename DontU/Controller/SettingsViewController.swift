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

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var available_portname: UITextField!
    @IBOutlet weak var available_porttype: UILabel!
    @IBOutlet weak var available_uid: UILabel!
    
    @IBOutlet weak var selected_portname: UITextField!
    @IBOutlet weak var selected_uid: UILabel!
    @IBOutlet weak var distance: UISegmentedControl!
    @IBOutlet weak var other: UITextField!
    
    @IBOutlet weak var use_button: RoundButton!
    
    @IBAction func useTouchUpInside(_ sender: Any) {
        if(available_uid.text != ""){
            selected_portname.text = available_portname.text
            selected_uid.text = available_uid.text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        other.delegate = self
        
        
        // used to check changes in AudioRoute and enable/disable buttons
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(handleRouteChange),
                                       name: AVAudioSession.routeChangeNotification,
                                       object: nil)
    }
    
    func loadCurrentRouteInfo() -> Void{
        if Route.isBluetooth() == true{
            available_portname.text = Route.getPortName()
            available_porttype.text = Route.getPortType()
            available_uid.text = Route.getUid()
            
            use_button.isEnabled = true
            
        }else{
            available_portname.text = "No Bluetooth Available"
            available_porttype.text = ""
            available_uid.text = ""
            
            use_button.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // load user default in settings form
        loadCurrentRouteInfo()
        let userDefaults = UserDefaults.standard
        selected_uid.text = userDefaults.object(forKey: "UID") as? String
        selected_portname.text = userDefaults.object(forKey: "PortName") as? String
        distance.selectedSegmentIndex  = userDefaults.integer(forKey: "Distance")
        other.text = userDefaults.object(forKey: "Other") as? String
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // save user defaul from settings
        let userDefaults = UserDefaults.standard
        userDefaults.set(selected_uid.text, forKey: "UID")
        userDefaults.set(selected_portname.text, forKey: "PortName")
        userDefaults.set(distance.selectedSegmentIndex, forKey: "Distance")
        userDefaults.set(other.text, forKey: "Other")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func handleRouteChange(_ notification: Notification) {
        DispatchQueue.main.async {
            self.loadCurrentRouteInfo()
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

