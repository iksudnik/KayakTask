//
//  ConstraintsBuilder.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

@resultBuilder
enum ConstraintsBuilder {
    static func buildBlock(_ components: ConstraintsConvertible...) -> [NSLayoutConstraint] {
        return components.flatMap { $0.constraints }
    }

    static func buildOptional(_ component: [ConstraintsConvertible]?) -> [NSLayoutConstraint] {
        return component?.flatMap { $0.constraints } ?? []
    }

    static func buildEither(first component: [ConstraintsConvertible]) -> [NSLayoutConstraint] {
        return component.flatMap { $0.constraints }
    }

    static func buildEither(second component: [ConstraintsConvertible]) -> [NSLayoutConstraint] {
        return component.flatMap { $0.constraints }
    }
}

// MARK: - ConstraintsConvertible

protocol ConstraintsConvertible {
    var constraints: [NSLayoutConstraint] { get }
}

extension NSLayoutConstraint: ConstraintsConvertible {
    var constraints: [NSLayoutConstraint] { [self] }
}

extension Array: ConstraintsConvertible where Element == NSLayoutConstraint {
    var constraints: [NSLayoutConstraint] { self }
}

// MARK: - NSLayoutConstraint Extensions

extension NSLayoutConstraint {
    static func activate(@ConstraintsBuilder constraints: () -> [NSLayoutConstraint]) {
        activate(constraints())
    }

    static func deactivate(@ConstraintsBuilder constraints: () -> [NSLayoutConstraint]) {
        deactivate(constraints())
    }
}

// MARK: - UIView Extensions

extension UIView {
    func getConstraintsToEdges(of superview: UIView, edges: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: edges.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: edges.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: edges.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: edges.bottom)
        ]
    }
}


