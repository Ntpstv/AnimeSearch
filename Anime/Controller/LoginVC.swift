//
//  LoginVCViewController.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 27/08/2022.
//

import UIKit
import FirebaseAuth


class LoginVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        isStayedLoggedIn()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let email    = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            if error != nil {
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
                
            } else {
                
                self.emailTextField.text = ""
                self.passwordTextField.text = ""

                let goToMoviesVC = self.storyboard?.instantiateViewController(withIdentifier: "Nav_MoviesVC")
                    
                    self.present(goToMoviesVC!, animated: true )
                    //                self.navigationController?.pushViewController(goToMoviesVC!, animated: true)
                    
                    
                    //                self.performSegue(withIdentifier: K.loginSegue, sender: self)
                
            }
        }
    }
    
    func isStayedLoggedIn() {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if Auth.auth().currentUser != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
                let goToMoviesVC = storyboard.instantiateViewController(withIdentifier: "Nav_MoviesVC")
                    goToMoviesVC.modalPresentationStyle = . fullScreen
                    self.present(goToMoviesVC, animated: true)

                
            }
            //        return UserDefaults.standard.bool(forKey: "isStayLoggedIn")
        }
    }
}



