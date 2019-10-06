//
//  SettingsViewController.swift
//  DontU
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
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        // carica le possibili audio route connesse e filtra solo quelle Bluetooth
        let avsession = AVAudioSession.sharedInstance()
        
        try! avsession.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetooth)
        try! avsession.setActive(false)
        
        let route  = avsession.currentRoute
        
        let out = route.outputs
        for element in out{
            if element.portType == AVAudioSession.Port.bluetoothLE || element.portType == AVAudioSession.Port.bluetoothA2DP || element.portType == AVAudioSession.Port.bluetoothHFP {
                
                available_portname.text = element.portName
                available_porttype.text = element.portType.rawValue
                available_uid.text = element.uid
                
                use_button.isEnabled = true;
            }else{
                available_portname.text = "No Bluetooth Available"
                available_porttype.text = ""
                available_uid.text = ""
                
                use_button.isEnabled = false;
            }
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

