//
//  ApiClient.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import Foundation

// MARK: - Interface

struct ApiClient {
    var airlines: () async throws -> [Airline]
}


// MARK: - Live client

extension ApiClient {
    static var live: Self {
        return Self(airlines: {
            let url = URL(string: AppLinks.airlines)!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let airLines = try JSONDecoder().decode([Airline].self, from: data)
            return airLines
        })
    }
}


// MARK: Mock client

extension ApiClient {
    static var mock: Self {
        return Self(airlines:  {
            return [.mock1, .mock2]
        })
    }
}
