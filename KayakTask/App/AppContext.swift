//
//  AppContext.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import Foundation

struct AppContext {
    let apiClient = ApiClient.live
    let favoriteAirlinesClient = FavoriteAirlinesClient.live
}
