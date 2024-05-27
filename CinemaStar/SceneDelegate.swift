// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

// swiftlint:disable all
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private var appCoordinator: AppCoordinator?
    var window: UIWindow?
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        setupWindow(scene: scene)
    }

    private func setupWindow(scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if let window {
            window.makeKeyAndVisible()
            let builder = AppBuilder()
            appCoordinator = AppCoordinator(appBuilder: builder)
            appCoordinator?.start()
        }
    }
}

func sceneDidDisconnect(_ scene: UIScene) {}
func sceneDidBecomeActive(_ scene: UIScene) {}
func sceneWillResignActive(_ scene: UIScene) {}
func sceneWillEnterForeground(_ scene: UIScene) {}
func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
}

// swiftlint:enable all
