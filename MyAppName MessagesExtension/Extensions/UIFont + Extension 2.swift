//
//  UIFont + Extension.swift
//  StikersApp MessagesExtension
//
//  Created by Алексей Пархоменко on 18.05.2020.
//  Copyright © 2020 Alexey Parkhomenko. All rights reserved.
//

import UIKit

extension UIFont {
    
    static func sfProDisplaySemibold(ofSize size: CGFloat) -> UIFont? {
        return UIFont.init(name: "SFProDisplay-Semibold", size: size)
    }
    
    static func sfProTextSemibold(ofSize size: CGFloat) -> UIFont? {
        return UIFont.init(name: "SFProText-Semibold", size: size)
    }

    static func sfProTextRegular(ofSize size: CGFloat) -> UIFont? {
        return UIFont.init(name: "SFUIText-Regular", size: size)
    }
}

