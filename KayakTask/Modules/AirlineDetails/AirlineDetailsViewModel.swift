//
//  AirlineDetailsViewModel.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit
import Combine

struct InfoViewModel {
    let title: String
    let subtitle: String
}

final class AirlineDetailsViewModel {
    let title: String
    let infos: [InfoViewModel]
    let logoURL: URL?
    
    private let airline: Airline
    private let favoriteAirlinesClient: FavoriteAirlinesClient
    
    @Published private(set) var isFavorite: Bool
    
    init(airline: Airline, favoriteAirlinesClient: FavoriteAirlinesClient) {
        self.airline = airline
        self.favoriteAirlinesClient = favoriteAirlinesClient
        
        title = airline.name
        logoURL = airline.fixedLogoUrl
        
        var infos: [InfoViewModel] = [ .init(title: AppStrings.nameTitle,
                                             subtitle: airline.name) ]
        if !airline.phone.isEmpty {
            infos.append(.init(title: AppStrings.phoneTitle,
                               subtitle: airline.phone))
        }
        
        if !airline.site.isEmpty {
            infos.append(.init(title: AppStrings.websiteTitle,
                               subtitle: airline.site))
        }
        
        self.infos = infos
        
        isFavorite = favoriteAirlinesClient.isFavorite(airline)
    }
}

extension AirlineDetailsViewModel {
    func changeFavorite() {
        let wasFavorite = favoriteAirlinesClient.isFavorite(airline)
        if wasFavorite {
            favoriteAirlinesClient.removeFromFavorites(airline)
        } else {
            favoriteAirlinesClient.addToFavorites(airline)
        }
        
        isFavorite = !wasFavorite
    }
}


