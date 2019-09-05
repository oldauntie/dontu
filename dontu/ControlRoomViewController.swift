//
//  ControlRoomViewController.swift
//  dontu
//
//  Created by nanna on 19/08/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import UIKit
import AVFoundation

class ControlRoomViewController: UIViewController {

    private var isArmed: Bool = false;
    
    @IBOutlet weak var petButton: RoundButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func EnableChildControl(_ sender: UIButton) {
        d("nanna")
        changeState(sender)
    }
    
    @IBAction func EnablePetControl(_ sender: UIButton) {
        changeState(sender)
        alert(message: "nanna bono")
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
        
        
        
        sender.isSelected = !sender.isSelected
        
        if(sender.isSelected == true)
        {
            // sender.setImage(UIImage(named:"pets"), for: UIControl.State.normal);
            sender.backgroundColor = UIColor.orange
        }
        else
        {
            // sender.setImage(UIImage(named:"child_friendly"), for: UIControl.State.normal);
            sender.backgroundColor = UIColor.white
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        
        
        
        if uid != nil && uid != ""{
            d( "UID----> \(String(describing: uid))" )
        }
        
        
        // read current audio route
        let avsession = AVAudioSession.sharedInstance()
        
        try! avsession.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetooth)
        try! avsession.setActive(false)
        
        let route  = avsession.currentRoute
        
        let out = route.outputs
        
        // enable / disable buttons according to bluetooth connection
        for element in out{
            if element.portType == AVAudioSession.Port.bluetoothLE || element.portType == AVAudioSession.Port.bluetoothA2DP || element.portType == AVAudioSession.Port.bluetoothHFP {
                
                petButton.isEnabled = true
            }else{
                petButton.isEnabled = false
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
