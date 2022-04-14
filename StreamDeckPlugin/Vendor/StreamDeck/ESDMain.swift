//
//  ESDMain.swift
//  StreamDeckPlugin
//
//  Created by Carl Edwards on 3/30/22.
//

import Foundation
import ArgumentParser

@main
struct StreamDeckPlugin: ParsableCommand, ESDApplicationStateProtocol {
    @Flag(name: .customLong("verbose", withSingleDash: true))
    var verbose = false

    @Option(name: .customLong("port", withSingleDash: true))
        var port: Int

    @Option(name: .customLong("pluginUUID", withSingleDash: true))
        var pluginUUID: String
    
    @Option(name: .customLong("registerEvent", withSingleDash: true))
        var registerEvent: String
    
    @Option(name: .customLong("info", withSingleDash: true))
        var info: String

    func socketClosed() {
        print("socket was closed by host, maybe another instances is already registered?  Check the logs at: ~/Library/Logs/StreamDeck/")
        CFRunLoopStop(CFRunLoopGetCurrent())
    }

    mutating func run() throws {
        let plugin: ESDEventsProtocol = Plugin()
        let connectionManager: ESDConnectionManager = ESDConnectionManager(port: port, pluginUUID: pluginUUID, registerEvent: registerEvent, info: info, pluginDelegate: plugin, applicationStateDelegate: self, debug: verbose)
        connectionManager.connect()
        CFRunLoopRun()
    }
}
