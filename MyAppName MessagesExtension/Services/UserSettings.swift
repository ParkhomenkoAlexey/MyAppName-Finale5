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
        case count
    }
    
    static var count: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.count.rawValue) as? Int {
                return count
            } else {
                return 3
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.count.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(3, forKey: key)
            }
        }
    }
}
