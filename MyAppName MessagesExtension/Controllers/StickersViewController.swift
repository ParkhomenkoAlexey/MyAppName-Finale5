//
//  StickersViewController.swift
//  MyAppName MessagesExtension
//
//  Created by Алексей Пархоменко on 20.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import Messages
import StoreKit

protocol AppFeatureVCDelegate: class {
    func appFeatureVCDidSelectAdd()
}

class StickersViewController: UIViewController {
    
    var stickers = [StickerModel]()
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, StickerModel>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, StickerModel>! = nil
    
    weak var delegate: AppFeatureVCDelegate?
    
    var userData = UserData()
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAPService.shared.getProducts()
        IAPService.shared.iapServiceDelegate = self
        
        view.backgroundColor = .tertiarySystemBackground
        loadStickerData()
        setupCollectionView()
        setupDataSource()
        reloadData()
        
    }
    
    func loadStickerData() {
        if let path = Bundle.main.path(forResource: "StickerData", ofType: ".plist") {
            print("path: \(path)")
            if let data = NSArray(contentsOfFile: path) as? [Dictionary<String, Any>]{
                data.forEach { (item) in
                    let id = item["id"] as! Int
                    let name = item["name"] as! String
                    let isFree = item["isFree"] as! Bool
                    
                    let stickerObject = StickerModel(id: id, name: name, isFree: isFree)
                    if stickerObject.sticker != nil {
                        stickers.append(stickerObject)
                    }
                }
            }
        }
    }
    
    func purchaseProduct() {
        ActivityIndicatorManager.shared.startActivityIndicator(on: self)
        
        IAPService.shared.purchase(product: .nonConsumable)
    }
    
    func reloadData() {
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, StickerModel>()
        currentSnapshot.appendSections([.main])
        
        currentSnapshot.appendItems(stickers, toSection: .main)
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
        
    }
    
    // MARK: - Setup UI
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupCompositionalLayout())
        collectionView.backgroundColor = .tertiarySystemBackground
        
        collectionView.register(SectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SectionFooter.reuseId)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(MyStickerCell.self, forCellWithReuseIdentifier: MyStickerCell.reuseId)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let bottomArea = -(UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomArea, right: 0)
    }
    
    // MARK: - Layout
    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            let float = CGFloat(1 / Double(UserSettings.shared.currentCount))
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(float),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(float))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let sectionFooterSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(514))
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionFooterSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            
            sectionFooter.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -8, bottom: 0, trailing: -8)
            
            let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            if !self.userData.productPurchased {
                section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
            } else {
                section.boundarySupplementaryItems = [sectionHeader]
            }
            
            return section
        }
        return layout
    }
    
    // MARK: - Data Source
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, StickerModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, sticker) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyStickerCell.reuseId, for: indexPath) as! MyStickerCell
            
            cell.configure(self.stickers[indexPath.row])
            return cell
            
        })
        
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            print("kind", kind)
            
            if kind == "UICollectionElementKindSectionFooter" {
                if let sectionFooter = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionFooter.reuseId, for: indexPath) as? SectionFooter {
                    sectionFooter.delegate = self
                    sectionFooter.messageDelegate = self
                    return sectionFooter
                } else {
                    fatalError("Cannot create new supplementary")
                }
            } else {
                if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader {
                    sectionHeader.delegate = self
                    return sectionHeader
                } else {
                    fatalError("Cannot create new supplementary")
                }
            }
            
        }
    }
}

// MARK: - UICollectionViewDelegate
extension StickersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        purchaseProduct()
    }
    
    // MARK: - animate stikers
    func stickerCanAnimate(sticker: MSSticker) -> Bool {
        guard let stickerImageSource = CGImageSourceCreateWithURL(sticker.imageFileURL as CFURL, nil) else { return false }
        let stickerFrameCount = CGImageSourceGetCount(stickerImageSource)
        return stickerFrameCount > 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.reuseIdentifier == MyStickerCell.reuseId {
            let stickerCell = cell as! MyStickerCell
            if stickerCanAnimate(sticker: stickerCell.stickerView.sticker!) {
                stickerCell.stickerView.startAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.reuseIdentifier == MyStickerCell.reuseId {
            let stickerCell = cell as! MyStickerCell
            if stickerCell.stickerView.isAnimating() {
                stickerCell.stickerView.stopAnimating()
            }
        }
    }
}

// MARK: - IAPServiceDelegate

extension StickersViewController: IAPServiceDelegate {
    
    func failedRestored() {
        ActivityIndicatorManager.shared.stopActivityIndicator()
        self.showAlert(with: "You Have Nothing to Restore",
                       and: "This Apple ID has no registered purchases. You need to Unlock this Sticker Pack or use Free Version.",
                       isBuy: true) { [weak self] in
                        self?.purchaseProduct()
        }
    }
    
    
    func successTransactions() {
        ActivityIndicatorManager.shared.stopActivityIndicator()
        unlockAllItems()
    }
    
    func failedTransactions() {
        ActivityIndicatorManager.shared.stopActivityIndicator()
    }
    
    private func unlockAllItems() {
        userData.productPurchased = true
        collectionView.reloadData()
        self.showAlert(with: "Thank You!", and: "The Sticker Pack was successfully unlocked and you can use it right now.",
                       isBuy: false)
    }
    
}

// MARK: - Actions

extension StickersViewController: FooterButtonsDelegate, HeaderButtonsDelegate {
    
    func cubesButtonPressed() {
        let navigationVC = UINavigationController(rootViewController: CubeMenuViewController())
        navigationVC.navigationBar.barTintColor = .tertiarySystemBackground
        navigationVC.navigationBar.shadowImage = UIImage()
        navigationVC.navigationBar.isTranslucent = false
        
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.appFeatureVCDidSelectAdd()
        }
    }
    
    func loopButtonPressed() {
        if UserSettings.shared.currentCount > UserSettings.shared.viewType.rawValue + 2 {
            UserSettings.shared.currentCount = UserSettings.shared.viewType.rawValue
        } else {
            UserSettings.shared.currentCount += 1
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
    func unlockButtonPressed() {
        purchaseProduct()
    }
    
    func restoreButtonPressed() {
        ActivityIndicatorManager.shared.startActivityIndicator(on: self)
        IAPService.shared.restorePurchases()
    }
}

// MARK: - MessageExtensionDelegate
extension StickersViewController: MessageExtensionDelegate {
    
    func openStoreApp(id: String) {
        
        if let idNumber = Int(id) {
            openStoreProductWithiTunesItemIdentifier(idNumber)
        }
    }
    
    private func openStoreProductWithiTunesItemIdentifier(_ identifier: Int) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters, completionBlock: nil)
        present(storeViewController, animated: true, completion: nil)
    }
}

// MARK: - SKStoreProductViewControllerDelegate
extension StickersViewController: SKStoreProductViewControllerDelegate{
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
