//
//  AirlinesListViewModel.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import Foundation
import Combine

enum ViewState {
    case idle
    case loading
    case success([AirlineCellModel])
    case error(Error)
}

enum FilterType: Int, CaseIterable {
    case all
    case favorite
    
    var name: String {
        switch self {
        case .all: return AppStrings.allTitle
        case .favorite: return AppStrings.favoritesTitle
        }
    }
}


final class AirlinesListViewModel {
    
    private let apiClient: ApiClient
    private let favoriteAirlinesClient: FavoriteAirlinesClient
    
    private var allAirlines: [Airline] = []
    private var filteredAirlnes: [AirlineCellModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var selectedFilter: FilterType = .all
    
    @Published private(set) var viewState: ViewState = .idle
    @Published private(set) var selectedAirline: Airline? = nil
    
    init(apiClient: ApiClient, favoriteAirlinesClient: FavoriteAirlinesClient) {
        self.apiClient = apiClient
        self.favoriteAirlinesClient = favoriteAirlinesClient
        
        $selectedFilter
            .removeDuplicates()
            .sink { [weak self] filter in
                self?.filterAirlines(by: filter)
            }.store(in: &cancellables)
    }
}

// MARK: - Public

extension AirlinesListViewModel {
    func loadData() async {
        allAirlines = []
        filteredAirlnes = []
        
        viewState = .loading
        do {
            allAirlines = try await apiClient.airlines()
            filteredAirlnes = allAirlines.map { $0.toAirlineCellModel() }
            viewState = .success(filteredAirlnes)
        } catch {
            viewState = .error(error)
        }
    }
    
    func filter(by type: FilterType) {
        selectedFilter = type
    }
        
    func didSelectItem(at indexPath: IndexPath) {
        let airlineCellModel = filteredAirlnes[indexPath.item]
        selectedAirline = allAirlines.first { $0.id == airlineCellModel.id }
    }
}

// MARK: - Private

private extension AirlinesListViewModel {
    func filterAirlines(by filter: FilterType) {
        switch filter {
        case .all:
            filteredAirlnes = allAirlines.map { $0.toAirlineCellModel() }
        case .favorite:
            filteredAirlnes = allAirlines
                .filter(favoriteAirlinesClient.isFavorite)
                .map { $0.toAirlineCellModel() }
        }
        
        viewState = .success(filteredAirlnes)
    }
}

private extension Airline {
    func toAirlineCellModel() -> AirlineCellModel {
        .init(id: id, title: name, imageURL: fixedLogoUrl)
    }
}
