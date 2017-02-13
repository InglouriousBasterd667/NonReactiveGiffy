//
//  Gif.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/9/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation
import UIKit

class Gif {
    let url: URL
    let width: Float
    let height: Float
    let rating: String
    let trended: Date?
    let familyRanks: Set = ["y", "g", "pg"]
    var heightOfComment = 22
    
    var isFamilyGif: Bool = false
    var image: UIImage?

    init(url: URL, width: Float, height: Float, rating: String, trended: Date?) {
        self.url = url
        self.width = width
        self.height = height
        self.rating = rating
        self.trended = trended
        if familyRanks.contains(rating) {
            isFamilyGif = true
        }
    }

}
