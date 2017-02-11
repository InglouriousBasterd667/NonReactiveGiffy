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
    
    
    func getTrendedGifs(setGifs: @escaping ([Gif])-> Void){
        let params: Parameters = [
            "api_key": "dc6zaTOxFJmzC"
        ]
        
        Alamofire.request(Constants.trendedGifsURL, parameters:params).responseJSON {[weak weakSelf = self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                setGifs(weakSelf!.gifsFromJson(json: json))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func gifsFromJson(json: JSON) -> [Gif]{
        let imageSize = "fixed_width"
        
        var gifs = [Gif]()
        for (_,subJson):(String, JSON) in json["data"] {
            let rating = subJson["rating"].string
            if let url = subJson["images"][imageSize]["url"].url,
            let width = subJson["images"][imageSize]["width"].string,
            let height = subJson["images"][imageSize]["height"].string{
                if let floatWidth = Float(width), let floatHeight = Float(height){
                    let gif = Gif(url: url, width: floatWidth, height: floatHeight, rating: rating)
                    gifs.append(gif)
                }
            }
        }
        return gifs
    }
}
