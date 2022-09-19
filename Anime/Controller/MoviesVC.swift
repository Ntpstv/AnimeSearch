//
//  MoviesVC.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 27/08/2022.
//

import UIKit
import CoreData
import Alamofire
import FirebaseAuth
import FirebaseFirestore


class MoviesVC: UIViewController, UITextFieldDelegate, AMDataManagerDelegate {
    func didUpdateAMData(_nytDataManager: AMDataManager, Results: Data) {
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    @IBOutlet weak var movieListTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bookMark: UIBarButtonItem!
    
    private var search: [AMData] = []
    let manager = AMDataManager()
    var filteredMovies = [Data]()
    var moviesFromAPI = [Data]()
    var moviesTableViewCell = MoviesTableViewCell()
    var animeNameTextField: UITextField!
    var delegate: AMDataManagerDelegate?
    var animeModel: Data?
    var isTapped: Bool = false
    
    let animeURL = "https://api.jikan.moe/v4/anime?"
    var url = "https://cdn.myanimelist.net/images/anime/7/57855.jpg"
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        let title = UIImage(named: "AMMovie.png")
        let imageView = UIImageView(image:title)
        self.navigationItem.titleView = imageView
        getAMItem()
        
        animeNameTextField?.delegate = self
        searchBar.delegate = self
        
        self.movieListTV.reloadData()
        //        loadAnimeFromBookmarkSearch()
    }
    
    
    @IBAction func logOutButton(_ sender: UIButton) {
        //        let auth = Auth.auth()
        
        do {
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
            print("log out btn is pressed")
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    
    //MARK: - textfield delegate
    @IBAction func bookmarkPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Movies name", message: "Please enter movie name", preferredStyle: .alert)
        alert.addTextField { (moviesNameTextField) in
            
            self.animeNameTextField = moviesNameTextField
            
            moviesNameTextField.placeholder = "Movie name"
            moviesNameTextField.keyboardType = UIKeyboardType.default
            
            if self.animeNameTextField.text != nil{
                self.searchInBookmark()
                
            }
            
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okHandler))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func okHandler(action: UIAlertAction) -> Void {
        
        //    if let text = animeNameTextField.text, !text.isEmpty {
        //        storeDataFromBM()
        //    } else {
        //        return
        //    }
        
        guard let text = animeNameTextField.text, !text.isEmpty else{
            return
        }
        
        searchInBookmark()
        
        //
        //    isTapped = !isTapped
        //
        //
        //    if isTapped {
        //
        //        storeDataFromBM()
        //
        //    } else {
        //
        //print("data is not saved")
        //
        //    }
        self.movieListTV.reloadData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(animeNameTextField.text!)
        return true
    }
    
    func searchInBookmark(){
        manager.searchFromBookmark(with: animeNameTextField.text ?? "") {(result) in
            switch result{
                
            case .success(let response):
                print(response)
                self.filteredMovies = response
                self.moviesFromAPI = response
                
                self.movieListTV.reloadData()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
}

//MARK: - TableView Delegate
extension MoviesVC: UITableViewDelegate, UITableViewDataSource{
    
    func fetchDataFromFB(){
        db.collection("Favorite")
            .order(by: "date")
            .addSnapshotListener(){ (querySnapshot, error) in
                
//                self.animeModelTemp = []
                
                if let e = error {
                    print("There was an issue retrieving the data \(e)")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        for doc in snapshotDocuments{
                            let data = doc.data()
                            print("this is  the save one \(doc.data())")
                            
                            if let malIDTemp = data["mal_id"] as? Int {
//                                self.moviesFromAPI.filter({$0.mal_id == malIDTemp}).first?.isFavorite = true
                                for (index, movieTemp) in self.moviesFromAPI.enumerated(){
                                    if movieTemp.mal_id == malIDTemp {
                                        self.moviesFromAPI[index].isFavorite = true
                                        self.filteredMovies[index].isFavorite = true
                                    }
                                }
                                
                                
//                                filteredMalID.isFavorite = true
//                               print(filteredMalID.isFavorite)
                                print(self.moviesFromAPI.filter({$0.mal_id == malIDTemp}).first?.isFavorite)
                                self.moviesFromAPI.filter({$0.mal_id == malIDTemp})
//                                $0.isfavorite == true
                            }

                        }
                    }
                }
                self.movieListTV.reloadData()
            }
    }
    
    func getAMItem() {
        manager.fetchAM(){(result) in
            switch result{
                
            case .success(let response):
                print(response)
                self.filteredMovies = response
                self.moviesFromAPI = response
                self.fetchDataFromFB()
               
                
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        
        if indexPath.row < filteredMovies.count{
            
            let item = filteredMovies[indexPath.row]
            cell.setDetail(animeInfo: item)
            
            return cell
            
        }
        //                movieListTV.reloadData()
        //        cell.starButton.addTarget(self, action: #selector(moviesTableViewCell.starIsTapped(_:)), for: .touchUpInside)
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //         let cell = tableView.cellForRow(at: indexPath) as! MoviesTableViewCell
        //        cell.starButton.image = UIImage(systemName: "star.fill")
        //        isTapped != nil
        //        print("unfav")
        //
        
        movieListTV.deselectRow(at: indexPath, animated: true)
        
        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            
            thirdVC.amInfo = filteredMovies[indexPath.row]
            //
            //        thirdVC.amInfo = item
            
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
}

//MARK: - searchbar delegate

extension MoviesVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //        print("unfav2")
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            filteredMovies = moviesFromAPI
        }else{
            
            filteredMovies = moviesFromAPI.filter { $0.title?.lowercased().localizedUppercase
                    .contains(searchBar.searchTextField.text?
                        .lowercased().localizedUppercase ?? "") ?? false }
            
            
            print("searching...")
            
        }
        self.movieListTV.reloadData()
        
    }
}
