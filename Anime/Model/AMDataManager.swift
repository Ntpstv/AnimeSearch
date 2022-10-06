//
//  AMDataManager.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 29/08/2022.
//

import Foundation
import Alamofire



protocol AMDataManagerDelegate: AnyObject {
    func didUpdateAMData(_nytDataManager: AMDataManager, Results: Data)
    func didFailWithError(error: Error)
}

struct AMDataManager{
    
    var delegate: AMDataManagerDelegate?
//    var amData = [Data]()
    
    let animeURL = "https://api.jikan.moe/v4/anime"
    
    func fetchAM(completion: @escaping (Result<[Data], Error>)-> Void){
//        https://api.jikan.moe/v4/anime?q=xxxxxx
        
        let urlString = "\(animeURL)"
        print(urlString)
        
        AF.request(urlString).responseDecodable(of: AMData.self, queue: .main, decoder: JSONDecoder()) { (response) in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data.data))
                
            case .failure(let error):
                print("error: \(error)")
                
                completion(.failure(error))
            }
        }
    }
    
    public func searchFromBookmark(with query: String, completion: @escaping (Result<[Data], Error>)-> Void){
        //        https://api.jikan.moe/v4/anime?q=xxxxxx
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = "\(animeURL)?q=\(query)"
        guard let url = URL(string: urlString) else {
            return
        }

                AF.request(url, parameters: nil).responseDecodable(of: AMData.self, queue: .main, decoder: JSONDecoder(), emptyResponseCodes: [200, 204, 205]) { (response) in

                    switch response.result {

                    case .success(let data):
                        completion(.success(data.data))

                    case .failure(let error):
                        print("error: \(error)")

                        completion(.failure(error))
                    }
                }
            }
    
}

