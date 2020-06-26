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
        
        present(with: self.presentationStyle)
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        
        present(with: presentationStyle)
    }
    
    private func present(with presentationStyle:MSMessagesAppPresentationStyle) {
        
        let rootVC = StickersViewController()
        
        for child in children {

            
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        
        let navigationVC = UINavigationController(rootViewController: rootVC)
        
        
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


//class MessagesViewController: MSMessagesAppViewController {
//
//    override func willBecomeActive(with conversation: MSConversation) {
//        super.willBecomeActive(with: conversation)
//
//        print("124")
//        present(with: presentationStyle)
//    }
//
//    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
//        super.didTransition(to: presentationStyle)
//
//        present(with: presentationStyle)
//
//    }
//
//    private func present(with presentationStyle: MSMessagesAppPresentationStyle) {
//
//        let viewController = StickersViewController()
//
//        for child in children {
//            child.willMove(toParent: nil)
//            child.view.removeFromSuperview()
//            child.removeFromParent()
//        }
//
//        viewController.view.backgroundColor = .red
//            // Embed the new controller.
//            addChild(viewController)
//
//            viewController.view.frame = view.bounds
//            viewController.view.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(viewController.view)
//
//            viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//            viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//            viewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//
//            viewController.didMove(toParent: self)
//        }
//}
