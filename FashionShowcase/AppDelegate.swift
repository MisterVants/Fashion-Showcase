//
//  AppDelegate.swift
//  FashionShowcase
//
//  Created by André Vants Soares de Almeida on 01/05/19.
//  Copyright © 2019 Tinkerskull. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var appCoordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setSharedStyle()
        
        let appWindow = UIWindow(frame: UIScreen.main.bounds)
        window = appWindow
        appCoordinator = AppCoordinator(window: appWindow)
        appCoordinator?.start()
        return true
    }
    
    func setSharedStyle() {
        let titleTextAttributes = [NSAttributedString.Key.font: UIFont.gothamMedium(17),
                                   NSAttributedString.Key.foregroundColor: UIColor.App.smoothRed]
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
    }
}

