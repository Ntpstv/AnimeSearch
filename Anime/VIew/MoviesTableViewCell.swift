//
//  MoviesTableViewCell.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 28/08/2022.
//

import FirebaseAuth
import UIKit
import FirebaseFirestore
import ProgressHUD

protocol MoviesTableViewCellDelegate {
    func didLikeAnime()
    func didDislikeAnime()
    func fetchDataFromCell()
}

class MoviesTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var mvImage: UIImageView!
    @IBOutlet weak var mvTitleLabel: UILabel!
    @IBOutlet weak var mvDetailLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    
    //MARK: - Vars
    var animeModel: Data?
    var amData: AMData?
    var isTapped = false
    var movieTableView: MoviesVC?
    var loginVC: LoginVC?
    var delegate: MoviesTableViewCellDelegate?
    
    //    var dataFromFB: [ItemsFromFB] = []
    //    var listFromFB = [ItemsFromFB]()
    //    var id: String? = UUID().uuidString
    
    let url = URL(string: "https://cdn.myanimelist.net/images/anime/7/57855.jpg")
    var db = Firestore.firestore()
    var storeFavoriteItems: [AMData] = []
    
    
    //MARK: - ViewLifeCycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
    }
    
    
    
    //MARK: - Set isFavorite
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }
    
    func setDetail(animeInfo: Data){
       
        
        mvTitleLabel.text = animeInfo.title
        mvDetailLabel.text = animeInfo.synopsis
        mvImage.imageFromUrl(urlString: animeInfo.images?.jpg?.image_url ?? "")
        scoreLabel.text = "Score: \(animeInfo.score ?? 0)/10"
        animeModel = animeInfo
        
        if let isFavoriteTemp = animeInfo.isFavorite, isFavoriteTemp {
            isTapped = isFavoriteTemp
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
         
        }else{
            isTapped = false
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
           
        }
        if animeInfo.mal_id == 1{
            print("animeInfo.isFavorite: \(animeInfo.isFavorite ?? false)" )
        }
    }

    
    @IBAction func starIsTapped(_ sender: UIButton) {

        isTapped = !isTapped

        if isTapped {

            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            storedDataInFS()
        }else{

            sender.setImage(UIImage(systemName: "star"), for: .normal)
            unFavorite()

        }
    }
    
    // https://stackoverflow.com/questions/39464568/cannot-convert-value-of-type-uibutton-to-expected-argument-string
//    func showIsFavorite(isFavorite: Bool, limit: Int, completion: @escaping [AMData]){
//
//
//
//
//
//    }
    
    //MARK: - FirebaseFirestore
    func storedDataInFS(){
        
        guard let userID = Auth.auth().currentUser?.email else { return }
    
        if let animeTemp = animeModel {
            
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
        if let animeTemp = animeModel {
            
            var request = [String: Any]()
            
            request["title"] = animeTemp.title
            
            db.collection(userID).document(animeTemp.title!).delete()
            
            delegate?.fetchDataFromCell()
            
        }
        
    }
    
}




