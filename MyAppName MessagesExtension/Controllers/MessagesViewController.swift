//
//  MessagesViewController.swift
//  MyAppName MessagesExtension
//
//  Created by Алексей Пархоменко on 20.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import Messages

protocol MessageExtensionDelegate: class {
    func openStoreApp(id: String)
}

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        
        let rootVC = StickersViewController()
        
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        rootVC.delegate = self
        let navigationVC = UINavigationController(rootViewController: rootVC)
        
        navigationVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationVC.navigationBar.shadowImage = UIImage()
        
        let viewController = navigationVC
        
        addChild(viewController)
        
        viewController.view.frame = view.bounds
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        
        viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        viewController.didMove(toParent: self)
    }
}

extension MessagesViewController: AppFeatureVCDelegate {
    func appFeatureVCDidSelectAdd() {
        requestPresentationStyle(.expanded)
    }
}
