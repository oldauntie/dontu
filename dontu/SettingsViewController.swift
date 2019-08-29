//
//  SettingsViewController.swift
//  dontu
//
//  Created by nanna on 19/08/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

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
    
    
    @IBAction func useTouchUpInside(_ sender: Any) {
        selected_portname.text = available_portname.text
        selected_uid.text = available_uid.text
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        other.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        let avsession = AVAudioSession.sharedInstance()
        
        try! avsession.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetooth)
        try! avsession.setActive(false)
        
        let route  = avsession.currentRoute
        
        print("route:::::: \(route.outputs.debugDescription) \n")
        let out = route.outputs
        for element in out{
            print("portname: \(element.portName)")
            
            if element.portType == AVAudioSession.Port.bluetoothLE{
                print("out BLE")
            }
            
            if element.portType == AVAudioSession.Port.bluetoothA2DP{
                print("out A2DP")
            }
            
            if element.portType == AVAudioSession.Port.bluetoothHFP{
                print("out HFP")
            }
            
            print("rawValue: \(element.portType.rawValue) UID: \(element.uid) ")
            
            
            
            available_portname.text = element.uid
            available_porttype.text = "Type: \(element.portType.rawValue)"
            available_uid.text = "UID: \(element.uid)"
            
        }
                
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        other.text = userDefaults.object(forKey: "Other") as? String
        distance.selectedSegmentIndex  = userDefaults.integer(forKey: "Distance")
        
        selected_portname.text = userDefaults.object(forKey: "PortName") as? String
        selected_uid.text = userDefaults.object(forKey: "UID") as? String
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // save user defaul from settings
        let userDefaults = UserDefaults.standard
        userDefaults.set(distance.selectedSegmentIndex, forKey: "Distance")
        userDefaults.set(other.text, forKey: "Other")
        userDefaults.set(selected_portname.text, forKey: "PortName")
        userDefaults.set(selected_uid.text, forKey: "UID")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

