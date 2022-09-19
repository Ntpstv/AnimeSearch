//
//  MoviesTableViewCell.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 28/08/2022.
//

import FirebaseAuth
import UIKit
import FirebaseFirestore


protocol MovieTableViewCellDelegate: AnyObject{
    func delegateFromAMDataModel(anime: AMData)
}

class MoviesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mvImage: UIImageView!
    @IBOutlet weak var mvTitleLabel: UILabel!
    @IBOutlet weak var mvDetailLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    var animeModel: Data?
    var amData: AMData?
    var isTapped = false
    var movieTableView: MoviesVC?
    var delegate: MovieTableViewCellDelegate?
    

//    var dataFromFB: [ItemsFromFB] = []
//    var listFromFB = [ItemsFromFB]()
//    var id: String? = UUID().uuidString
    
    let url = URL(string: "https://cdn.myanimelist.net/images/anime/7/57855.jpg")
    
   var db = Firestore.firestore()
    
    override func awakeFromNib() {
        super.awakeFromNib()
 
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setDetail(animeInfo: Data){

        mvTitleLabel.text = animeInfo.title
        mvDetailLabel.text = animeInfo.synopsis
        mvImage.imageFromUrl(urlString: animeInfo.images?.jpg?.image_url ?? "")
        scoreLabel.text = "Score: \(animeInfo.score ?? 0)/10"
        animeModel = animeInfo
        if let isFavoriteTemp = animeInfo.isFavorite, isFavoriteTemp {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
        }else{
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        

    }
    override func prepareForReuse() {
        
    }
    
//    func starIsTapped(){
//        if starButton.isSelected == true {
//           starButton.isSelected = false
//            starButton.setImage(UIImage(named : "star"), for: UIControl.State.normal)
//         }else {
//           starButton.isSelected = true
//             starButton.setImage(UIImage(named : "star.fill"), for: UIControl.State.normal)
//         }
//    }
//
   @IBAction func starIsTapped(_ sender: UIButton) {

//       if let amData = amData{
//           delegate?.delegateFromAMDataModel(anime: amData)
//       }

               isTapped = !isTapped
               if isTapped {
       
                   sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
                   storedDataInFS()
       
               } else {
       
                   sender.setImage(UIImage(systemName: "star"), for: .normal)
       //        }
         //FIXME: fix the delete function
                   deleteFSdata()
       //
               }
       
       let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [animeModel], applicationActivities: nil)
       self.movieTableView?.present(activityViewController, animated: true, completion: nil)
//       activityViewController.isModalInPresentation = true

           }
    
// https://stackoverflow.com/questions/39464568/cannot-convert-value-of-type-uibutton-to-expected-argument-string
    
//       if let amData = amData{
//           delegate?.delegateFromAMDataModel(anime: amData)
//       }
//       func pressedTheStar(anime: AMData){
//           if starButton.isSelected == isTapped {
//               starButton.setImage(UIImage(named : "star.fill"), for: .normal)
//            }else {
//              starButton.isSelected = !isTapped
//                starButton.setImage(UIImage(named : "star"), for: .normal)
//            }
//       }
       
       
       

//        isTapped = !isTapped
//
//        if isTapped {
//
//            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
//            storedDataInFS()
//
//        } else {
//
//            sender.setImage(UIImage(systemName: "star"), for: .normal)
////        }
//  //FIXME: fix the delete function
//            deleteFSdata()
////
//        }
    
    
    func storedDataInFS(){
       
        if let animeTemp = animeModel {
            
            var request = [String: Any]()
            request["mal_id"] = animeTemp.mal_id
            request["title"] = animeTemp.title
            request["synopsis"] = animeTemp.synopsis
            request["images"] = animeTemp.images?.jpg?.image_url
            request["url"] = animeTemp.url
            request["score"] = animeTemp.score
            request["date"] = Date().timeIntervalSince1970
            
            db.collection("Favorite").addDocument(data: request)

        }
        
    }
    
    func deleteFSdata(){
        
        db.collection("Favorite").document("mal_id").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
//        let storage = dataFromFB
//                  let amID = listFromFB[indexPath.row].mal_id
//                  let storageRef = storage.reference(forURL: childsImageURL)
//
//                  storageRef.delete { error in
//                      if let error = error {
//                          print(error.localizedDescription)
//                      } else {
//                          print("File deleted successfully")
//                      }
//                  }
//
//
//                  // 2. Now Delete the Child from the database
//                  let name = childArray[indexPath.row].name
//
//                  let user = Auth.auth().currentUser
//                  let query = db.collection("users").document((user?.uid)!).collection("children").whereField("name", isEqualTo: name)
//
//                  print(query)
//
//
//                  childArray.remove(at: indexPath.row)
//                  tableView.deleteRows(at: [indexPath], with: .fade)
//
//              }
        
//        db.collection("Favorite").whereField("mal_id", isEqualTo: mal_id).getDocuments { (querySnapshot, error) in
//              if error != nil {
//                  print(error)
//              } else {
//                  for document in querySnapshot!.documents {
//                      document.reference.delete()
//                  }
//              }
//              }

//        let mal_id = Auth.auth().currentUser?.uid
//        db.collection("Favorite").whereField("uid", isEqualTo: mal_id).getDocuments() { (querySnapshot, err) in
//          if let err = err {
//            print("Error getting documents: \(err)")
//          } else {
//            for document in querySnapshot!.documents {
//              document.reference.delete()
//            }
//          }
//        }
      
//        db.collection("Favorite").document().delete()
//        let CurrentUser = Auth.auth().currentUser?.uid
//        let animeDocRef = db.collection("Favorite").document(CurrentUser!)
//
//        animeDocRef.getDocument { snapshot, error in
//            guard let document = snapshot else {
//                print("error getting documents: \(String(describing: error))")
//                return
//            }
//            let data = document.data()
//            if let id = data!["id"] as? String, id == animeDocId {
//                print("anime found")
//                animeDocRef.delete()
                
            }
//            completion(true)
//            print("delete the anime")
//        }
    
//            { err in
//                if let err = err {
//                    print("Error removing document: \(err)")
//                } else {
//                    print("Document successfully removed!")
//                }
//            }
//        }
//    func tableView(tableView: UITableView, cellForRowAtIndexPth indexPath: NSIndexPath) -> UITableViewCell{
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell") as! MoviesTableViewCell
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//
//        isTapped = !isTapped
//
//        if isTapped {
//
//            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
//            storedDataInFS()
//
//        } else {
//
//            starButton.setImage(UIImage(systemName: "star"), for: .normal)
//
//        }
//
//        return cell
//
//    }
 
//        db.collection("Favorite").document(id).delete()
    
    

        
    
}
