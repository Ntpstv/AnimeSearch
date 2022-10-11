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
import ProgressHUD


class MoviesVC: UIViewController, UITextFieldDelegate, AMDataManagerDelegate{
    
    func didUpdateAMData(_nytDataManager: AMDataManager, Results: Data) {
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    //MARK: - IBOutlets
    
    @IBOutlet weak var movieListTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var bookMark: UIBarButtonItem!
    
    //MARK: - Vars
    private var search: [AMData] = []
    let manager = AMDataManager()
    var filteredMovies = [Data]()
    var fetchFromDB = [Data]()
    var moviesFromAPI = [Data]()
    var moviesTableViewCell = MoviesTableViewCell()
    var animeNameTextField: UITextField!
    var delegate: AMDataManagerDelegate?
    var animeModel: Data?
    
    let animeURL = "https://api.jikan.moe/v4/anime?"
    var url = "https://cdn.myanimelist.net/images/anime/7/57855.jpg"
    
    let db = Firestore.firestore()
    
    //MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProgressHUD.show()
        self.navigationController?.isNavigationBarHidden = false
        
        let title = UIImage(named: "AMMovie.png")
        let imageView = UIImageView(image:title)
        self.navigationItem.titleView = imageView
        getAMItem()
        getItemsFromUserDefaults()
        
        animeNameTextField?.delegate = self
        searchBar.delegate = self
        
    }
    
    //MARK: - IBActions
    
    @IBAction func logOutButton(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
            
            let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav_Login")
            DispatchQueue.main.async {
                loginView.modalPresentationStyle = .fullScreen
                self.present(loginView, animated: true)
            }
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func FavoriteBtnPressed(_ sender: UIButton) {
        
        if let goToFav = storyboard?.instantiateViewController(withIdentifier: "FavVC") as? FavVC  {
            
            goToFav.filteredMovies = moviesFromAPI.filter({$0.isFavorite == true})
            self.navigationController?.pushViewController(goToFav, animated: true)
            
        }
    }
    //MARK: - persistItems
    func getItemsFromUserDefaults(){
        
        if userDefaults.string(forKey: kTITLE) != nil{
            if let persistItems = userDefaults.string(forKey: kTITLE){
                manager.searchFromBookmark(with: persistItems) { (result) in
                    switch result{
                        
                    case .success(let response):
                        print(response)
                        self.filteredMovies = response
                        self.fetchIsFavFromDB()
                        //                          self.movieListTV.reloadData()
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        
                    }
                }
            }
        }
    }
    //MARK: - BookMark
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
        
        guard let text = animeNameTextField.text, !text.isEmpty else{
            return
        }
        
        searchInBookmark()
        userDefaults.set(text, forKey: kTITLE)
        //        self.movieListTV.reloadData()
        
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
                self.fetchIsFavFromDB()
                self.movieListTV.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
}

//MARK: - TableView Delegate /FetchIsFevToMoviesVC

extension MoviesVC: UITableViewDelegate, UITableViewDataSource{
    
    func fetchIsFavFromDB(){
        
        ProgressHUD.dismiss()
        
        guard let user = Auth.auth().currentUser?.email else { return }
        db.collection(user)
            .order(by: kDATE)
            .getDocuments(completion: {querySnapshot, error in
                
                if let e = error {
                    print("There was an issue retrieving the data \(e)")
                }else{
                    if let snapshotDocuments = querySnapshot?.documents{
                        
                        self.fetchFromDB = [Data]()
                        
                        for doc in snapshotDocuments{
                            
                            let data = doc.data()
                            self.fetchFromDB.append(Data.convertJSONToData(dictionary: data))
                            
                            print("this is  the save one \(doc.data())")
                            
                            if let malIDTemp = data[kMALID] as? Int {
                                
                                for (index, movieTemp) in self.moviesFromAPI.enumerated(){
                                    if movieTemp.mal_id == malIDTemp {
                                        
                                        self.moviesFromAPI[index].isFavorite = true
                                    }
                                }
                                for (index, movieTemp) in self.filteredMovies.enumerated(){
                                    if movieTemp.mal_id == malIDTemp {
                                        
                                        self.filteredMovies[index].isFavorite = true
                                    }
                                }
                            }
                        }
                        self.movieListTV?.reloadData()
                    }
                }
            })
    }
    
    //MARK: - Fetch Alamofire Data
    func getAMItem() {
        manager.fetchAM(){(result) in
            switch result{
                
            case .success(let response):
                print(response)
                self.filteredMovies = response
                self.moviesFromAPI = response
                self.fetchIsFavFromDB()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesTableViewCell", for: indexPath) as! MoviesTableViewCell
        
        if indexPath.row < filteredMovies.count{
            
            let item = filteredMovies[indexPath.row]
            cell.setDetail(animeInfo: item)
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(250)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        movieListTV.deselectRow(at: indexPath, animated: true)
        
        if let thirdVC = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            
            thirdVC.delegate = self
            
            thirdVC.amInfo = filteredMovies[indexPath.row]
            //  thirdVC.setDetail(animeInfo: filteredMovies[indexPath.row])
            self.navigationController?.pushViewController(thirdVC, animated: true)
        }
    }
}

//MARK: - Extension Delegates

extension MoviesVC: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
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

extension MoviesVC: MoviesTableViewCellDelegate {
    
    func favoriteIsTriggered(animeMalID: Int, animeIsFav: Bool) {
        for (index, movieTemp) in filteredMovies.enumerated(){
            if movieTemp.mal_id == animeMalID {
                filteredMovies[index].isFavorite = animeIsFav
            }
        }
        for (index, movieTemp) in moviesFromAPI.enumerated(){
            if movieTemp.mal_id == animeMalID {
                moviesFromAPI[index].isFavorite = animeIsFav
            }
        }
    }
    
    
    func fetchDataFromCell() {
        
    }
    
}
extension MoviesVC: DetailVCDelegate {
    
    func favoriteIsChangedFromDetailVCDelegate(animeMalID: Int, animeIsFav: Bool) {
        
        for (index, movieTemp) in filteredMovies.enumerated(){
            if movieTemp.mal_id == animeMalID {
                filteredMovies[index].isFavorite = animeIsFav
                var indexPathArray = [IndexPath]()
                indexPathArray.append(IndexPath(row: index, section: 0))
                movieListTV.reloadRows(at: indexPathArray, with: .automatic)
            }
        }
        
        for (index, movieTemp) in moviesFromAPI.enumerated(){
            if movieTemp.mal_id == animeMalID {
                moviesFromAPI[index].isFavorite = animeIsFav
            }
        }
    }
    
    func fetchDataFromCellFromDetailVCDelegate() {
        
    }
    
    
}
