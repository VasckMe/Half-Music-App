//
//  AccountViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 22.10.22.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else {
            return
        }

        title = "asd"
//        print(navigationController?.title)
//        print(title)

//        print("PRINT STARTED")
//        print(currentUser.displayName, currentUser.email)
//        currentUser.updateEmail(to: "delete.del@del.com") {error in
//            if let er = error {
//                print(er.localizedDescription)
//            }
//            print("Updated")
//            print(currentUser.displayName, currentUser.email)
//
//        }
//        currentUser.updatePassword(to: <#T##String#>)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
