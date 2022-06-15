//
//  SceneDelegate.swift
//  HW17_eldar
//
//  Created by Eldar Garbuzov on 25.05.22.
//

import UIKit
import KeychainSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var passwordTextField = UITextField()
    
    let keychain = KeychainSwift()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        let navigationVC  = UINavigationController(rootViewController: viewController!)
        window?.rootViewController = navigationVC
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        passSetOrNot()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        passSetOrNot()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
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
        if keychain.get("password") != nil  {
            passwordIsOnAlert()
        } else  {
            noPasswordAlert()
        }
    }
    //если пасс не задан
    func noPasswordAlert() {
        let passwordAlert = UIAlertController(title: "Set a password?", message: "Choose options", preferredStyle: .alert)
        let setPassword  = UIAlertAction(title: "Create password", style: .default) { _ in
            self.setPass()
            print(self.keychain.get("password"))
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
            if self.passwordTextField.text != self.keychain.get("password") {
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
    //пустое поле
    func emptyWorning() {
        let imptyWorningAlert = UIAlertController(title: "Uups!", message: "All fields should be filled", preferredStyle: .alert)
        let okImptyWorningAlert = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.passSetOrNot()
        }
        imptyWorningAlert.addAction(okImptyWorningAlert)
        self.window?.rootViewController?.present(imptyWorningAlert, animated: true)
        
    }
    
    func setPass() {
        let passwordSetting = UIAlertController(title: "Set a password", message: "Create password using any characters", preferredStyle: .alert)
   
        let confirmSettingPassword = UIAlertAction(title: "Save", style: .default) { _ in
            
            guard passwordSetting.textFields?.first?.text != "" else { return self.emptyWorning() }
            guard let passwordText = passwordSetting.textFields?.first?.text else { return }
            self.keychain.set(passwordText, forKey: "password")
            
//            guard let textPassword = self.passwordTextField.text else { return }
//            self.keychain.set(textPassword, forKey: "password")
            //                self.passwordValue = self.passwordTextField.text!
        }
        passwordSetting.addTextField()
        passwordSetting.addAction(confirmSettingPassword)
        self.window?.rootViewController?.present(passwordSetting, animated: true)
        //            if self.keychain.get("password") != self.passwordTextField.text {
        //                let errorAlert = UIAlertController(title: "Access denied", message: "Sorry, but password is incorrect", preferredStyle: .actionSheet)
        //                self.window?.rootViewController?.present(errorAlert, animated: true)
        //            }
    }
    
} // конец класса

