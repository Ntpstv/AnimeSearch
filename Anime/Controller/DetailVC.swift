//
//  DetailVC.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 29/08/2022.
//

import UIKit
import SafariServices
import FirebaseFirestore

class DetailVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amImage: UIImageView!
    @IBOutlet weak var amDetailLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var openWebsite: UIButton!
    @IBOutlet weak var addFav: UIButton!
    @IBOutlet weak var unFav: UIButton!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var mvTableViewCell: MoviesTableViewCell?
    var amInfo: Data?
    var isTapped = false
    var animeModel: Data?
//    var dataFromFirebase : ItemsFromFB?
   
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail"
        
        amImage.imageFromUrl(urlString: amInfo?.images?.jpg?.image_url ?? "")
        titleLabel.text = amInfo?.title
        amDetailLabel.text = amInfo?.synopsis
        scoreLabel.text = "Score: \(amInfo?.score ?? 0)/10"
        
        
    }
//    func favOrUnfavShow(){
//        if mvTableViewCell.starButton
//    }
    @IBAction func backBTPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

    }
    @IBAction func opebWebsiteButtonPressed(_ sender: UIButton) {
       
//        let user = sender.currentTitle
//        let openWebsite = amInfo.url
        
        guard let openWebsite = URL(string: amInfo?.url ?? "") else {
            return
        }
        
     let vc = SFSafariViewController(url: openWebsite)
     present(vc, animated: true)
    }
    
//    func favOrUnfavShow(){
//
//
//        if ((mvTableViewCell?.starButton) != nil) == isTapped {
//            addFav.isHidden
//        } else{
//            unFav.isHidden
//        }
//
//    }
    
    @IBAction func addFoviteButton(_ sender: UIButton) {
        isTapped = !isTapped

        if isTapped {
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

        } else {
            print("there is an error storing data to Firestore")
    }
        }
    }
//
//        func unFavoriteButton(_ sender: UIButton) {
//    }
//
//    func storedDataInFS(){
//
//        if let animeTemp = animeModel {
//            var request = [String: Any]()
//            request["mal_id"] = animeTemp.mal_id
//            request["title"] = animeTemp.title
//            request["synopsis"] = animeTemp.synopsis
//            request["images"] = animeTemp.images?.jpg?.image_url
//            request["url"] = animeTemp.url
//            request["score"] = animeTemp.score
//            request["date"] = Date().timeIntervalSince1970
//
//
//            db.collection("Favorite").addDocument(data: request)
//
//        }
//    }
}


