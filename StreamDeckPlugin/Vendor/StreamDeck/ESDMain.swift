//
//  ESDMain.swift
//  StreamDeckPlugin
//
//  Created by Carl Edwards on 3/30/22.
//

import Foundation
import ArgumentParser

@main
struct StreamDeckPlugin: ParsableCommand {
    @Option(name: .customLong("port", withSingleDash: true))
        var port: Int32

    @Option(name: .customLong("pluginUUID", withSingleDash: true))
        var pluginUUID: String
    
    @Option(name: .customLong("registerEvent", withSingleDash: true))
        var registerEvent: String
    
    @Option(name: .customLong("info", withSingleDash: true))
        var info: String

    mutating func run() throws {
        let _: ESDConnectionManager = ESDConnectionManager(port: port, andPluginUUID: pluginUUID, andRegisterEvent: registerEvent, andInfo: info, andDelegate: Plugin())
        RunLoop.current.run()
    }
}
