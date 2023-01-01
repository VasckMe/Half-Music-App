//
//  SignUpSuccessViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.12.22.
//

import UIKit

protocol SignUpSuccessViewControllerInterface: AnyObject {
    func writeNickname(nick: String)
}

final class SignUpSuccessViewController: UIViewController {
    
    @IBOutlet private weak var helloLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    var nickname: String?
    
    var presenter: SignUpSuccessPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didTriggerViewLoad()
    }
    
    
    @IBAction func continueButtonAction() {
        presenter?.didTriggerContinueButton()
    }
    
}

extension SignUpSuccessViewController: SignUpSuccessViewControllerInterface {
    func writeNickname(nick: String) {
        helloLabel.text = "Hello \(nick)"
    }
}
