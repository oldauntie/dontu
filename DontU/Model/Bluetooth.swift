//
//  Bluetooth.swift
//  DontU
//
//  Created by nanna on 06/10/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import Foundation


class Bluetooth{
    
    
    public static func isValidConnection() -> Bool {
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let uid = userDefaults.object(forKey: "UID") as? String
        
        if Route.isBluetooth(){
            if Route.getUid() == uid{
                return true
            }else{
                return false
            }
        }
        return false
    }
    
}
