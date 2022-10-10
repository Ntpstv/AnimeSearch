//
//  DetailVC.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 29/08/2022.
//

import UIKit
import SafariServices
import FirebaseFirestore
import FirebaseAuth

protocol DetailVCDelegate: AnyObject {
    func favoriteIsTriggered(animeMalID: Int, animeIsFav: Bool)
    func fetchDataFromCell()
}

class DetailVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amImage: UIImageView!
    @IBOutlet weak var amDetailLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var addFav: UIButton!
    @IBOutlet weak var unFav: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var uiScrollView: UIScrollView!
    
    
    //MARK: - Vars
    
    var mvTableViewCell: MoviesTableViewCell?
    var movieVC: MoviesVC?
    var delegate: DetailVCDelegate?
    var amInfo: Data?
    var animeModel: Data?
    var isTapped = false
    var filteredMovies = [Data]()
    var moviesFromAPI = [Data]()
    var fetchFromDB = [Data]()
    
    let db = Firestore.firestore()
    
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail"
        
//        amImage.imageFromUrl(urlString: amInfo?.images?.jpg?.image_url ?? "")
//        titleLabel.text = amInfo?.title
//        amDetailLabel.text = amInfo?.synopsis
//        scoreLabel.text = "Score: \(amInfo?.score ?? 0)/10"
        
//        let items = movieVC?.filteredMovies[indexPath.row]
        setDetail(animeInfo: amInfo ?? Data())

//        delegate = self
        
//        hideAddFavBtnIfItemIsAlreadyAdded()

    }
    
    
    //MARK: - func Set Detail
    func setDetail(animeInfo: Data){
        self.amImage?.imageFromUrl(urlString: animeInfo.images?.jpg?.image_url ?? "")
        self.titleLabel?.text = animeInfo.title
        self.amDetailLabel?.text = animeInfo.synopsis
        self.scoreLabel?.text = "Score: \(animeInfo.score ?? 0)/10"
        
        
        if let isFavoriteTemp = animeInfo.isFavorite, isFavoriteTemp {
            isTapped = isFavoriteTemp
            
            self.addFav?.isHidden = true
            self.unFav?.isHidden = false
        }else{
            isTapped = false
            
            self.addFav?.isHidden = false
            self.unFav?.isHidden = true
        }
    }
  
    //MARK: - IBActions
    
    @IBAction func backBTPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func openWebsiteButtonPressed(_ sender: UIButton) {
        
        guard let openWebsite = URL(string: amInfo?.url ?? "") else {
            return
        }
        
        let vc = SFSafariViewController(url: openWebsite)
        present(vc, animated: true)
    }
    
    @IBAction func addFoviteButton(_ sender: UIButton){
        
        delegate?.favoriteIsTriggered(animeMalID:  animeModel?.mal_id ?? 0, animeIsFav: isTapped)
   
        if self.navigationController != nil{
            print("pressed: fav is added")
            addFav.isHidden = true
            unFav.isHidden = false
            
           
            storedDataInFS()
            
        }
    }
    
    
    @IBAction func unFavoriteBtnIsPressed(_ sender: UIButton) {
        
        delegate?.favoriteIsTriggered(animeMalID:  animeModel?.mal_id ?? 0, animeIsFav: isTapped)
        
        if self.navigationController != nil {
            print("pressed: unfav")
            addFav.isHidden = false
            unFav.isHidden = true
            
            unFavorite()
        }
    }
    //MARK: - Firestore
    func storedDataInFS(){
        
        guard let userID = Auth.auth().currentUser?.email else { return }
        
        if let animeTemp = amInfo {
            
            var request = [String: Any]()
            request[kMALID] = animeTemp.mal_id
            request[kTITLE] = animeTemp.title
            request[kSYNOPSIS] = animeTemp.synopsis
            request[kIMAGES] = animeTemp.images?.jpg?.image_url
            request[kURL] = animeTemp.url
            request[kSCORE] = animeTemp.score
            request[kDATE] = Date().timeIntervalSince1970
            
            
            self.db.collection(userID).document(animeTemp.title!).setData(request)
            
        }
    }
    
    func unFavorite() {
        guard let userID = Auth.auth().currentUser?.email else { return }
        if let animeTemp = amInfo {
            
            var request = [String: Any]()
            
            request["title"] = animeTemp.title
            
            db.collection(userID).document(animeTemp.title!).delete()
            
            delegate?.fetchDataFromCell()
        }
    }
    
//    func hideAddFavBtnIfItemIsAlreadyAdded(){
//
//        guard let user = Auth.auth().currentUser?.email else { return }
//
//        db.collection(user)
//            .order(by: kDATE)
//            .getDocuments(completion: {querySnapshot, error in
//
//                if let e = error {
//                    print("There was an issue retrieving the data \(e)")
//                }else{
//                    if let snapshotDocuments = querySnapshot?.documents {
//
//                        self.fetchFromDB = [Data]()
//
//                        for doc in snapshotDocuments{
//
//                            let data = doc.data()
//                            self.fetchFromDB.append(Data.convertJSONToData(dictionary: data))
//                            //
//                            //                            print("this is  the save one \(doc.data())")
//                            if let malIDTemp = data[kMALID] as? Int {
//
//                                for (index, movieTemp) in self.moviesFromAPI.enumerated(){
//                                    if movieTemp.mal_id == malIDTemp {
//
//                                        self.moviesFromAPI[index].isFavorite = true
//
//                                    }
//                                }
//                                for (index, movieTemp) in self.filteredMovies.enumerated(){
//                                    if movieTemp.mal_id == malIDTemp {
//
//                                        self.filteredMovies[index].isFavorite = true
//
//                                    }
//                                }
//                                if self.titleLabel.text == doc.documentID {
//                                    self.unFav.isHidden = false
//                                    self.addFav.isHidden = true
//
//                                }
//
//                            }
//                        }
//                    }
//                }
//            })
//    }
}

//extension DetailVC: DetailVCDelegate {
//
//    func favoriteIsTriggered(animeMalID: Int, animeIsFav: Bool) {
//        for (index, movieTemp) in filteredMovies.enumerated(){
//            if movieTemp.mal_id == animeMalID {
//                filteredMovies[index].isFavorite = animeIsFav
//
//            }
//        }
//        for (index, movieTemp) in moviesFromAPI.enumerated(){
//            if movieTemp.mal_id == animeMalID {
//                moviesFromAPI[index].isFavorite = animeIsFav
//
//            }
//        }
//    }
//
//    func fetchDataFromCell() {
//
//    }
//}


