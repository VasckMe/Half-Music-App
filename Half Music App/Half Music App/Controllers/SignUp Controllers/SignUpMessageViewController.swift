//
//  SignUpMessageViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.10.22.
//

import UIKit

final class SignUpMessageViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var nickname: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nick = nickname else {
            return
        }
        helloLabel.text = "Hello \(nick)!"
    }
}
