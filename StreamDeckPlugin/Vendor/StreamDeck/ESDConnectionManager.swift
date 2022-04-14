//
//  ESDConnectionManager.swift
//  StreamDeckPlugin
//
//  Created by Carl Edwards on 4/11/22.
//

import Foundation
import Vapor
import SwiftyJSON

struct Register: Codable {
    let event: String
    let uuid: String
}

struct LogMessage: Codable {
    struct Payload: Codable {
        let message: String
    }
    let event: String
    let payload: Payload
}

struct SetTitle: Codable {
    struct Payload: Codable {
        let title: String
        let target: Int
    }
    let event: String
    let context: String
    let payload: Payload
}

class ESDConnectionManager: NSObject {
    var port: Int
    var pluginUUID: String
    var registerEvent: String
    var deviceInfo: DeviceInfoResponse
    var pluginDelegate: ESDEventsProtocol
    var applicationStateDelegate: ESDApplicationStateProtocol
    var ws: WebSocket?
    var debug: Bool
    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 2)

    init (port: Int, pluginUUID: String, registerEvent: String, info: String, pluginDelegate: ESDEventsProtocol,
          applicationStateDelegate: ESDApplicationStateProtocol, debug: Bool = false) {
        self.port = port
        self.registerEvent = registerEvent
        self.pluginUUID = pluginUUID
        self.pluginDelegate = pluginDelegate
        self.applicationStateDelegate = applicationStateDelegate
        self.debug = debug
        let infoData = info.data(using: .utf8)!
        self.deviceInfo = try! JSONDecoder().decode(DeviceInfoResponse.self, from: infoData)
        super.init()
        self.pluginDelegate.setConnectionManager(connectionManager: self)
    }
    
    func handleEvent(event: EventResponse, eventData: Data) {
        switch event.event {
        case "deviceDidConnect":
            let deviceDidConnectEvent = try! JSONDecoder().decode(DeviceDidConnectEvent.self, from: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.deviceDidConnect(event: deviceDidConnectEvent)
            }
        case "deviceDidDisconnect":
            let deviceDidDisconnectEvent = try! JSONDecoder().decode(DeviceDidDisconnectEvent.self, from: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.deviceDidDisconnect(event: deviceDidDisconnectEvent)
            }
        case "applicationDidLaunch":
            let appEvent = try! JSONDecoder().decode(ApplicationEvent.self, from: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.applicationDidLaunch(event: appEvent)
            }
        case "applicationDidTerminate":
            let appEvent = try! JSONDecoder().decode(ApplicationEvent.self, from: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.applicationDidTerminate(event: appEvent)
            }
        case "keyDown":
            let keyEvent = try! JSONDecoder().decode(KeyEvent.self, from: eventData)
            let json = try! JSON(data: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.keyDown(event: keyEvent, settings: json["payload"]["settings"])
            }
        case "keyUp":
            let keyEvent = try! JSONDecoder().decode(KeyEvent.self, from: eventData)
            let json = try! JSON(data: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.keyUp(event: keyEvent, settings: json["payload"]["settings"])
            }
        case "willAppear":
            let keyEvent = try! JSONDecoder().decode(KeyEvent.self, from: eventData)
            let json = try! JSON(data: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.willAppear(event: keyEvent, settings: json["payload"]["settings"])
            }
        case "willDisappear":
            let keyEvent = try! JSONDecoder().decode(KeyEvent.self, from: eventData)
            let json = try! JSON(data: eventData)
            DispatchQueue.main.async {
                self.pluginDelegate.willDisappear(event: keyEvent, settings: json["payload"]["settings"])
            }
        case "systemDidWakeUp":
            logMessage("Unhandled event: \(event.event)")
        case "titleParametersDidChange":
            logMessage("Unhandled event: \(event.event)")
        case "didReceiveSettings":
            logMessage("Unhandled event: \(event.event)")
        case "didReceiveGlobalSettings":
            logMessage("Unhandled event: \(event.event)")
        case "propertyInspectorDidAppear":
            logMessage("Unhandled event: \(event.event)")
        case "propertyInspectorDidDisappear":
            logMessage("Unhandled event: \(event.event)")
        default:
            logMessage("Unknown Stream Deck event: \(event.event)")
        }
    }
    
    func connect() {
        let sendPromise = eventLoopGroup.next().makePromise(of: Void.self)
        let _ = WebSocket.connect(to: "ws://127.0.0.1:\(self.port)", on: eventLoopGroup) { wsx in
            self.ws = wsx

            wsx.onText { wsx, text in
                self.logDebugMessage("received text: \(text)")
                let textData = text.data(using: .utf8)!
                let event = try! JSONDecoder().decode(EventResponse.self, from: textData)
                self.handleEvent(event: event, eventData: textData)
            }

            wsx.onClose.whenFailure { error in
                DispatchQueue.main.async {
                    self.applicationStateDelegate.socketClosed()
                }
            }

            wsx.onClose.whenSuccess { error in
                DispatchQueue.main.async {
                    self.applicationStateDelegate.socketClosed()
                }
            }

            // register this plugin with Stream Deck
            let register = Register(event: self.registerEvent, uuid: self.pluginUUID)
            let data = try! JSONEncoder().encode(register)
            wsx.send(raw: data, opcode: .binary, promise: sendPromise)
        }.cascadeFailure(to: sendPromise)
        _ = try! sendPromise.futureResult.wait()
    }
    
    private func sendData(_ data: Data) {
        if let socket = ws {
            if (socket.isClosed) {
                return
            }
            let sendPromise = eventLoopGroup.next().makePromise(of: Void.self)
            DispatchQueue.global().async {
                socket.send(raw: data, opcode: .binary, promise: sendPromise)
                _ = try! sendPromise.futureResult.wait()
            }
        }
    }
    
    func setTitle(title: String, context: String, targetSDK: ESDSDKTarget = .kESDSDKTarget_HardwareAndSoftware) -> Void {
        let obj = SetTitle(event: "setTitle", context: context, payload: SetTitle.Payload(title: title, target: targetSDK.rawValue))
        let data = try! JSONEncoder().encode(obj)
        self.sendData(data)
    }

    func setImage(_ inBase64ImageString: String?, withContext inContext: Any?, with inTarget: ESDSDKTarget) {
        // TODO implement
//        if(inBase64ImageString == nil)
//        {
//            json = @{
//                        @kESDSDKCommonEvent: @kESDSDKEventSetImage,
//                        @kESDSDKCommonContext: inContext,
//                        @kESDSDKCommonPayload: @{
//                            @kESDSDKPayloadTarget: [NSNumber numberWithInt:inTarget]
//                        }
//                    };
//        }
//        else
//        {
//            json = @{
//                        @kESDSDKCommonEvent: @kESDSDKEventSetImage,
//                        @kESDSDKCommonContext: inContext,
//                        @kESDSDKCommonPayload: @{
//                            @kESDSDKPayloadImage: inBase64ImageString,
//                            @kESDSDKPayloadTarget: [NSNumber numberWithInt:inTarget]
//                        }
//                    };
//        }

    }

    func showAlert(forContext inContext: Any?) {
        // TODO implement
//        NSDictionary *json = @{
//                       @kESDSDKCommonEvent: @kESDSDKEventShowAlert,
//                       @kESDSDKCommonContext: inContext,
//                       };
    }

    func showOK(forContext inContext: Any?) {
        // TODO implement
//        NSDictionary *json = @{
//                       @kESDSDKCommonEvent: @kESDSDKEventShowOK,
//                       @kESDSDKCommonContext: inContext,
//                       };
    }

    func setSettings(_ inSettings: [AnyHashable : Any]?, forContext inContext: Any?) {
        // TODO implement
//        NSDictionary *json = @{
//                       @kESDSDKCommonEvent: @kESDSDKEventSetSettings,
//                       @kESDSDKCommonContext: inContext,
//                       @kESDSDKCommonPayload: inSettings
//                       };
    }

    func setState(_ inState: NSNumber?, forContext inContext: Any?) {
        // TODO implement
//        NSDictionary *json = @{
//                   @kESDSDKCommonEvent: @kESDSDKEventSetState,
//                   @kESDSDKCommonContext: inContext,
//                   @kESDSDKCommonPayload: @{
//                           @kESDSDKPayloadState: inState
//                    }
//                   };
    }

    func logDebugMessage(_ message:String) {
        if (debug) {
            logMessage(message)
        }
    }
    
    func logMessage(_ message: String) {
        if (debug) {
            print(message)
        }
        let register = LogMessage(event: "logMessage", payload: LogMessage.Payload(message: message))
        let data = try! JSONEncoder().encode(register)
        self.sendData(data)
    }
}
