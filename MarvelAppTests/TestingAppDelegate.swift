//
//  TestingAppDelegate.swift
//  MarvelAppTests
//
//  Created by Luis Gustavo on 20/03/23.
//

import UIKit
import Storage
import Networking
import Service
@testable import MarvelApp

@objc(TestingAppDelegate)
final class TestingAppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
         registerServices()
        return true
    }

    private func registerServices() {
        Services.register(Storage.self) {
            SQLiteStorage(.inMemory)
        }
        Services.register(URLSessionNetworkingProtocol.self) { MockUrlSessionNetworking.shared }
        Services.register(ImageLoaderProtocol.self) { MockImageLoader.shared }
        Services.register(LoginProviderProtocol.self) { MockLoginProvider.shared }
    }
}
