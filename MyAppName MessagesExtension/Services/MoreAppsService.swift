//
//  MoreAppsModel.swift
//  MyAppName MessagesExtension
//
//  Created by Алексей Пархоменко on 27.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

class MoreAppsService {
    
    let developerId = "1288067083"
    let lookupUrl = "https://itunes.apple.com/lookup?id=%@&entity=software"
    
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
}
