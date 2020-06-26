//
//  MainTableCell.swift
//  CompositionalTest
//
//  Created by Pavel Moroz on 22.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class MainTableCell: UITableViewCell {
    
    static let reuseId = "MainTableCell"
    
    let mainLabel = UILabel()
    let descriptionLabel = UILabel()
    let actionButton = UIButton()
    
    var buttonClosure: (() -> ())?
    
    private var portraitConstraints: [NSLayoutConstraint] = []
    private var landscapeConstraints: [NSLayoutConstraint] = []
    
    private var portraitOrientation: Bool {
        let currentOrientation = UIDevice.current.orientation

        guard UIDevice.current.userInterfaceIdiom != .pad else { return false }
        
        return currentOrientation == .portrait || currentOrientation == .faceUp || currentOrientation == .faceDown || currentOrientation == .portraitUpsideDown || UIScreen.main.bounds.width < UIScreen.main.bounds.height
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainLabel.font = UIFont.sfProDisplaySemibold(ofSize: 20)
        descriptionLabel.font = UIFont.sfProTextRegular(ofSize: 16)
        
        descriptionLabel.numberOfLines = 0
        actionButton.layer.cornerRadius = 8
        
        mainLabel.textColor = .black
        descriptionLabel.textColor = .black
        
        actionButton.titleLabel?.font = UIFont.sfProTextSemibold(ofSize: 17)
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        setupElements()
        changeConstraints()
    }
    @objc func buttonTapped() {
        buttonClosure?()
    }
    
    func setupCell(appFeatureModel: AppFeatureCellModel) {
        self.mainLabel.text = appFeatureModel.title
        self.descriptionLabel.text = appFeatureModel.description
        self.actionButton.setTitle(appFeatureModel.buttonName, for: .normal)
        self.backgroundColor = appFeatureModel.color
        self.actionButton.backgroundColor = appFeatureModel.buttonColor
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if appFeatureModel.title == "ADD TO WHATSAPP" {
                self.mainLabel.text = "OPPS"
                self.descriptionLabel.text = "WhatsApp не имеет версии для iPad. Если вы хотите добавть стикеры в WhatsApp Вы можете сделать это на Вашем iPhone."
                self.actionButton.isHidden = true
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        changeConstraints()
    }
    
    private func changeConstraints() {
        if portraitOrientation {
            landscapeConstraints.forEach { $0.isActive = false }
            portraitConstraints.forEach { $0.isActive = true }
        } else {
            portraitConstraints.forEach { $0.isActive = false }
            landscapeConstraints.forEach { $0.isActive = true }
        }
    }
    
    private func setupElements() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainLabel)
        addSubview(descriptionLabel)
        addSubview(actionButton)
        
        portraitConstraints = [
            mainLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            actionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        landscapeConstraints = [
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            mainLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainLabel.widthAnchor.constraint(equalToConstant: 382),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 4),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 382),
            
            actionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 382),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
