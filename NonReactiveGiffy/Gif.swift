//
//  Gif.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/9/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import Foundation

class Gif{
    var url: URL
    var width: Float
    var height: Float
    var rating: String?
    var trended: Date?
    
    init(url: URL, width: Float, height: Float, rating: String?, trended: Date?) {
        self.url = url
        self.width = width
        self.height = height
        self.rating = rating
        self.trended = trended
    }
}
