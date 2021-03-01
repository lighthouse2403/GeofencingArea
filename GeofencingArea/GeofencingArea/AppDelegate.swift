//
//  AppDelegate.swift
//  GeofencingArea
//
//  Created by Thuy Phan on 3/2/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Request authorization to notice when outside
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { _, error in
          if let error = error {
            print("Error: \(error)")
          }
        }
        return true
      }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Remove pending notification when open App
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}

