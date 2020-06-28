//
//  SectionHeader.swift
//  MyAppName MessagesExtension
//
//  Created by Алексей Пархоменко on 27.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

protocol HeaderButtonsDelegate: class {
    func cubesButtonPressed()
    func loopButtonPressed()
}

class SectionHeader: UICollectionReusableView {
    
    static let reuseId = "SectionHeader"
    
    let cubesButton = UIButton(type: .system)
    let loopButton = UIButton(type: .system)
    
    weak var delegate: HeaderButtonsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .tertiarySystemBackground
        
        cubesButton.setImage(#imageLiteral(resourceName: "App Features Light Mode Icon"), for: .normal)
        loopButton.setImage(#imageLiteral(resourceName: "Sticker Size Changer Light Mode Icon"), for: .normal)
        
        cubesButton.addTarget(self, action: #selector(cubesButtonTapped), for: .touchUpInside)
        loopButton.addTarget(self, action: #selector(loopButtonTapped), for: .touchUpInside)
        
        cubesButton.translatesAutoresizingMaskIntoConstraints = false
        loopButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cubesButton)
        addSubview(loopButton)
        
        NSLayoutConstraint.activate([
            cubesButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cubesButton.topAnchor.constraint(equalTo: topAnchor),
            cubesButton.widthAnchor.constraint(equalToConstant: 40),
            cubesButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            loopButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            loopButton.topAnchor.constraint(equalTo: topAnchor),
            loopButton.widthAnchor.constraint(equalToConstant: 40),
            loopButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func cubesButtonTapped() {
        delegate?.cubesButtonPressed()
    }
    
    @objc func loopButtonTapped() {
        delegate?.loopButtonPressed()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
