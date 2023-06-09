//
//  SceneDelegate.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Networking
import Service
import Storage
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        registerServices()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = appRouter.rootViewController
        window.makeKeyAndVisible()
        appRouter.showLogin()
        self.window = window
    }

//    private func registerServices() {
//        Services.register(Storage.self) { () -> SQLiteStorage in
//            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            return SQLiteStorage(.uri("\(path)/db.sqlite3"))
//        }
//        Services.register(URLSessionNetworkingProtocol.self) { URLSessionNetworking.shared }
//        Services.register(ImageLoaderProtocol.self) { ImageLoader.shared }
//        Services.register(LoginProviderProtocol.self) { LoginProvider.shared }
//    }
}

private enum AppRoot {
    static let rootViewController = UINavigationController()
    static let appRouter = AppRouter(rootViewController: rootViewController)
}

private extension SceneDelegate {
    var appRouter: AppRouterProtocol { AppRoot.appRouter }
}
