//
//  ESDSDKConstants.swift
//  StreamDeckPlugin
//
//  Created by Carl Edwards on 4/12/22.
//

import Foundation


struct DeviceInfoResponse: Decodable {
    struct Application: Decodable {
        let version: String
        let platform: String
        let language: String
        let font: String
        let platformVersion: String
    }
    
    struct Colors: Decodable {
        let buttonPressedBackgroundColor: String
        let buttonPressedBorderColor: String
        let buttonPressedTextColor: String
        let disabledColor: String
        let highlightColor: String
        let mouseDownColor: String
    }
    
    struct Plugin: Decodable {
        let uuid: String
        let version: String
    }
    
    struct Device: Decodable {
        let id: String
        let name: String
        let type: Int
        let size: DeviceSize
    }
    
    var application: Application
    var colors: Colors
    var devicePixelRatio: Int
    var plugin: Plugin
    var devices: [Device]
}

struct EventResponse: Decodable {
    let event: String
}

struct DeviceSize: Decodable {
    let columns: Int
    let rows: Int
}

struct DeviceInfo: Decodable {
    let name: String
    let type: Int
    let size: DeviceSize
}

struct DeviceDidConnectEvent: Decodable {
    let event: String
    let device: String
    let deviceInfo: DeviceInfo
}

struct DeviceDidDisconnectEvent: Decodable {
    let event: String
    let device: String
}

struct KeyEvent: Decodable {
    struct Coordinates: Decodable {
        let column: Int
        let row: Int
    }
    
    struct KeyPayload: Decodable {
        let coordinates: Coordinates
        let isInMultiAction: Bool
    }
    
    let action: String
    let event: String
    let device: String
    let context: String
    let payload: KeyPayload
}

struct ApplicationEvent: Decodable {
    struct ApplicationPayload: Decodable {
        let application: String
    }
    
    let event: String
    let payload: ApplicationPayload
}

//
// Current version of the SDK
//

let kESDSDKVersion = 2


//
// Common base-interface
//

let kESDSDKCommonAction = "action"
let kESDSDKCommonEvent =  "event"
let kESDSDKCommonContext = "context"
let kESDSDKCommonPayload = "payload"
let kESDSDKCommonDevice = "device"
let kESDSDKCommonDeviceInfo = "deviceInfo"


//
// Events
//

let kESDSDKEventKeyDown = "keyDown"
let kESDSDKEventKeyUp = "keyUp"
let kESDSDKEventWillAppear = "willAppear"
let kESDSDKEventWillDisappear = "willDisappear"
let kESDSDKEventDeviceDidConnect =  "deviceDidConnect"
let kESDSDKEventDeviceDidDisconnect = "deviceDidDisconnect"
let kESDSDKEventApplicationDidLaunch = "applicationDidLaunch"
let kESDSDKEventApplicationDidTerminate = "applicationDidTerminate"
let kESDSDKEventSystemDidWakeUp = "systemDidWakeUp"
let kESDSDKEventTitleParametersDidChange = "titleParametersDidChange"
let kESDSDKEventDidReceiveSettings = "didReceiveSettings"
let kESDSDKEventDidReceiveGlobalSettings = "didReceiveGlobalSettings"
let kESDSDKEventPropertyInspectorDidAppear = "propertyInspectorDidAppear"
let kESDSDKEventPropertyInspectorDidDisappear = "propertyInspectorDidDisappear"


//
// Functions
//

let kESDSDKEventSetTitle = "setTitle"
let kESDSDKEventSetImage = "setImage"
let kESDSDKEventShowAlert = "showAlert"
let kESDSDKEventShowOK =  "showOk"
let kESDSDKEventGetSettings = "getSettings"
let kESDSDKEventSetSettings = "setSettings"
let kESDSDKEventGetGlobalSettings = "getGlobalSettings"
let kESDSDKEventSetGlobalSettings = "setGlobalSettings"
let kESDSDKEventSetState = "setState"
let kESDSDKEventSwitchToProfile = "switchToProfile"
let kESDSDKEventSendToPropertyInspector = "sendToPropertyInspector"
let kESDSDKEventSendToPlugin = "sendToPlugin"
let kESDSDKEventOpenURL = "openUrl"
let kESDSDKEventLogMessage = "logMessage"


//
// Payloads
//

let kESDSDKPayloadSettings = "settings"
let kESDSDKPayloadCoordinates = "coordinates"
let kESDSDKPayloadState = "state"
let kESDSDKPayloadUserDesiredState = "userDesiredState"
let kESDSDKPayloadTitle = "title"
let kESDSDKPayloadTitleParameters = "titleParameters"
let kESDSDKPayloadImage = "image"
let kESDSDKPayloadURL = "url"
let kESDSDKPayloadTarget = "target"
let kESDSDKPayloadProfile = "profile"
let kESDSDKPayloadApplication = "application"
let kESDSDKPayloadIsInMultiAction = "isInMultiAction"
let kESDSDKPayloadMessage = "message"

let kESDSDKPayloadCoordinatesColumn = "column"
let kESDSDKPayloadCoordinatesRow =  "row"

//
// Device Info
//

let kESDSDKDeviceInfoID = "id"
let kESDSDKDeviceInfoType = "type"
let kESDSDKDeviceInfoSize = "size"
let kESDSDKDeviceInfoName = "name"

let kESDSDKDeviceInfoSizeColumns =  "columns"
let kESDSDKDeviceInfoSizeRows = "rows"


//
// Title Parameters
//

let kESDSDKTitleParametersShowTitle = "showTitle"
let kESDSDKTitleParametersTitleColor = "titleColor"
let kESDSDKTitleParametersTitleAlignment = "titleAlignment"
let kESDSDKTitleParametersFontFamily = "fontFamily"
let kESDSDKTitleParametersFontSize = "fontSize"
let kESDSDKTitleParametersFontStyle = "fontStyle"
let kESDSDKTitleParametersFontUnderline = "fontUnderline"


//
// Icon Editor
//

let kESDSDKIconEditorActionsInfo =  "actionsInfo"


//
// Connection
//

let kESDSDKConnectSocketFunction =  "connectElgatoStreamDeckSocket"
let kESDSDKRegisterPlugin = "registerPlugin"
let kESDSDKRegisterPropertyInspector = "registerPropertyInspector"
let kESDSDKRegisterIconEditor = "registerIconEditor"
let kESDSDKPortParameter = "-port"
let kESDSDKPluginUUIDParameter = "-pluginUUID"
let kESDSDKRegisterEventParameter = "-registerEvent"
let kESDSDKInfoParameter = "-info"
let kESDSDKRegisterUUID = "uuid"

let kESDSDKApplicationInfo = "application"
let kESDSDKPluginInfo = "plugin"
let kESDSDKDevicesInfo =  "devices"
let kESDSDKColorsInfo = "colors"
let kESDSDKDevicePixelRatio = "devicePixelRatio"

let kESDSDKApplicationInfoVersion = "version"
let kESDSDKApplicationInfoLanguage = "language"
let kESDSDKApplicationInfoPlatform = "platform"

let kESDSDKPluginInfoVersion = "version"
let kESDSDKPluginInfoUUID = "uuid"

let kESDSDKApplicationInfoPlatformMac = "mac"
let kESDSDKApplicationInfoPlatformWindows = "windows"

let kESDSDKColorsInfoHighlightColor = "highlightColor"
let kESDSDKColorsInfoMouseDownColor = "mouseDownColor"
let kESDSDKColorsInfoDisabledColor = "disabledColor"
let kESDSDKColorsInfoButtonPressedTextColor = "buttonPressedTextColor"
let kESDSDKColorsInfoButtonPressedBackgroundColor = "buttonPressedBackgroundColor"
let kESDSDKColorsInfoButtonMouseOverBackgroundColor = "buttonMouseOverBackgroundColor"
let kESDSDKColorsInfoButtonPressedBorderColor = "buttonPressedBorderColor"


enum ESDSDKTarget: Int {
    case kESDSDKTarget_HardwareAndSoftware = 0
    case kESDSDKTarget_HardwareOnly = 1
    case kESDSDKTarget_SoftwareOnly = 2
}

enum ESDSDKDeviceType: Int {
    case kESDSDKDeviceType_StreamDeck = 0
    case kESDSDKDeviceType_StreamDeckMini = 1
    case kESDSDKDeviceType_StreamDeckXL = 2
    case kESDSDKDeviceType_StreamDeckMobile = 3
    case kESDSDKDeviceType_CorsairGKeys = 4
}
