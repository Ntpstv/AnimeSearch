//
//  AnimeItem.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 28/08/2022.
//

import Foundation
import FirebaseAuth


    
 struct AMData: Codable {
        let data: [Data]
    }
    
struct Data: Codable {
    var mal_id: Int?
    var url: String?
    var images: Images?
    var score: Double?
    var title: String?
    var synopsis: String?
    var isFavorite: Bool?
    
    
    //MARK: - convert to JSON
    func convertToJSON() -> [String:Any] {
        var request = [String: Any]()
        request["mal_id"] = mal_id
        request["title"] = title
        request["synopsis"] = synopsis
        request["images"] = images?.jpg?.image_url
        request["url"] = url
        request["score"] = score
        request["date"] = Date().timeIntervalSince1970
        
        return request
    }
    
//    static func convertArrayJSONToDataList(arrayJSON: [[String: Any]]) -> [Data] {
//        var datas = [Data]()
//
//        for dictionary in arrayJSON {
//
//            datas.append(Data.convertJSONToData(dictionary: dictionary))
//            
//        }
//
//        return datas
//
//    }
    
    
    static func convertJSONToData(dictionary: [String: Any]) -> Data {
        
        var data = Data()
        
        if let malIDTemp = dictionary[kMALID] as? Int{
            data.mal_id = malIDTemp
        }
        
        if let urlTemp = dictionary[kURL] as? String{
            data.url = urlTemp
        }
        if let imageTemp = dictionary[kIMAGES] as? String{
            data.images =  Images(jpg: Jpg(image_url: imageTemp))
            
        }
        if let scoreTemp = dictionary[kSCORE] as? Double {
            data.score = scoreTemp
        }
        if let titleTemp = dictionary[kTITLE] as? String{
            data.title = titleTemp
        }
        if let synopsisTemp = dictionary[kSYNOPSIS] as? String{
            data.synopsis = synopsisTemp
        }
        if let isFavoriteTemp = dictionary[kISFAVORITE] as? Bool{
            data.isFavorite = isFavoriteTemp
        }
            
            
        return data
        
        
    }
    
    
}

    struct Images: Codable {
        let jpg: Jpg?
        
    }
    struct Jpg: Codable {
        let image_url: String?
        //    let small_image_url : String?
        //    let large_image_url : String?
        
        
    }

//func currentUser() {
//    if Auth.auth().currentUser != nil {
//        
//        if userDefaults.object(forKey: kCURRENTUSER) != nil{
//           
//        }
//    }
//    
//    
//}
    
    
    


