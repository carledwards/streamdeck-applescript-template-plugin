//
//  ESDEventsProtocol.swift
//  StreamDeckPlugin
//
//  Created by Carl Edwards on 4/11/22.
//

import Foundation
import SwiftyJSON

protocol ESDEventsProtocol {

    func setConnectionManager (connectionManager: ESDConnectionManager) -> Void
        
    func keyDown(event: KeyEvent, settings: JSON) -> Void
    func keyUp(event: KeyEvent, settings: JSON) -> Void

    func willAppear(event: KeyEvent, settings: JSON) -> Void
    func willDisappear(event: KeyEvent, settings: JSON) -> Void

    func deviceDidConnect(event: DeviceDidConnectEvent) -> Void
    func deviceDidDisconnect(event: DeviceDidDisconnectEvent) -> Void

    func applicationDidLaunch(event: ApplicationEvent) -> Void
    func applicationDidTerminate(event: ApplicationEvent) -> Void
}
