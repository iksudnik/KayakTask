//
//  ImagePlaceholderView.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

final class ImagePlaceholderView: UIView {
    private let activityIndicator = UIActivityIndicatorView.new {
        $0.color = .white
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .accent
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate {
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        }
        
        activityIndicator.startAnimating()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
