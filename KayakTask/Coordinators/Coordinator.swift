//
//  Coordinator.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

/// Just simplified version of Coordinator

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var rootViewController: UIViewController { get }
    
    func prepare() -> UIViewController?
    func start()
}

extension Coordinator {
    func addChild(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}
