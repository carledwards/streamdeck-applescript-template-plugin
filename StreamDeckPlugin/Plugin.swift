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
        print("keyDown")
        connectionManager?.logMessage("keyDown")
        
//        let source = "display notification \"You pressed a button\" with title \"Stream Deck\" subtitle \"Congratulations!\" sound name \"Frog\""
        let source = """
        tell application "Safari"
            activate
            make new document with properties {URL:"https://github.com/carledwards/streamdeck-applescript-template-plugin"}
        end tell
        """
        if let script = NSAppleScript(source: source) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
            if let err = error {
                print("Error executing AppleScript: ", err)
            }
        }
    }
    
    func keyUp(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        connectionManager?.logMessage("keyUp")
    }

    func willAppear(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        print("willAppear")
        connectionManager?.logMessage("willAppear")
    }
    
    func willDisappear(forAction action: String, withContext context: Any, withPayload payload: [AnyHashable : Any], forDevice deviceID: String) {
        print("willDisappear")
        connectionManager?.logMessage("willDisappear")
    }

    func deviceDidConnect(_ deviceID: String, withDeviceInfo deviceInfo: [AnyHashable : Any]) {
        print("deviceDidConnect")
        connectionManager?.logMessage("deviceDidConnect")
    }

    func deviceDidDisconnect(_ deviceID: String) {
        print("deviceDidDisconnect")
        connectionManager?.logMessage("deviceDidDisconnect")
    }

    func applicationDidLaunch(_ applicationInfo: [AnyHashable : Any]) {
        print("applicationDidLaunch")
        connectionManager?.logMessage("applicationDidLaunch")
    }

    func applicationDidTerminate(_ applicationInfo: [AnyHashable : Any]) {
        print("applicationDidTerminate")
        connectionManager?.logMessage("applicationDidTerminate")
    }
}
