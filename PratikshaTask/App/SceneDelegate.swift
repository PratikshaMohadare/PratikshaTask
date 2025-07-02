//
//  SceneDelegate.swift
//  PratikshaTask
//
//  Created by Pratiksha on 01/07/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate  {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let portfolioVC = PortfolioViewController()
        let navigationController = UINavigationController(rootViewController: portfolioVC)
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}


