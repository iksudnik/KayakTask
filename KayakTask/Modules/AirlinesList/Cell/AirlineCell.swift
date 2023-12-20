//
//  AirlineCell.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

struct AirlineCellModel: Hashable {
    let id: String
    let title: String
    let imageURL: URL?
}

final class AirlineCell: UICollectionViewCell {
    
    private enum Sizes {
        static let sideOffset: CGFloat = 16
        static let logoHeight: CGFloat = 42
    }
    
    private let logoImageView = UIImageView.new {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel.new {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubviews(logoImageView, titleLabel)
        
        NSLayoutConstraint.activate {

            logoImageView.heightAnchor.constraint(equalToConstant: Sizes.logoHeight)
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor)
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                   constant: Sizes.sideOffset)
            
            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: Sizes.sideOffset)
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor,
                                                 constant: -Sizes.sideOffset)
            titleLabel.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor)
        }
    }
}

extension AirlineCell: Reusable {
    func setup(with data: AirlineCellModel) {
        titleLabel.text = data.title
        Task {
            await logoImageView.loadImage(from: data.imageURL,
                                          placeholder: ImagePlaceholderView.init)
        }
    }
}

// MARK: - Preview

private extension AirlineCellModel {
    static var mock = Self(id: "",
                           title: "Airline title",
                           imageURL: URL(string: "https://content.r9cdn.net/rimg/provider-logos/airlines/v/NK.png?crop=false&width=108&height=92&fallback=default1.png&_v=ee25ddeebebbac3394dc29d6b32e4b7b"))
}


#Preview(traits: .sizeThatFitsLayout) {
    let cell = AirlineCell(frame: .zero)
    cell.setup(with: .mock)
    return cell.contentView
}
