//
//  CubeMenuViewController.swift
//  CompositionalTest
//
//  Created by Pavel Moroz on 22.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

struct AppFeatureCellModel {
    var title: String
    var description: String
    var buttonName: String
    var color: UIColor
    var buttonColor: UIColor
    
    static var cells: [AppFeatureCellModel] = {
        return [
            AppFeatureCellModel(title: "ADD TO WHATSAPP",
                                description: "To add this Sticker Pack to WhatsApp push the button and follow instructions.",
                                buttonName: "Add Stickers to WhatsApp", color: #colorLiteral(red: 0.446657598, green: 1, blue: 0.5287287831, alpha: 1), buttonColor: .systemGreen),
            AppFeatureCellModel(title: "CHECK OUT SOME MORE",
                                description: "We’ve made lots of awesome apps and stickers. Feel free to try it out!",
                                buttonName: "Go to Developer Account", color: #colorLiteral(red: 0.9148025513, green: 0.6037712097, blue: 1, alpha: 1), buttonColor: .systemPurple),
            AppFeatureCellModel(title: "REVIEW",
                                description: "Rate us please! 5 stars review is what cheer us up! Thank you!",
                                buttonName: "Rate 5 ★", color: #colorLiteral(red: 1, green: 0.802816689, blue: 0, alpha: 1), buttonColor: .systemOrange)
        ]
    }()
}

class CubeMenuViewController: UIViewController {
    
    var tableView: UITableView!
    var stickerPack: StickerPack!

    var userData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchStickerPacks()
        setupNavigationBar()
        setupTableView()
    }
    
    private func fetchStickerPacks() {
        do {
            try StickerPackManager.fetchStickerPacks(fromJSON: StickerPackManager.stickersJSON(contentsOfFile: "sticker_packs")) { stickerPacks in
                
                self.stickerPack = stickerPacks[0]
                
            }
        } catch StickerPackError.fileNotFound {
            fatalError("sticker_packs.wasticker not found.")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func setupNavigationBar() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Button Back Light Mode Icon"), style: .plain, target: self, action: #selector(back))
        
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .tertiarySystemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(MainTableCell.self, forCellReuseIdentifier: MainTableCell.reuseId)
        tableView.register(ImageTableCell.self, forCellReuseIdentifier: ImageTableCell.reuseId)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.contentOffset.y = -16
        
    }
}

extension CubeMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableCell.reuseId, for: indexPath) as! ImageTableCell
            cell.selectionStyle = .none
            cell.setupCell(image: #imageLiteral(resourceName: "Footer Image"))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MainTableCell.reuseId, for: indexPath) as! MainTableCell
            
            let item = AppFeatureCellModel.cells[indexPath.row]
            cell.selectionStyle = .none
            cell.setupCell(appFeatureModel: item)
            cell.buttonClosure = { [weak self] in
                switch indexPath.row {
                case 0:
                    self?.goToWatsApp()
                case 1:
                    print("1")
                case 2:
                    self?.rateApp()
                default:
                    break
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 184
    }
}

extension CubeMenuViewController {

    private func goToWatsApp() {
        if self.userData.productPurchased == true {
            let loadingAlert: UIAlertController = UIAlertController(title: "Sending to WhatsApp", message: "\n\n", preferredStyle: .alert)
            loadingAlert.addSpinner()
            self.present(loadingAlert, animated: true)

            self.stickerPack.sendToWhatsApp { completed in
                loadingAlert.dismiss(animated: true)
            }
        } else {
            self.showAlert(with: "Attention!", and: "To add this Sticker Pack to WhatsApp, you need to Unlock it or Restore Your Purchase.", isBuy: true, completion: {
                IAPService.shared.purchase(product: .nonConsumable)
            })
        }
    }

    private func rateApp() {

        let id = "1288067083"
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/id\(id)?mt=8&action=write-review") else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
