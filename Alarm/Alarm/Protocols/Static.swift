//
//  Static.swift
//  Alarm
//
//  Created by Apple on 04/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

protocol Static{
    var ud: UserDefaults {get}
    var persistKey : String {get}
    func persist()
    func unpersist()
}
