//
//  MoreAppsModel.swift
//  MyAppName MessagesExtension
//
//  Created by Алексей Пархоменко on 27.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import SDWebImage

class MoreAppsService {
    
    let developerId = "1288067083"
    let lookupUrl = "https://itunes.apple.com/lookup?id=%@&entity=software"
    
    var images = [UIImage?]()
    
    func getApps(completion: @escaping (Result<MoreAppsModel, Error>) -> Void) {
        
        let urlStr = String(format: lookupUrl, developerId)
        let url = URL(string: urlStr)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                DispatchQueue.main.async {
                    
                    do {
                        let model = try JSONDecoder().decode(MoreAppsModel.self, from: data)
                        completion(.success(model))
                    } catch {
                        completion(.failure(error))
                    }
                }
            } else {
                completion(.failure(error!))
            }
        
        }.resume()
    }
    
//    func getImages() {
//        getApps { (result) in
//            switch result {
//            case .success(let apps):
//                var appModels = [ResultModel]()
//                appModels = apps.results.filter { $0.artworkUrl100 != nil }
//                
//                for app in appModels {
//                    let imageView = UIImageView()
//                    imageView.sd_setImage(with: app.artworkUrl)
//                    self.images.append(imageView.image)
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
}
