//
//  Plugin.swift
//  StreamDeckPlugin
//
//  Created by Carl Edwards on 3/31/22.
//

import Foundation
import SwiftyJSON

class Plugin: NSObject, ESDEventsProtocol {
    var connectionManager: ESDConnectionManager? = nil
    
    func setConnectionManager(connectionManager theConnectionManager: ESDConnectionManager) {
        connectionManager = theConnectionManager
    }

    // see Elgato Developer Documentation for event descriptions: https://developer.elgato.com/documentation/stream-deck/sdk/events-received/

    func keyDown(event: KeyEvent, settings: JSON) {
        connectionManager?.logDebugMessage("plugin recieved keyDown event: \(event), settings: \(settings)")
        
        // NOTE: If your script isn't working, try looking here:
        //   * AppleScript is very particular to the formatting of the script, check for the error below being logged
        //   * Verify/reset the Stream Decks security permissions:
        //     1. look here: System Prefences->Security & Privacy->Privacy (tab)->Automation (list item)->Stream Deck
        //     2. you might need to reset previous security 'asks': "sudo tccutil reset All com.elgato.StreamDeck"
        //        use is with caution as all permissions are removed and will be re-challenged for all Stream Deck plugins
        let source = """
        tell application "Safari"
            activate
            make new document with properties {URL:"https://github.com/carledwards/streamdeck-applescript-template-plugin"}
        end tell
        """
        if let script = NSAppleScript(source: source) {
            var error: NSDictionary?
            connectionManager?.logDebugMessage("executing script: \(source)")
            script.executeAndReturnError(&error)
            if let err = error {
                connectionManager?.logMessage("Error executing AppleScript: \(err)")
            }
        }
    }

    func keyUp(event: KeyEvent, settings: JSON) {
        connectionManager?.logDebugMessage("plugin recieved keyUp: \(event), settings: \(settings)")
    }

    func willAppear(event: KeyEvent, settings: JSON) {
        connectionManager?.logDebugMessage("plugin recieved willAppear: \(event), settings: \(settings)")
        connectionManager?.setTitle(title: "Hello", context: event.context)
    }
    
    func willDisappear(event: KeyEvent, settings: JSON) {
        connectionManager?.logDebugMessage("plugin recieved willDisappear: \(event), settings: \(settings)")
        connectionManager?.setTitle(title: "Goodbye", context: event.context)
    }

    func deviceDidConnect(event: DeviceDidConnectEvent) {
        connectionManager?.logDebugMessage("plugin recieved deviceDidConnect: \(event)")
    }

    func deviceDidDisconnect(event: DeviceDidDisconnectEvent) {
        connectionManager?.logDebugMessage("plugin recieved deviceDidDisconnect: \(event)")
    }

    func applicationDidLaunch(event: ApplicationEvent) {
        connectionManager?.logDebugMessage("plugin recieved applicationDidLaunch: \(event)")
    }

    func applicationDidTerminate(event: ApplicationEvent) {
        connectionManager?.logDebugMessage("plugin recieved applicationDidTerminate: \(event)")
    }
}
