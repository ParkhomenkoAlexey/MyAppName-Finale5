//
//  UserSettings.swift
//  MoveYourBody
//
//  Created by Алексей Пархоменко on 12.03.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

final class UserSettings {
    
    static let shared = UserSettings()
    
    private enum SettingKey: String {
        case countPortraitPhone
        case countLandscapePhone
        case countPortraitIPad
        case countLandscapeIPad
        case currentCount
    }
    
    enum ViewType: Int {
        case portraitPhone = 3
        case landscapePhone = 6
        case portraitIPad = 7
        case landscapeIPad = 11
    }
    
    private var portraitOrientation: Bool {
        let currentOrientation = UIDevice.current.orientation
        
        return currentOrientation == .portrait || currentOrientation == .faceUp || currentOrientation == .faceDown || currentOrientation == .portraitUpsideDown || UIScreen.main.bounds.width < UIScreen.main.bounds.height
    }
    
    private var iPadDevice: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var viewType: ViewType {
        if iPadDevice {
            if portraitOrientation {
                return .portraitIPad
            } else {
                return .landscapeIPad
            }
        } else {
            if portraitOrientation {
                return .portraitPhone
            } else {
                return .landscapePhone
            }
        }
    }
    
    var currentCount: Int! {
        get {
            switch viewType {
            case .portraitPhone:
                return countPortraitPhone
            case .landscapePhone:
                return countLandscapePhone
            case .portraitIPad:
                return countPortraitIPad
            case .landscapeIPad:
                return countLandscapeIPad
            }
        } set {
            switch viewType {
            case .portraitPhone:
                countPortraitPhone = newValue
            case .landscapePhone:
                countLandscapePhone = newValue
            case .portraitIPad:
                countPortraitIPad = newValue
            case .landscapeIPad:
                countLandscapeIPad = newValue
            }
        }
    }
    
    private var countPortraitPhone: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.countPortraitPhone.rawValue) as? Int {
                return count
            } else {
                return ViewType.portraitPhone.rawValue
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.countPortraitPhone.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(ViewType.portraitPhone.rawValue, forKey: key)
            }
        }
    }
    
    private var countLandscapePhone: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.countLandscapePhone.rawValue) as? Int {
                return count
            } else {
                return ViewType.landscapePhone.rawValue
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.countLandscapePhone.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(ViewType.landscapePhone.rawValue, forKey: key)
            }
        }
    }
    
    private var countPortraitIPad: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.countPortraitIPad.rawValue) as? Int {
                return count
            } else {
                return ViewType.portraitIPad.rawValue
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.countPortraitIPad.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(ViewType.portraitIPad.rawValue, forKey: key)
            }
        }
    }
    
    private var countLandscapeIPad: Int! {
        get {
            
            if let count = UserDefaults.standard.object(forKey: SettingKey.countLandscapeIPad.rawValue) as? Int {
                return count
            } else {
                return ViewType.landscapeIPad.rawValue
            }
        }
        set {
            let defaults = UserDefaults.standard
            let key = SettingKey.countLandscapeIPad.rawValue

            if let age = newValue {
                print("value: \(age) was added to key \(key)")
                defaults.set(age, forKey: key)
            } else {
                defaults.set(ViewType.landscapeIPad.rawValue, forKey: key)
            }
        }
    }
}


//    static var currentCount: Int! {
//        get {
//
//            if let count = UserDefaults.standard.object(forKey: SettingKey.currentCount.rawValue) as? Int {
//                return count
//            } else {
//                return 3
//            }
//        }
//        set {
//            let defaults = UserDefaults.standard
//            let key = SettingKey.currentCount.rawValue
//
//            if let age = newValue {
//                print("value: \(age) was added to key \(key)")
//                defaults.set(age, forKey: key)
//            } else {
//                defaults.set(3, forKey: key)
//            }
//        }
//    }
