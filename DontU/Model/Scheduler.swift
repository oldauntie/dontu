//  Created by Old Auntie (www.oldauntie.org).
//  Copyright © 2019 OldAuntie. All rights reserved.
//

import Foundation
import UserNotifications


class Scheduler: NSObject, UNUserNotificationCenterDelegate{

    public static var sharedInstance = Scheduler()
    override init() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
        super.init()
        center.delegate = self
    }
    
    func scheduleNotification() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "DontU"
        content.body = "Forget about me..."
        content.categoryIdentifier = "dontu-alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        // content.sound = UNNotificationSound.default
           
        let soundName = UNNotificationSoundName("bell.mp3")
        content.sound = UNNotificationSound(named: soundName)

        // @todo: unused yet TBE
        /*
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        */
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)

    }
       
        func stopAllNotification(){
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()
    }
           
       func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           completionHandler([.alert, .badge, .sound])
       }
       
}
