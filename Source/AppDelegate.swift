//
//  AppDelegate.swift
//  CatsLibrary
//
//  Created by Michal Fousek on 04.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private struct Depedencies {
        let flowCoordinator = DI.getFlowCoordinator()
    }
    private let deps = Depedencies()

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = deps.flowCoordinator.makeRootController()
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

}

