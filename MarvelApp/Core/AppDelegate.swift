//
//  AppDelegate.swift
//  MarvelApp
//
//  Created by Luis Gustavo on 16/03/23.
//

import Storage
import Networking
import Service
import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerServices()
        return true
    }

    private func registerServices() {
        Services.register(Storage.self) { () -> SQLiteStorage in
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            return SQLiteStorage(.uri("\(path)/db.sqlite3"))
        }
        Services.register(URLSessionNetworkingProtocol.self) { URLSessionNetworking.shared }
        Services.register(ImageLoaderProtocol.self) { ImageLoader.shared }
        Services.register(LoginProviderProtocol.self) { LoginProvider.shared }
    }
}
