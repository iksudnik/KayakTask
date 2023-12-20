//
//  AirlinesListViewController.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit
import Combine

enum Section: Int {
    case main
}

final class AirlinesListViewController: UIViewController {
    
    private enum Sizes {
        static let sideOffset: CGFloat = 16
        static let segmentedTopOffset: CGFloat = 8
    }
    
    private lazy var filterSegmentedControl: UISegmentedControl = {
        let segmented = UISegmentedControl(items: FilterType.allCases.map { $0.name })
        segmented.selectedSegmentIndex = UISegmentedControl.noSegment
        segmented.isEnabled = false
        segmented.translatesAutoresizingMaskIntoConstraints = false
        segmented.addTarget(self, action: #selector(didSelectItem), for: .valueChanged)
        return segmented
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let viewModel: AirlinesListViewModel
    private var dataSource: AirlinesListDataSource!
    
    private var cancellables = Set<AnyCancellable>()

    required init(viewModel: AirlinesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.title = AppStrings.airlinesTitle
        
        self.dataSource = .init(collectionView: collectionView)
        
        self.viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
            self?.didUpdate(with: state)
        }.store(in: &cancellables)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        
        view.addSubviews(filterSegmentedControl, collectionView)
        setConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        Task {
            await viewModel.loadData()
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate {
            filterSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                        constant: Sizes.segmentedTopOffset)
            filterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                            constant: Sizes.sideOffset)
            filterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                             constant: -Sizes.sideOffset)
            
            collectionView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor,
                                                constant: Sizes.sideOffset)
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                    constant: Sizes.sideOffset)
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                     constant: -Sizes.sideOffset)
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension AirlinesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        guard case .success = viewModel.viewState else { return }
        viewModel.didSelectItem(at: indexPath)
    }
}

// MARK: - UISegmentedControl action

private extension AirlinesListViewController {
    @objc func didSelectItem() {
        viewModel.filter(by: FilterType(rawValue: filterSegmentedControl.selectedSegmentIndex) ?? .all)
    }
}

// MARK: - AirlinesListViewModel updates

private extension AirlinesListViewController {
    func didUpdate(with state: ViewState) {
            switch state {
            case .idle:
                showEmptyState()
            case .loading:
                filterSegmentedControl.selectedSegmentIndex = FilterType.all.rawValue
                filterSegmentedControl.isEnabled = false
                showLoading()
            case let .success(airlines):
                contentUnavailableConfiguration = .none
                filterSegmentedControl.isEnabled = true
                dataSource.applySnapshot(items: airlines)
                if airlines.isEmpty {
                    showEmptyState()
                }
            case .error(_):
                showError()
                filterSegmentedControl.isEnabled = false
                dataSource.applySnapshot(items: [])
            }
    }
    
    func showEmptyState() {
        let isFavorite = viewModel.selectedFilter == .favorite
        var config = UIContentUnavailableConfiguration.empty()
        config.image = isFavorite ? UIImage(systemName: "heart") : UIImage(systemName: "airplane")
        config.text = isFavorite ? AppStrings.favoritesTitle : AppStrings.airlinesTitle
        config.secondaryText = AppStrings.emptyListTitle
        contentUnavailableConfiguration = config
    }
    
    func showLoading() {
        var config = UIContentUnavailableConfiguration.loading()
        config.text = AppStrings.loadingText
        config.textProperties.font = .boldSystemFont(ofSize: 18)
        contentUnavailableConfiguration = config
    }
    
    func showError() {
        var errorConfig = UIContentUnavailableConfiguration.empty()
        errorConfig.image = UIImage(systemName: "exclamationmark.circle.fill")
        errorConfig.text = AppStrings.fetchingErrorTitle
        errorConfig.secondaryText = AppStrings.fetchingErrorSubtitle
        
        var buttonConfig =  UIButton.Configuration.filled()
        buttonConfig.title = AppStrings.retryTitle
        errorConfig.button = buttonConfig
        
        errorConfig.buttonProperties.primaryAction = UIAction.init() { _ in
            
            Task { [weak self] in
                guard let self else { return }
                await viewModel.loadData()
            }
        }
        contentUnavailableConfiguration = errorConfig
    }
}

#Preview("Normal") {
    let vc = AirlinesListViewController(viewModel: .init(apiClient: .mock,
                                                         favoriteAirlinesClient: .mock))
    return vc
}


#Preview("Error") {
    let vc = AirlinesListViewController(viewModel: .init(apiClient: .init(airlines: { throw NSError() }),
                                        
                                                                                             favoriteAirlinesClient: .mock))
    return vc
}

#Preview("Empty") {
    let vc = AirlinesListViewController(viewModel:
            .init(apiClient: .init(airlines: { [] }),
                  
                  favoriteAirlinesClient: .mock))
    return vc
}
