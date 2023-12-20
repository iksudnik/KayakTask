//
//  InfoView.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

final class InfoView: UIStackView {
    private let titleLabel = UILabel.new {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let subtitleLabel = UILabel.new {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
    
    init(viewModel: InfoViewModel) {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .firstBaseline
        spacing = 4
        
        [titleLabel, subtitleLabel].forEach { addArrangedSubview($0) }
        
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }

    @available(*, unavailable)
    required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

