//
//  ViewController.swift
//  Project21
//
//  Created by Denis Andreev on 4/15/19.
//  Copyright © 2019 felarmir. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Granted")
            } else {
                print("Denyed")
            }
        }
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"knock knock"]
        content.sound = UNNotificationSound.default
        
        var dateComponent = DateComponents()
        dateComponent.hour = 10
        dateComponent.minute = 30
        
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let data = userInfo["customData"] as? String{
            print("custom data: \(data)")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                let ac = UIAlertController(title: "Alert Data", message: data, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(ac, animated: true)
            case "show":
                print("show more")
            default:
                break
            }
        }
        
        completionHandler()
    }

}

