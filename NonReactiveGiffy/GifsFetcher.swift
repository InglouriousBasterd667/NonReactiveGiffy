//
//  GifsFetcher.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/10/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GifsFetcher{
    
    struct Constants{
        static let trendedGifsURL: URL! = URL(string: "http://api.giphy.com/v1/gifs/trending?")
        static let searchGifsURL: URL! = URL(string: "http://api.giphy.com/v1/gifs/search?")
    }
    var gifs = [Gif]()
    
    func getTrendedGifs(){
        let params: Parameters = [
            "api_key": "dc6zaTOxFJmzC"
        ]
        
        Alamofire.request(Constants.trendedGifsURL, parameters:params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for (key,subJson):(String, JSON) in json["data"] {
                    let rating = subJson["rating"]
                    let 
                }
//                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
}
