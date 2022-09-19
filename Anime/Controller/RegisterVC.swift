//
//  ViewController.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 27/08/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class RegisterVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPWTextfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPWTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let error = validateFields()
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPWTextfield.text, !confirmPassword.isEmpty else {
            errorLabel.text = error
            return
        }
        
        guard password == confirmPassword else {
            errorLabel.text = "Passwords Do Not Match"
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
            
            if err != nil {
                self.errorLabel.text = err!.localizedDescription
                self.errorLabel.alpha = 1
                
                
            } else {
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.confirmPWTextfield.text = ""
                self.performSegue(withIdentifier: K.registerSegue, sender: self)
            }
        }
    }
    
}





