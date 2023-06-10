//
//  SceneDelegate.swift
//  PokemonApp
//
//  Created by Gilang-M1Pro on 08/06/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        
        let vc = PokemonDetailVC()
        let navigationController = UINavigationController.init(rootViewController: vc)
        
        window?.rootViewController = navigationController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
}

