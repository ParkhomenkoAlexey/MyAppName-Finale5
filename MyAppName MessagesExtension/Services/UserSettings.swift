//
//  UserSettings.swift
//  MoveYourBody
//
//  Created by Алексей Пархоменко on 12.03.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

final class UserSettings {
    
    private enum SettingKey: String {
        case countPhone
        case countIPad
        case currentCount
    }
    
    static var currentCount: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.currentCount.rawValue) as? Int {
                return count
            } else {
                return 3
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.currentCount.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(3, forKey: key)
            }
        }
    }
    
    static var countPhone: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.countPhone.rawValue) as? Int {
                return count
            } else {
                return 3
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.countPhone.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(3, forKey: key)
            }
        }
    }
    
    static var countIPad: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.countIPad.rawValue) as? Int {
                return count
            } else {
                return 3
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.countIPad.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(3, forKey: key)
            }
        }
    }
}
