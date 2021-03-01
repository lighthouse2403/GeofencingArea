//
//  SceneDelegate.swift
//  GeofencingArea
//
//  Created by Thuy Phan on 3/2/21.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let clLocationManager = CLLocationManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        self.clLocationManager.delegate = self
        self.clLocationManager.requestAlwaysAuthorization()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// MARK: - CLLocationManager Delegate
extension SceneDelegate: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleEvent(for: region)
    }
  }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleEvent(for: region)
    }
  }

  func handleEvent(for region: CLRegion) {
    // Show an alert if application is active
    if UIApplication.shared.applicationState == .active {
      guard let message = note(from: region.identifier) else { return }
      window?.rootViewController?.showAlert(withTitle: nil, message: message)
    } else {
      // Otherwise present a local notification
      guard let body = note(from: region.identifier) else { return }
      let notificationContent = UNMutableNotificationContent()
      notificationContent.body = body
      notificationContent.sound = .default
      notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
      let request = UNNotificationRequest(
        identifier: "location_change",
        content: notificationContent,
        trigger: trigger)
      UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
          print("Error: \(error)")
        }
      }
    }
  }

  func note(from identifier: String) -> String? {
    let geotifications = GeotificationHandler.allGeotifications()
    let matched = geotifications.first { $0.identifier == identifier }
    return matched?.note
  }
}
