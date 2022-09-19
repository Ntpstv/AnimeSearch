//
//  FavVC.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 31/08/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
//import FirebaseFirestoreSwift

//private let reuseIdentifier = "Cell"
class FavVC: UIViewController {
    
    @IBOutlet var uiCollectionView: UICollectionView!
    //    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var amImage: UIImageView!
    @IBOutlet weak var amTitle: UILabel!
    @IBOutlet weak var amDetail: UILabel!
    
    //    var delegate: AMDataManagerDelegate?
    //    var mvTableViewCell = MoviesTableViewCell()
    let manager = AMDataManager()
    var amData = [Data]()
    var amItem = [Data]()
    var animeModel: Data?
    //    var listFromFB = [ItemsFromFB]()
    var favVCell = FavViewCell()
    //    var dataFromFB: [ItemsFromFB] = []
    var animeModelTemp: [Data] = []
    var amInfo: Data!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = UIImage(named: "FavMoviesTitle.png")
        let imageView = UIImageView(image:title)
        self.navigationItem.titleView = imageView
        
        uiCollectionView.register(FavViewCell.self, forCellWithReuseIdentifier: "FavViewCell")
        
//        fetchDataFromFB()
        //        getAMItem()
        self.uiCollectionView.reloadData()
        
    }
    
//    func fetchDataFromFB(){
//        db.collection("Favorite")
//            .order(by: "date")
//            .addSnapshotListener(){ (querySnapshot, error) in
//
//                self.animeModelTemp = []
//
//                if let e = error {
//                    print("There was an issue retrieving the data \(e)")
//                }else{
//                    if let snapshotDocuments = querySnapshot?.documents{
//                        for doc in snapshotDocuments{
//                            var data = doc.data()
//                            print("this is  the save one \(doc.data())")
//
//                            if let a = data["mal_id"] as? String {
//                                malIDs.append(a)
//                            }
////                            if let animeTemp = self.animeModel{
////
////                                data["Title"] = animeTemp.title ?? ""
////                                data["Synopsis"] = animeTemp.synopsis ?? ""
////                                data["Image"] = animeTemp.images?.jpg?.image_url ?? ""
////                                data["mal_id"] = animeTemp.mal_id
////                                data["url"] = animeTemp.url ?? ""
////                                data["score"] = animeTemp.score ?? 0.0;  {
////
////                                    let anime = Data(mal_id: animeTemp.mal_id, url: animeTemp.url, images: animeTemp.images, score: Double(animeTemp.score!), title: animeTemp.title, synopsis: animeTemp.synopsis)
////
////                                    self.animeModelTemp.append(anime)
////
////                                    DispatchQueue.main.async {
////                                        self.uiCollectionView.reloadData()
//                                    }
//                                }
//                            }
//                        }
//                    }
                    //    func getAMItem() {
                    //        manager.fetchAM(){(result) in
                    //            switch result{
                    //
                    //            case .success(let response):
                    //                print(response)
                    //                self.amData = response
                    //                self.amItem = response
                    //
                    //                self.uiCollectionView.reloadData()
                    //
                    //
                    //            case .failure(let error):
                    //                print(error.localizedDescription)
                    //
                }
                
//            }
//    }
//}



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
        
        
        let thirdVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        
        //FIXME: - check again
        let item = amData[indexPath.row]
        thirdVC.amInfo = item
        
        self.navigationController?.pushViewController(thirdVC, animated: true)
        
    }
    
}


