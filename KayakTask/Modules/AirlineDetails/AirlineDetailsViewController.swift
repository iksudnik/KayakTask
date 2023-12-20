//
//  AirlineDetailsViewController.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit
import Combine

class AirlineDetailsViewController: UIViewController {
    
    private enum Sizes {
        static let spacing: CGFloat = 16
        static let imageWidth: CGFloat = 180
        static let buttonHeight: CGFloat = 46
    }
    
    private let logoImageView = UIImageView.new {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var infoStackView = UIStackView.new { stackView in
        stackView.axis = .vertical
        stackView.spacing = Sizes.spacing
        stackView.alignment = .leading
    }
    
    private let favoriteButton = UIButton.new {
        $0.backgroundColor = .accent
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let viewModel: AirlineDetailsViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    required init(viewModel: AirlineDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        update(for: viewModel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, infoStackView, favoriteButton)
        setConstraints()
        
        favoriteButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate {
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizes.spacing)
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            logoImageView.widthAnchor.constraint(equalToConstant: Sizes.imageWidth)
            
            infoStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: Sizes.spacing)
            infoStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.spacing)
            infoStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.spacing)
            
            favoriteButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: Sizes.spacing)
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.spacing)
            favoriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.spacing)
            favoriteButton.heightAnchor.constraint(equalToConstant: Sizes.buttonHeight)
            
        }
    }
}


private extension AirlineDetailsViewController {
    
    @objc func buttonAction() {
        viewModel.changeFavorite()
    }
    
    func update(for viewModel: AirlineDetailsViewModel) {
        
        title = viewModel.title
        
        viewModel.infos.forEach {
            infoStackView.addArrangedSubview(InfoView(viewModel: $0))
        }
        
        Task {
            await logoImageView.loadImage(from: viewModel.logoURL,
                                          placeholder: ImagePlaceholderView.init)
        }
        
        viewModel.$isFavorite
            .sink { [weak self] isFavorite in
                let title = isFavorite ? AppStrings.unfavoriteTitle : AppStrings.favoriteTitle
                self?.favoriteButton.setTitle(title, for: .normal)
            }
            .store(in: &cancellables)
    }
}


#Preview {
    let viewModel = AirlineDetailsViewModel(airline: .mock1,
                                            favoriteAirlinesClient: .mock)
    return AirlineDetailsViewController(viewModel: viewModel)
}
