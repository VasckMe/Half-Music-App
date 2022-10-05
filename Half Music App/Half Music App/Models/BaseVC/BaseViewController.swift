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
}
