//
//  FavoritesClient.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import Foundation

protocol FavoritesClientProtocol {
    associatedtype Item: Identifiable
    var isFavorite: (Item) -> Bool  { get set }
    var addToFavorites: (Item) -> Void { get set }
    var removeFromFavorites: (Item) -> Void { get set }
}

// MARK: - Interface

struct FavoriteAirlinesClient: FavoritesClientProtocol {
    var isFavorite: (Airline) -> Bool = { _ in false }
    var addToFavorites: (Airline) -> Void
    var removeFromFavorites: (Airline) -> Void
}

// MARK: - Live client

extension FavoriteAirlinesClient {
    static var live: Self {
        let defaults = UserDefaults.standard
        let defaultsKey = "favoriteAirlineIds"
        
        var favoriteAirlineIds: Set<String> {
            get {
                Set(defaults.array(forKey: defaultsKey) as? [String] ?? [])
            }
            set {
                defaults.set(Array(newValue), forKey: defaultsKey)
            }
        }
        
        return .init(isFavorite: {
            favoriteAirlineIds.contains($0.id)
        }, addToFavorites: {
            favoriteAirlineIds.insert($0.id)
        }, removeFromFavorites: {
            favoriteAirlineIds.remove($0.id)
        })
    }
}

// MARK: - Mock client

extension FavoriteAirlinesClient {
    static var mock: Self {
        var favoriteAirlineIds = Set<String>()
        
        return .init(isFavorite: {
            favoriteAirlineIds.contains($0.id)
        }, addToFavorites: {
            favoriteAirlineIds.insert($0.id)
        }, removeFromFavorites: {
            favoriteAirlineIds.remove($0.id)
        })
    }
}
