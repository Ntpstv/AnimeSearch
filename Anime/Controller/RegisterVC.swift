//
//  ViewController.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 27/08/2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import ProgressHUD

class RegisterVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPWTextfield: UITextField!
    
    
    //MARK: - Var
    var FUser: Data?
    
    //MARK: - ViewLifCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupBackgroundTouch()
    }
    
    //MARK: - IBActions
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPWTextfield.text, !confirmPassword.isEmpty else {
            ProgressHUD.showError("Please fill in all fields!")
            return
        }
        
        guard password == confirmPassword else {
            ProgressHUD.showError("Passwords Do Not Match!")
            
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [self](authData, error)
            in
            
            
            if error != nil {
                ProgressHUD.showError( error!.localizedDescription)
                
            } else {
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                self.confirmPWTextfield.text = ""
                
                
                // creater user in database// if the user has the UID (authData)
                if authData?.user != nil {
                    let user = (_objectId: authData!.user.uid, _email: email)
                    
                    userDefaults.synchronize()
                    ProgressHUD.showSuccess("Your account has been created")
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }
        }
    }
    
    //MARK: - Setup
    private func setupBackgroundTouch() {
        
        backgroundView.isUserInteractionEnabled = true
        backgroundView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap(){
        print("tap")
        dismissKeyboard()
    }
    
    //MARK: - Helpers
    private func dismissKeyboard(){
        self.view.endEditing(false)
        
    }
    private func isTextDataImputed() -> Bool {
        
        return emailTextField.text != "" &&
        passwordTextField.text != "" &&
        confirmPWTextfield.text != ""
        
    }
}


