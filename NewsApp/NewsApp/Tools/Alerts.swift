//
//  Alerts.swift
//  NewsApp
//
//  Created by Satsishur on 01.02.2021.
//

import UIKit

enum Alerts {
    static func showMessageAlert(viewController: UIViewController, titleMessage: String, message: String) {
        let alert = UIAlertController(title: titleMessage, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showChangePasswordAlert(viewController: UIViewController, titleMessage: String, message: String) {
        let alert = UIAlertController(title: titleMessage, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "password"
            //textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let password = alert?.textFields![0].text
            UserDefaults.standard.set(password, forKey: "password")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
          //print("Handle Cancel Logic here")
          }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    static func showEnterPasswordAlert(viewController: UIViewController, titleMessage: String, message: String, completion: @escaping((Bool) -> Void)) {
        let alert = UIAlertController(title: titleMessage, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            //textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let passwordEntered = alert?.textFields![0].text
            let passoword = UserDefaults.standard.value(forKey: "password") as! String
            
            if passwordEntered == passoword {
                completion(true)
            } else {
                completion(false)
            }
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}


