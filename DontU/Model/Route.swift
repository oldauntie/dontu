//  Created by Old Auntie (www.oldauntie.org).
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import Foundation
import AVFoundation

class Route{
    
    static func getCurrentRoute() -> AVAudioSessionRouteDescription{
        // carica le possibili audio route connesse e filtra solo quelle Bluetooth
        let avsession = AVAudioSession.sharedInstance()
        
        try! avsession.setCategory(AVAudioSession.Category.playAndRecord, options: .allowBluetooth)
        try! avsession.setActive(false)
        
        let route  = avsession.currentRoute
        
        return route
    }
    
    static func getUid() -> String? {
        var result: String?

        let out = getCurrentRoute().outputs
        for element in out{
            result = element.uid
        }
        
        return result
    }
    
    
    static func getPortName() -> String? {
        var result: String? = nil
        // let route  = getCurrentRoute().outputs
        // let out = route.outputs
        let out = getCurrentRoute().outputs
        for element in out{
            result = element.portName
        }
        
        return result!
    }
    
    static func getPortType() -> String? {
        var result: String? = nil
        // let route  = getCurrentRoute().outputs
        // let out = route.outputs
        let out = getCurrentRoute().outputs
        for element in out{
            result = element.portType.rawValue
        }
        
        return result!
    }
    
    static func isBluetooth() -> Bool {
        var result: Bool = false
        // let route  = getCurrentRoute().outputs
        // let out = route.outputs
        let out = getCurrentRoute().outputs
        
        // if current audio connection if a Bluetooth One return true
        for element in out{
            if element.portType == AVAudioSession.Port.bluetoothLE || element.portType == AVAudioSession.Port.bluetoothA2DP || element.portType == AVAudioSession.Port.bluetoothHFP {
                // Is the current Bluetooth connection the one selected in preferences
                result = true
            }
        }
        return result
    }
    
    public static func isValidBluetoothConnection() -> Bool {
        // load user default in settings form
        let userDefaults = UserDefaults.standard
        let portName = userDefaults.object(forKey: "PortName") as? String
        
        if isBluetooth(){
            if getPortName() == portName{
                return true
            }else{
                return false
            }
        }
        return false
    }
}
