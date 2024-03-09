//
//  SceneDelegate.swift
//  Transito Rio
//
//  Created by Rodrigo Amora on 29/11/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //changeViewController(viewController: OnibusViewController(), scene: scene)
        self.createUITabBarItem(selectedIndex: 0)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

    
    private func changeViewController(viewController: UIViewController, scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()
    }
    
    private func createUITabBarItem(selectedIndex: Int) {
        let onibusTabBarItem: UITabBarItem = UITabBarItem(title: String(localized: "tab_bar_onibus"), image: UIImage(systemName: "bus.fill"), tag: 0)
        let sobreTabBarItem: UITabBarItem = UITabBarItem(title: String(localized: "tab_bar_sobre"), image: UIImage(systemName: "info.circle"), tag: 1)
        
        let onibusViewController = OnibusViewController()
        onibusViewController.tabBarItem = onibusTabBarItem
        
        let sobreViewController = SobreViewController()
        sobreViewController.tabBarItem = sobreTabBarItem
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .gray
        tabBarController.viewControllers = [onibusViewController, sobreViewController]
        
        switch(selectedIndex) {
            case 0:
                tabBarController.selectedViewController = onibusViewController
                break

            case 1:
                tabBarController.selectedViewController = sobreViewController
                break

            default:
                tabBarController.selectedViewController = onibusViewController
                break
        }
        
        
        let navigationController = UINavigationController(rootViewController: tabBarController)
        navigationController.navigationBar.isHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

