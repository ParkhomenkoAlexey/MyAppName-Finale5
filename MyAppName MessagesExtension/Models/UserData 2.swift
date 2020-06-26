//
//  UserData.swift
//  MyAppName MessagesExtension
//
//  Created by Pavel Moroz on 25.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation

struct UserData {

    private let userDefaults:UserDefaults

    var productPurchased:Bool{
        get {
            return userDefaults.bool(forKey: IAPProduct.nonConsumable.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: IAPProduct.nonConsumable.rawValue)
        }
    }


    init() {
        self.userDefaults = Foundation.UserDefaults()
        userDefaults.register(defaults: [
                IAPProduct.nonConsumable.rawValue: false])
    }

}
