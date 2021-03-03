//
//  WifiHandler.swift
//  GeofencingArea
//
//  Created by Developer on 03/03/2021.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

class WifiHandler: NSObject {
    static func getSSIDs() -> [String] {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        
        return interfaceNames.compactMap { name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String: AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            
            return ssid
        }
    }
}
