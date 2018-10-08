//
//  Constants.swift
//  Alarm
//
//  Created by Apple on 04/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

struct Identifier {
    static let stopIdentifier = "Alarm-ios-swift-stop"
    static let snoozeIdentifier = "Alarm-ios-swift-snooze"
    static let addSegueIdentifier = "addSegue"
    static let editSegueIdentifier = "editSegue"
    static let saveSegueIdentifier = "saveEditSegue"
    static let soundSegueIdentifier = "soundSegue"
    static let labelSegueIdentifier = "labelEditSegue"
  //  static let weekdaysSegueIdentifier = "weekdaysSegue"
  //  static let settingIdentifier = "setting"
  //  static let musicIdentifier = "musicIdentifier"
    static let alarmCellIdentifier = "alarmCell"
    
    static let labelUnwindIdentifier = "labelUnwindSegue"
    static let soundUnwindIdentifier = "soundUnwindSegue"
    static let weekdaysUnwindIdentifier = "weekdaysUnwindSegue"
}

struct SegueInfo {
    var curCellIndex: Int
    var isEditMode: Bool
    var label: String
    var mediaLabel: String
    var mediaID: String
    var repeatWeekdays: [Int]
    var enabled: Bool
    var snoozeEnabled: Bool
}
