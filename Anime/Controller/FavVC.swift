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

class FavVC: UIViewController  {
    
    //MARK: - IBOutlets
    @IBOutlet var uiCollectionView: UICollectionView!
    @IBOutlet weak var emptyDataView: emptyData!
    
    //MARK: - Vars
    
    var filteredMovies = [Data]()
    var fetchFromDB = [Data]()
    
    let db = Firestore.firestore()
    
    //MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchIsFavFromDB()
        
        let title = UIImage(named: "FavMoviesTitle.png")
        let imageView = UIImageView(image:title)
        self.navigationItem.titleView = imageView
        
    }
    //MARK: - funcs
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
                            self.fetchFromDB.append(Data.convertJSONToData(dictionary: data))
                            
                            
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
            
            thirdVC.amInfo = filteredMovies[indexPath.row]
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
}


