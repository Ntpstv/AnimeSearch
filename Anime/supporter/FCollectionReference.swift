//
//  FCollectionReference.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 03/10/2022.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Like

    
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

