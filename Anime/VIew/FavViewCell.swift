//
//  FavViewCell.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 07/09/2022.
//

import UIKit

class FavViewCell: UICollectionViewCell {
    
    @IBOutlet weak var amImage: UIImageView!
    @IBOutlet weak var amTitle: UILabel!
    @IBOutlet weak var amDetail: UILabel!
    
    var animeModel: Data?
//    var itemsFromFireBase: ItemsFromFB?
    
    func setView(animeDetail: Data){
        amTitle.text = animeDetail.title
        amDetail.text = animeDetail.synopsis
        amImage.imageFromUrl(urlString: animeDetail.images?.jpg?.image_url ?? "")
//        itemsFromFireBase = animeDetail
    }
    
}
