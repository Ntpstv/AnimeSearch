//
//  FavVC.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 31/08/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol FavVCDelegate: AnyObject {
    func favoriteIsChangedFromFavVCDelegate(animeMalID: Int, animeIsFav: Bool)
    func fetchDataFromCellFromFavVCDelegate()
}

class FavVC: UIViewController, AMDataManagerDelegate {
    func didUpdateAMData(_nytDataManager: AMDataManager, Results: Data) {
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
    //MARK: - IBOutlets
    @IBOutlet var uiCollectionView: UICollectionView!
    @IBOutlet weak var emptyDataView: emptyData!
    
    //MARK: - Vars
    
    var amInfo: Data?
    var filteredMovies = [Data]()
    var moviesFromAPI = [Data]()
    var fetchFromDB = [Data]()
    var favDelegate: FavVCDelegate?
    
    let db = Firestore.firestore()
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchIsFavFromDB()
        
        let title = UIImage(named: "FavMoviesTitle.png")
        let imageView = UIImageView(image:title)
        self.navigationItem.titleView = imageView
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        favDelegate?.fetchDataFromCellFromFavVCDelegate()
        
    }
    
    private func showEmptyDataView(){
        
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
            .order(by: kMALID)
            .getDocuments(completion: {(querySnapshot, error) in
                
                if let e = error {
                    print("There was an issue retriving data from Firestore. \(e)")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents {
                        
                        self.fetchFromDB = [Data]()
                        
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
                            var animeData = Data.convertJSONToData(dictionary: data)
                            animeData.isFavorite = true
                            
                            self.fetchFromDB.append(animeData)
                            
                        }
                        
                        if self.fetchFromDB.isEmpty{
                            self.showEmptyDataView()
                        }
                        DispatchQueue.main.async {
                            self.uiCollectionView.reloadData()
                            
                        }
                    }
                }
            })
        
    }
}

//MARK: - UICollectionView Delegate & DataSource

extension FavVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return fetchFromDB.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavViewCell", for: indexPath) as! FavViewCell
        
        if indexPath.row < fetchFromDB.count{
            
            let listFBTemp = fetchFromDB[indexPath.row]
            cell.setView(animeDetail: listFBTemp)
            return cell
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC{
            
            thirdVC.delegate = self
            thirdVC.amInfo = fetchFromDB[indexPath.row]
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
}

extension FavVC: DetailVCDelegate{
    func favoriteIsChangedFromDetailVCDelegate(animeMalID: Int, animeIsFav: Bool) {
        for (index, movieTemp) in filteredMovies.enumerated(){
            if movieTemp.mal_id == animeMalID {
                filteredMovies[index].isFavorite = animeIsFav
                
                var indexPathArray = [IndexPath]()
                indexPathArray.append(IndexPath(row: index, section: 0))
                
                uiCollectionView.reloadData()
                
            }
        }
        
        for (index, movieTemp) in moviesFromAPI.enumerated(){
            if movieTemp.mal_id == animeMalID {
                moviesFromAPI[index].isFavorite = animeIsFav
                
            }
        }
    }
    
    func fetchDataFromCellFromDetailVCDelegate() {
        fetchIsFavFromDB()
    }
}
