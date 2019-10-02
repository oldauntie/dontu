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
    
    @IBOutlet weak var btnChild: RoundButton!
    @IBOutlet weak var btnPet: RoundButton!
    @IBOutlet weak var btnOther: RoundButton!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // navBar.isTranslucent = true
        // self.navigationItem.prompt = "nanna"
        
        // Create a navView to add to the navigation bar
        let navView = UIView()
        
        // Create the label
        let label = UILabel()
        label.text = "Text"
        label.sizeToFit()
        label.center = navView.center
        label.textAlignment = NSTextAlignment.center
        
        // Create the image view
        let image = UIImageView()
        image.image = UIImage(named: "bluetooth")
        
        // To maintain the image's aspect ratio:
        let imageAspect = image.image!.size.width/image.image!.size.height
        // Setting the image frame so that it's immediately before the text:
        image.frame = CGRect(x: label.frame.origin.x-label.frame.size.height*imageAspect, y: label.frame.origin.y, width: label.frame.size.height*imageAspect, height: label.frame.size.height)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        // Add both the label and image view to the navView
        navView.addSubview(label)
        navView.addSubview(image)
        
        // Set the navigation bar's navigation item's titleView to the navView
        self.navBar.titleView = navView
        // Set the navView's frame to fit within the titleView
        navView.sizeToFit()
    }
    
    @IBAction func EnableChildControl(_ sender: UIButton) {
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
    
    private func checkBluetoothConnection() -> Bool {
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        // let port_name = userDefaults.object(forKey: "UID") as? String
        
        // bluetooth is not configured
        if uid != nil && uid != ""{
                return false
        }
        
        // read current audio route into variable out
        let avsession = AVAudioSession.sharedInstance()
        try! avsession.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetooth)
        try! avsession.setActive(false)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
