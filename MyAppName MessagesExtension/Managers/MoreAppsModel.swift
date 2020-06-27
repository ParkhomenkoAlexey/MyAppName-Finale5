//
//  MoreAppsModel.swift
//  MyAppName MessagesExtension
//
//  Created by Алексей Пархоменко on 27.06.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit

struct MoreAppsModel: Decodable {
    var results: [ResultModel]
}

struct ResultModel: Decodable {
    var artworkUrl100: String?
    var trackId: Int?
    
    var artworkUrl: URL? {
        return URL(string: artworkUrl100 ?? "")
    }
}
