//
//  Plugin.swift
//  StreamDeckPlugin
//
//  Created by Carl Edwards on 3/31/22.
//

import Foundation

class Plugin: NSObject, ESDEventsProtocol {
    var connectionManager: ESDConnectionManager? = nil
    
    func setConnectionManager(_ theConnectionManager: ESDConnectionManager) {
        connectionManager = theConnectionManager
        connectionManager?.logMessage("setConnectionManager")
    }

    func keyDown(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        connectionManager?.logMessage("keyDown")
    }
    
    func keyUp(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        connectionManager?.logMessage("keyUp")
    }

    func willAppear(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        connectionManager?.logMessage("willAppear")
    }
    
    func willDisappear(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        connectionManager?.logMessage("willDisappear")
    }

    func deviceDidConnect(_ deviceID: String, withDeviceInfo deviceInfo: [AnyHashable : Any]) {
        connectionManager?.logMessage("deviceDidConnect")
    }

    func deviceDidDisconnect(_ deviceID: String) {
        connectionManager?.logMessage("deviceDidDisconnect")
    }

    func applicationDidLaunch(_ applicationInfo: [AnyHashable : Any]) {
        connectionManager?.logMessage("applicationDidLaunch")
    }

    func applicationDidTerminate(_ applicationInfo: [AnyHashable : Any]) {
        connectionManager?.logMessage("applicationDidTerminate")
    }
}
