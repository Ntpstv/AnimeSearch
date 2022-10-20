//
//  LoginVCViewController.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 27/08/2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import ProgressHUD

class LoginVC: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: - Var
    var db = Firestore.firestore()
    var animeModel: Data?
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        setupBackgroundTouch()
        
        navigationItem.hidesBackButton = true
        
        titleLabel.text = ""
        var charIndex   = 0.0
        let titleText   = "Anime"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.2 * charIndex, repeats: false) { (timer) in
                self.titleLabel.text?.append(letter)
            }
            
            charIndex += 1
            
        }
        
    }
    
    //MARK: - IBActions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                
                ProgressHUD.showError(error!.localizedDescription)
                
            } else {
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                self.goToApp()
                
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
    private func goToApp(){
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav_MoviesVC")
        
        self.present(mainView, animated: true)
        
    }
    
}

