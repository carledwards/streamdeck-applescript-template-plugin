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
        
        // NOTE: If your script isn't working, try looking here:
        //   * AppleScript is very particular to the formatting of the script, check for the error below being logged
        //   * Verify/reset the Stream Decks security permissions:
        //     - look here: System Prefences->Security & Privacy->Privacy (tab)->Automation (list item)->Stream Deck
        //     - reset previous security asks: "sudo tccutil reset All com.elgato.StreamDeck"
        //       use is with caution as all permissions are removed and will be re-challenged
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
