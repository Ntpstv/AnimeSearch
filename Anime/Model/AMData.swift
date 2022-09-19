//
//  AnimeItem.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 28/08/2022.
//

import Foundation

struct AMData: Codable {
    let data: [Data]
}

struct Data: Codable {
    let mal_id: Int
    let url: String?
    let images: Images?
    let score: Double?
    let title: String?
    let synopsis: String?
    var isFavorite: Bool?
}
struct Images: Codable {
    let jpg: Jpg?
    
}
struct Jpg: Codable {
    let image_url: String?
//    let small_image_url : String?
//    let large_image_url : String?
}


