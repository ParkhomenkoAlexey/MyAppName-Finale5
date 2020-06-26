//
//  AppCollectionCell.swift
//  StikersApp MessagesExtension
//
//  Created by Алексей Пархоменко on 18.05.2020.
//  Copyright © 2020 Alexey Parkhomenko. All rights reserved.
//

import UIKit
import Messages

class AppCollectionCell: UICollectionViewCell {
    
    static let reuseId = "AppCollectionCell"
    
    var appImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImage()
        
        appImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(appImageView)
        
        NSLayoutConstraint.activate([
            appImageView.topAnchor.constraint(equalTo: topAnchor),
            appImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            appImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            appImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupImage() {
        appImageView.layer.cornerRadius = 19.0
        appImageView.layer.borderWidth = 1.0
        appImageView.layer.borderColor = UIColor.clear.cgColor
        appImageView.layer.masksToBounds = true
        
        appImageView.layer.shadowColor = UIColor.lightGray.cgColor
        appImageView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        appImageView.layer.shadowRadius = 2.0
        appImageView.layer.shadowOpacity = 1.0
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        appImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
