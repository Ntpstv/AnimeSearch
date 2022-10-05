//
//  FirebaseListener.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 03/10/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import ProgressHUD
import FirebaseAuth



class FirebaseListener {
    
    var FUser = [AMData]()
    
    static let shared = FirebaseListener()
    
    private init(){}
    
    
    
    
    //    MARK: - FUser
    func userExists(user: String, email: String) {
        
        FirebaseReference(.User).document(user).getDocument { [self] snapshot, error in
            
            guard let snapshot = snapshot else {return}
            
            if snapshot.exists {
                
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    let uid = user.uid
                    let email = user.email
                }
                
                userDefaults.synchronize()
            }else{
                
                if userDefaults.object(forKey: kCURRENTUSER) != nil{
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                        
                        let uid = user.uid
                        let email = user.email

                    }
                    saveUsertoFireStore()
                }
                
            }
            
        }
    }
    func saveUsertoFireStore(){
        FirebaseReference(.User).document(kEMAIL).setData(kEMAIL as Any as! [String : Any]){ error in
            
            if error != nil {
                print(error!.localizedDescription)
                
            }
            
        }
    }
    
}

