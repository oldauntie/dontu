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
    
    
    @IBAction func SetChildAlarm(sender: UIButton)
    {
        d(what: "Child")
    }
    
    
    @IBAction func SetPetAlarm(sender: UIButton)
    {
        d(what: "Pet")
    }
    
    
    @IBAction func SetOtherAlarm(sender: UIButton)
    {
        d(what: "Other")
    }


}

