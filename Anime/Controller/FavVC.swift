//
//  FavVC.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 31/08/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol FavVCDelegate{
    func didLikeAnime()
}

class FavVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var uiCollectionView: UICollectionView!
    @IBOutlet weak var emptyDataView: emptyData!
    
    //MARK: - Vars
    
    var movieVC = MoviesVC()
    var filteredMovies = [Data]()
    var amData = [Data]()
    let manager = AMDataManager()
    var favVCell = FavViewCell()
    var animeModel: Data?
    var delegate: FavVCDelegate?
    var amInfo: Data!
    //    var animeModelTemp: [Data] = []
    
    let db = Firestore.firestore()
    
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showEmptyDataView(loading:true)
        
        let title = UIImage(named: "FavMoviesTitle.png")
        let imageView = UIImageView(image:title)
        self.navigationItem.titleView = imageView
        
        uiCollectionView.register(FavViewCell.self, forCellWithReuseIdentifier: "FavViewCell")
        
//        manager.fetchAM() { result in
//            switch result{
//
//            case .success(let response):
//
//                print(response)
//                self.amData = response
//
//                self.uiCollectionView.reloadData()
//
//            case .failure(_):
//                break
//            }

            fetchIsFavFromDB()
   
    }
    
    //MARK: - funcs
    private func showEmptyDataView(loading: Bool){
        emptyDataView.isHidden = false
        
        let imageName = "catIsSoSad"
        let title = "No Data"
        let subTitle = "No anime cartoon favorite"
        
        emptyDataView.imageView.image = UIImage(named: imageName)
        emptyDataView.titleLabel.text = title
        emptyDataView.subtitleLabel.text = subTitle
        
    }
    
    func fetchIsFavFromDB(){
        
        guard let userID = Auth.auth().currentUser?.email else { return }
        
        db.collection(userID)
            .order(by: kDATE)
            .getDocuments() { (querySnapshot, error) in

                if let e = error {
                    print("There was an issue retriving data from Firestore. \(e)")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
                            
                            if let titleTemp = data[kTITLE] as? String,
//                               let imagesTemp = data[kIMAGES] as? String,
                               let synopsisTemp = data[kSYNOPSIS] as? String{
                                
                                for (index, movieTemp) in self.amData.enumerated(){
                                    if movieTemp.title == titleTemp,
//                                       movieTemp.images == imagesTemp,
                                       movieTemp.synopsis == synopsisTemp {
                                        
                                        self.amData[index].isFavorite = true
//                                        self.filteredMovies[index].isFavorite = true
                                        
                                        
                                    }
                                 
//                                    self.moviesFromAPI.filter({$0.title == titleTemp})
//                                    querySnapshot.isfavorite == true
                                }
                              
                            }
                            
                        }
                    }
                }
            }
    }
}





//MARK: - UICollectionView Delegate & DataSource

extension FavVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return amData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavViewCell", for: indexPath) as! FavViewCell
        
        if indexPath.row < amData.count{
            
            let listFBTemp = amData[indexPath.row]
            cell.setView(animeDetail: listFBTemp)
            return cell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC{
            
            thirdVC.amInfo = amData[indexPath.row]
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
    
}


