//
//  SceneDelegate.swift
//  sowhat
//
//  Created by a on 12/27/21.
//

import UIKit
import FirebaseAuth

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var authListener: AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        autoLogin()
        
        resetBudge()
       
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        resetBudge()
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        startUpdatingLocation()
        
        resetBudge()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        stopUpdatingLocation()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        resetBudge()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()        
        stopUpdatingLocation()
        resetBudge()
    }
    
    //: MARK: AUTOLOGIN
    func autoLogin() {
        authListener = Auth.auth().addStateDidChangeListener({ auth, user in
            
            Auth.auth().removeStateDidChangeListener(self.authListener!)
            
            if user != nil && userDefaults.object(forKey: kCURRENTUSER) != nil {
                DispatchQueue.main.async {
                    self.gotoApp()
                }
            }
        })
    } 

    private func gotoApp() {
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainApp") as! UIViewController
        
        window?.rootViewController = mainView
        
    }
    
    private func resetBudge() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func startUpdatingLocation() {
        
        if User.currentUser != nil {
            LocationManager.shared.startUpdating()
        }
    }
    
    private func stopUpdatingLocation() {
        
        if User.currentUser != nil {
            LocationManager.shared.stopUpdating()
        }
    }
}

