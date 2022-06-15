//
//  SceneDelegate.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 25.05.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var passwordTextField = UITextField()
    var passwordValue: String? = nil
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        let navigationVC  = UINavigationController(rootViewController: viewController!)
        //        UINavigationBar.appearance().barTintColor = .gray
        //        UINavigationBar.appearance().tintColor = .black
        window?.rootViewController = navigationVC
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        passSetOrNot()

        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        passSetOrNot()
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        passSetOrNot()
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func passSetOrNot() {
        if passwordValue != nil {
            passwordIsOnAlert()
        } else if passwordValue == nil  {
            noPasswordAlert()
        }
    }
    //если пасс не задан
    func noPasswordAlert() {
        let passwordAlert = UIAlertController(title: "Set a password?", message: "Choose options", preferredStyle: .alert)
        let setPassword  = UIAlertAction(title: "Create password", style: .default) { _ in
            let passwordSetting = UIAlertController(title: "Set a password", message: "Create password using any characters", preferredStyle: .alert)
            passwordSetting.addTextField() { textField in
                self.passwordTextField = textField
            }
            let confirmSettingPassword = UIAlertAction(title: "Save", style: .default) { _ in
                self.passwordValue = self.passwordTextField.text!
            }
            passwordSetting.addAction(confirmSettingPassword)
            self.window?.rootViewController?.present(passwordSetting, animated: true)
            if self.passwordValue != self.passwordTextField.text {
                let errorAlert = UIAlertController(title: "Access denied", message: "Sorry, but password is incorrect", preferredStyle: .actionSheet)
                self.window?.rootViewController?.present(errorAlert, animated: true)
            }
        }
        let cancelAlert = UIAlertAction(title: "Dismiss", style: .default)
        passwordAlert.addAction(setPassword)
        passwordAlert.addAction(cancelAlert)
        window?.rootViewController?.present(passwordAlert, animated: true)
    }
    //если пас задан
    func passwordIsOnAlert() {
        let errorAlert = UIAlertController(title: "Access denied", message: "Use your password below", preferredStyle: .alert)
        errorAlert.addTextField() { textField in
            self.passwordTextField = textField
        }
        let confirmPasswordErorAlert = UIAlertAction(title: "Confirm", style: .default) { _ in
            if self.passwordTextField.text != self.passwordValue {
                let incorrectPasswordWorning = UIAlertController(title: "Password is incorrect", message: "Sorry, try again", preferredStyle: .alert)
                self.passSetOrNot()
                self.window?.rootViewController?.present(incorrectPasswordWorning, animated: true)
            } else {
                self.congratAlert()
            }
        }
        errorAlert.addAction(confirmPasswordErorAlert)
        self.window?.rootViewController?.present(errorAlert, animated: true)
    }
    
    //доступ разрешен
    func congratAlert() {
        let accessPermittedAlert = UIAlertController(title: "Congratulations!", message: "Access permitted", preferredStyle: .alert)
        self.window?.rootViewController?.present(accessPermittedAlert, animated: true)
        accessPermittedAlert.dismiss(animated: true)
    }
} // конец класса

