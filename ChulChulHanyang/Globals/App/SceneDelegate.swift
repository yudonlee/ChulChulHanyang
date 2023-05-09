//
//  SceneDelegate.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()
        print(connectionOptions.urlContexts)
        widgetDeeplink(urlContexts: connectionOptions.urlContexts)
    }
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(URLContexts.first)
        widgetDeeplink(urlContexts: URLContexts)
    }
    
    private func widgetDeeplink(urlContexts: Set<UIOpenURLContext>) {
        guard let urlContext = urlContexts.first(where: { $0.url.scheme == "CCH-Widget-Deeplink"
        }), let restaurantName = urlContext.url.host else { return }
        
        let rootViewController = window?.rootViewController as? MainViewController
        rootViewController?.selectRestaurant(restaurant: restaurantName)
    }
}

