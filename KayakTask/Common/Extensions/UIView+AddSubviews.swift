//
//  UIView+AddSubviews.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
// 

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }
    
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
