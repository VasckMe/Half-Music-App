//
//  AccountViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 22.10.22.
//

import UIKit
import FirebaseAuth

class AccountViewController: BaseViewController {

    
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passTextField.enablePasswordToggle()
        passTextField.delegate = self
        setupUI()
    }
    

    @IBAction private func logoutAction() {
        callClosureAlert(title: "Warning", message: "Are you sure to logout?") {
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "unwindToSignInVC", sender: nil)
            } catch {
                print("Auth signOut error")
            }
        }
    }
    @IBAction private func deleteAccountAction() {
//        callClosureAlert(title: "Warning", message: "Are you sure to logout?") {
//            FireBaseStorageManager.userRef.removeValue()
//            Auth.auth().currentUser?.delete()
//            self.performSegue(withIdentifier: "unwindToSignInVC", sender: nil)
//        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupUI() {
        FireBaseStorageManager.userRef.getData { [weak self] error, snapshot in
            if let error = error {
                print("Account setup getData error: \(error.localizedDescription)")
            } else {
                guard let snapshot = snapshot else {
                    return
                }
                
                guard
                    let snapshotValue = snapshot.value as? [String: Any],
                    let nickname = snapshotValue["nickname"] as? String,
                    let email = snapshotValue["email"] as? String,
                    let password = snapshotValue["password"] as? String
                else {
                    return
                }
                DispatchQueue.main.async {
                    self?.nicknameLabel.text = nickname
                    self?.emailLabel.text = email
                    self?.passTextField.text = password
                }
            }
        }
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


extension AccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
