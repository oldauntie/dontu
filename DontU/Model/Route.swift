//  Created by Old Auntie (www.oldauntie.org).
//  Copyright © 2019 OldAuntie. All rights reserved.
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be included
//  in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
//  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
//  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation
import AVFoundation

class Route{
    // @todo TBS
    // private static var currentUid: String?
    
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
    
    // @todo: change and use portName instead?
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
