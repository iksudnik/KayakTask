//
//  SceneDelegate.swift
//  KayakTask
//
//  Created by Ilya Sudnik on 20.12.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var rootCoordinator: RootCoordinator!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        rootCoordinator = RootCoordinator(window: window!, appContext: AppContext())
        rootCoordinator.start()
    }
}

