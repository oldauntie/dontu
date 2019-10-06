//
//  DebugViewController.swift
//  DontU
//
//  Created by nanna on 05/10/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import UIKit
import AVFoundation

class DebugViewController: UIViewController {

    @IBOutlet weak var timeLabel: UITextField!
    
    // var currentTime: Date?
    // private var time: Date?
    
    @IBOutlet weak var updateRoute: UILabel!
    
    /*
    func fetch(_ completion: () -> Void) {
      time = Date()
      completion()
    }
    */
    func updateUI() {
        guard updateRoute != nil  else {
            return
        }
        // updateRoute.text = getCurrentRoute()
        updateRoute.text = Route.getUid()
        d(Route.getUid())
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    @IBAction func didUpdateRoute(_ sender: Any) {
        d("premuteo")
        updateUI()
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

