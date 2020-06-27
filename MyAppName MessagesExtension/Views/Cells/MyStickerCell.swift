//
//  MyStickerCell.swift
//  StikersApp MessagesExtension
//
//  Created by Алексей Пархоменко on 18.05.2020.
//  Copyright © 2020 Alexey Parkhomenko. All rights reserved.
//

import UIKit
import Messages

class MyStickerCell: UICollectionViewCell {
    
    static let reuseId = "MyStickerCell"
    
    var stickerView = MSStickerView()
    var lockButton = UIButton()
    
    private var allStickersUnlocked: Bool {
        return UserData().productPurchased
    }
    
    func configure(_ object: StickerModel) {
            
            if let sticker = object.sticker {
                stickerView.sticker = sticker
                stickerView.isUserInteractionEnabled = (object.isFree || allStickersUnlocked)
            }
            
            lockButton.isHidden = object.isFree || allStickersUnlocked
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lockButton.setImage(#imageLiteral(resourceName: "Lock icon"), for: .normal)
        
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        lockButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stickerView)
        stickerView.addSubview(lockButton)
        
        NSLayoutConstraint.activate([
            stickerView.topAnchor.constraint(equalTo: topAnchor),
            stickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lockButton.topAnchor.constraint(equalTo: stickerView.topAnchor),
            lockButton.leadingAnchor.constraint(equalTo: stickerView.leadingAnchor),
            lockButton.trailingAnchor.constraint(equalTo: stickerView.trailingAnchor, constant: 0),
            lockButton.bottomAnchor.constraint(equalTo: stickerView.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
