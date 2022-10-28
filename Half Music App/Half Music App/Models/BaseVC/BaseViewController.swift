//
//  BaseViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.10.22.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    func callDefaultAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func callClosureAlert(title: String, message: String, closure: @escaping () -> ()) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            closure()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    func callTextFieldAlert(title: String, message: String, completion: @escaping (_ textField: UITextField?) -> ()) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.enablePasswordToggle()
            textField.isSecureTextEntry = true
            textField.tintColor = Constants.globalTintColor
        }
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            completion(alertController.textFields?.first)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    func callAuthAlert(title: String, message: String, completion: @escaping (_ textField: UITextField?) -> ()) {
        callTextFieldAlert(title: title, message: message) { textField in
            completion(textField)
        }
    }
    
    func callAccountSettingsAlertSheet(
        title: String,
        password: String,
        editCompletion: @escaping  () -> (),
        logoutCompletion: @escaping  () -> (),
        deleteCompletion: @escaping  () -> ()
    ) {
        let alertController = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        alertController.view.tintColor = .red

        let edit = UIAlertAction(title: "Edit", style: .default) {_ in
            editCompletion()
        }
        
        let logout = UIAlertAction(title: "Logout", style: .default) {[weak self] _ in
            self?.callAuthAlert(title: "Logout", message: "Enter password to confirm") { textField in
                if textField?.text == password {
                    logoutCompletion()
                } else {
                    self?.callDefaultAlert(title: "Auth", message: "Bad password")
                }
            }
        }
        let delete = UIAlertAction(title: "Delete Account", style: .default) {[weak self]_ in
            self?.callAuthAlert(title: "Delete", message: "Enter password to confirm") { textField in
                if textField?.text == password {
                    deleteCompletion()
                } else {
                    self?.callDefaultAlert(title: "Auth", message: "Bad password")
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(edit)
        alertController.addAction(logout)
        alertController.addAction(delete)
        alertController.addAction(cancel)

        present(alertController, animated: true)
    }
}
