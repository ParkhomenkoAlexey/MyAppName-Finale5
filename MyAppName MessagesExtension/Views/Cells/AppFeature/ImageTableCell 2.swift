//
//  ImageTableCell.swift
//  CompositionalTest
//
//  Created by Pavel Moroz on 22.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {

    static let reuseId = "ImageTableCell"

    var cubeImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupElements()
    }
    
    func setupCell(image: UIImage) {
        self.cubeImage.image = image
    }

    func setupElements() {
        
        backgroundColor = .tertiarySystemBackground

        cubeImage.translatesAutoresizingMaskIntoConstraints = false
        cubeImage.contentMode = .scaleAspectFit

        addSubview(cubeImage)

        NSLayoutConstraint.activate([
            cubeImage.topAnchor.constraint(equalTo: topAnchor),
            cubeImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            cubeImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            cubeImage.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
