//
//  Extension.swift
//  Anime
//
//  Created by Nattapat Soonthornvech on 29/08/2022.
//

import Foundation
import UIKit

extension UIImageView{

    public func imageFromUrl(urlString: String) {
       if let url = NSURL(string: urlString){
           
           let request: URLRequest = URLRequest(url: url as URL)
           NSURLConnection.sendAsynchronousRequest(request, queue: .main) { response, data, error in
               
               if let data = data {
                   self.image = UIImage(data: data)
               }
           }

       }
   }
}

