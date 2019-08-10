//
//  ViewController.swift
//  dontu
//
//  Created by nanna on 07/08/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import UIKit




class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    private var isArmed: Bool = false;
    
    @IBAction func SetChildAlarm(sender: UIButton)
    {
        ChangeState(sender: sender);
    }
    
    
    @IBAction func SetPetAlarm(sender: UIButton)
    {
        ChangeState(sender: sender);
        d(what: "Pet" + String(sender.isSelected));
    }
    
    
    @IBAction func SetOtherAlarm(sender: UIButton)
    {
        d(what: "Other");
        ChangeState(sender: sender);
    }
    
    
    private func ChangeState(sender: UIButton)
    {
        sender.isSelected = !sender.isSelected;
        
        if(sender.isSelected == true)
        {
            // sender.setImage(UIImage(named:"pets"), for: UIControl.State.normal);
            sender.backgroundColor = UIColor.orange;
        }
        else
        {
            // sender.setImage(UIImage(named:"child_friendly"), for: UIControl.State.normal);
            sender.backgroundColor = UIColor.white;
        }
    }


}

