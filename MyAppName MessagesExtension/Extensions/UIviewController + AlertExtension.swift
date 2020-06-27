//
//  UIviewController + AlertExtension.swift
//  MyAppName MessagesExtension
//
//  Created by Pavel Moroz on 26.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(with title: String, and message: String, isBuy: Bool?, completion: @escaping () -> Void = { }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if isBuy == true {
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel)
        let price = IAPService.shared.productPrice ?? "$0.99"
        let okAction = UIAlertAction(title: "Unlock \(price)", style: .default) { (_) in
            completion()
        }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
        } else {
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(okAction)
        }

        present(alertController, animated: true, completion: nil)
    }
}
