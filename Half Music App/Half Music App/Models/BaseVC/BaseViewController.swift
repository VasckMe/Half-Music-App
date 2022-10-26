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
        alertController.addTextField()
        
        let action = UIAlertAction(title: "Ok", style: .default) { action in
            completion(alertController.textFields?.first)
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
//    func callAuthAlert(title: String, message: String, completion: @escaping () -> ()) {
//        callTextFieldAlert(title: title, message: message) { textField in
//            <#code#>
//        }
//    }
}
