//
//  Route.swift
//  DontU
//
//  Created by nanna on 06/10/2019.
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import Foundation
import AVFoundation

class Route{
    private static var currentUid: String?
    
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
        // let route  = getCurrentRoute().outputs
        // let out = route.outputs
        let out = getCurrentRoute().outputs
        for element in out{
            result = element.uid
        }
        
        return result
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
}
