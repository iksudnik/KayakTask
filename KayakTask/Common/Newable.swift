//
//  Newable.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

protocol Newable {
    init()
}

extension UIView: Newable {}

extension Newable where Self: UIView {
    static func new(_ creatorFunc: (Self) -> Void) -> Self {
        let instance = self.init()
        creatorFunc(instance)
        instance.translatesAutoresizingMaskIntoConstraints = false
        return instance
    }
}

