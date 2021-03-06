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

class GifsFetcher {

    struct Constants {
        static let trendedGifsURL: URL = URL(string: "http://api.giphy.com/v1/gifs/trending?")!
        static let searchGifsURL: URL = URL(string: "http://api.giphy.com/v1/gifs/search?")!
        static let apiKey: String = "dc6zaTOxFJmzC"
    }

    func getGifs(with query: String = "", setGifs: @escaping ([Gif]) -> Void) {
        var params: Parameters = [
            "api_key": Constants.apiKey
        ]
        var url = Constants.trendedGifsURL
        if query != ""{
            params["q"] = query
            url = Constants.searchGifsURL
        }
        Alamofire.request(url, parameters:params).responseJSON {[weak weakSelf = self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                setGifs(weakSelf!.gifsFromJson(json: json))
            case .failure(let error):
                print(error)
            }
        }
    }

    private func gifsFromJson(json: JSON) -> [Gif] {
        let imageSize = "fixed_width"
        var gifs = [Gif]()
        for (_, subJson):(String, JSON) in json["data"] {
            if let url = subJson["images"][imageSize]["url"].url,
            let width = subJson["images"][imageSize]["width"].string,
            let height = subJson["images"][imageSize]["height"].string,
            let trended = subJson["trending_datetime"].string,
            let rating = subJson["rating"].string {
                if let floatWidth = Float(width), let floatHeight = Float(height) {
                    let gif = Gif(url: url,
                                  width: floatWidth,
                                  height: floatHeight,
                                  rating: rating,
                                  trended: getTrendedDate(from: trended))
                    gifs.append(gif)
                }
            }
        }
        return gifs
    }

    private func getTrendedDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyy-MM-dd HH:mm:ss",
                                                            options: 0,
                                                            locale: nil)
        var trendedDate = dateFormatter.date(from: string)
        let old_date = dateFormatter.date(from: "2000-01-01 00:00:00")
        if let td = trendedDate, let od = old_date, td < od {
            trendedDate = nil
        }
        return trendedDate
    }
}
