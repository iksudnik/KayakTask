//
//  Reusable.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import Foundation

protocol Reusable {
    associatedtype Data

    func setup(with data: Data)
    static func identifier() -> String
}

extension Reusable {
    static func identifier() -> String {
        return String(reflecting: self)
    }
}
