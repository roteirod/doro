//
//  DataClasses.swift
//  doro
//
//  Created by Volodymyr Davydenko on 08.05.2021.
//

import Foundation
import RealmSwift

class Pomodoro: Object {
    @objc dynamic var index: Int = 0
    @objc dynamic var start: Double = 0
    @objc dynamic var breakStart: Double = 0
    @objc dynamic var end: Double = 0
    @objc dynamic var focusDuration: Double = 0
    @objc dynamic var breakDuration: Double = 0
}

class Configuration: Object {
    @objc dynamic var timestamp: Double = 0.0
    @objc dynamic var title: String = ""
    @objc dynamic var pomodoros: Int = 0
    @objc dynamic var focusDuration: Double = 0
    @objc dynamic var shortBreakDuration: Double = 0
    @objc dynamic var longBreakDuration: Double = 0
}
