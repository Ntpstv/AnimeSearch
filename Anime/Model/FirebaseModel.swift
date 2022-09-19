//
//  FirebaseModel.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 12/09/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

var animeModel: Data?

  var db = Firestore.firestore()

    
    func storedDataInFS(){
        
        if let animeTemp = animeModel {
            var request = [String: Any]()
            request["mal_id"] = animeTemp.mal_id
            request["title"] = animeTemp.title
            request["Synopsis"] = animeTemp.synopsis
            request["Image"] = animeTemp.images?.jpg?.image_url
            
            db.collection("Favorite").addDocument(data: request)
            
        }
    }
    
    func deleteFSdata() {
        
        let mal_id = Auth.auth().currentUser!.uid
        db.collection("Favorite").whereField("uid", isEqualTo: mal_id).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
//}
