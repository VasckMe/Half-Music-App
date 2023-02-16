//
//  UIViewControllerExtension.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 1.02.23.
//

import UIKit

extension UIViewController {
    
    // MARK: - Internal
    
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
    
    func callClosureAlert(
        title: String,
        message: String,
        titleForAction: String = "Ok",
        closure: @escaping () -> ()) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
            let action = UIAlertAction(title: titleForAction, style: .default) { action in
            closure()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    func callAccountSettingsAlertSheet(
        password: String,
        editCompletion: @escaping  () -> (),
        logoutCompletion: @escaping  () -> (),
        deleteCompletion: @escaping  () -> ()
    ) {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        alertController.setTint(color: .white)
        alertController.setBackgroundColor(color: .darkGray)
        
        let edit = UIAlertAction(title: "Edit", style: .default) {_ in
            editCompletion()
        }
        
        let logout = UIAlertAction(title: "Logout", style: .default) {[weak self] _ in
            self?.callClosureAlert(
                title: "Logout",
                message: "Are you sure to logout?",
                closure: logoutCompletion)
        }
        
        let delete = UIAlertAction(title: "Delete Account", style: .default) {[weak self]_ in
            self?.callAuthAlert(
                title: "Delete",
                message: "Enter password to confirm"
            ) { textField in
                if textField?.text == password {
                    deleteCompletion()
                } else {
                    self?.callDefaultAlert(title: "Auth", message: "Bad password")
                }
            }
        }
        
        alertController.addAction(edit)
        alertController.addAction(logout)
        alertController.addAction(delete)
        
        present(alertController, animated: true) {
            self.addTapGestureToAlertController(alertController: alertController)
        }
    }
    
    func removeNotificationKBObservers() {
        NotificationCenter.default.removeObserver(self)

    }
    
    func addNotificationKBObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidShow),
            name: UIWindow.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidHide),
            name: UIWindow.keyboardWillHideNotification,
            object: nil
        )
    }
    
    // MARK: - Private
    
    private func addTapGestureToAlertController(alertController: UIAlertController) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert))
        alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
    }
    
    private func callTextFieldAlert(
        title: String,
        message: String,
        completion: @escaping (_ textField: UITextField?) -> ()
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alertController.addTextField { textField in
            textField.enablePasswordToggle()
            textField.isSecureTextEntry = true
            textField.tintColor = UIConstants.globalTintColor
        }
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            completion(alertController.textFields?.first)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    private func callAuthAlert(
        title: String,
        message: String,
        completion: @escaping (_ textField: UITextField?) -> ()
    ) {
        callTextFieldAlert(title: title, message: message) { textField in
            completion(textField)
        }
    }
    
    @objc private func kbDidShow(notification: Notification) {
        self.view.frame.origin.y = 0
        if let keyboardSize = (
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        )?.cgRectValue {
            self.view.frame.origin.y -= (keyboardSize.height / 2)
        }
    }
    
    @objc private func kbDidHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc private func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
}
