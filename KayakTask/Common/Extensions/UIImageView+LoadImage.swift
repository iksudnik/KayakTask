//
//  UIImageView+LoadImage.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

/// Desided not to use external packages
/// like SDWebImage, Kingfisher or Nuke
/// 
/// In production I would prefer to use one of those libraries

extension UIImageView {
    func loadImage(from url: URL?,
                   placeholder: @MainActor () -> (UIView)) async {
        
        let subview = placeholder()

        await MainActor.run {
            addSubviews(subview)
            NSLayoutConstraint.activate {
                subview.getConstraintsToEdges(of: self)
            }
        }
        
        guard let url else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let serverImage = UIImage(data: data)
            
            await MainActor.run {
                subview.removeFromSuperview()
                image = serverImage
            }
        } catch { }
    }
}
