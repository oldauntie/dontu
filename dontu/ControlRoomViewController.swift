//
//  ControlRoomViewController.swift
//  dontu
//
//  Created by nanna on 19/08/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import UIKit

class ControlRoomViewController: UIViewController {

    private var isArmed: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func EnablePetControl(_ sender: UIButton) {
        ChangeState(sender)
    }
    
    @IBAction func EnableOtherControl(_ sender: UIButton) {
        ChangeState(sender)
    }
    
    @IBAction func EnableChildControl(_ sender: UIButton) {
        d("nanna")
        ChangeState(sender)
    }
    
    private func ChangeState(_ sender: UIButton)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
