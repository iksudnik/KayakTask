//
//  AirlinesCoordinator.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit
import Combine

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var rootViewController: UIViewController {
        navigationController
    }
    
    private var navigationController: UINavigationController = {
        let nc = UINavigationController()
        nc.navigationBar.tintColor = .accent
        return nc
    }()
    
    private let appContext: AppContext
    private var cancellables = Set<AnyCancellable>()
    
    init(appContext: AppContext) {
        self.appContext = appContext
    }
    
    func prepare() -> UIViewController? {
        return navigationController
    }
    
    func start() {
        let viewModel = AirlinesListViewModel(apiClient: appContext.apiClient,
                                              favoriteAirlinesClient: appContext.favoriteAirlinesClient)
        let viewController = AirlinesListViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
        
        viewModel.$selectedAirline
            .compactMap { $0 }
            .sink { [weak self] airline in
                self?.pushDetails(for: airline)
            }.store(in: &cancellables)
    }
    
    private func pushDetails(for airline: Airline) {
        let viewModel = AirlineDetailsViewModel(airline: airline,
                                                favoriteAirlinesClient: appContext.favoriteAirlinesClient)
        let vc = AirlineDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: true)
    }
}

