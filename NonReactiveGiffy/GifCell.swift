//
//  GifCell.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/11/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import UIKit
import Alamofire
import SwiftGifOrigin

class GifCollectionViewCell: UICollectionViewCell {
    @IBOutlet var gifImageView: UIImageView!
    
    @IBOutlet var trended: UILabel!
    var gif: Gif?{
        didSet{
            if let date = gif?.trended {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateNew = dateFormatter.string(from: date)
                trended.text = dateNew
            }
            if let image = gif?.image{
                gifImageView.image = image
            }
            else{
                loadImage()
            }
        }
    }
    
    private func loadImage(){
        self.gifImageView.backgroundColor = .orange
        if let url = gif?.url{
            DispatchQueue.global(qos: .userInitiated).async{
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let gifData = data, url == self.gif?.url {
                        let gifImage = UIImage.gif(data: gifData)
                        self.gif?.image = gifImage
                        self.gifImageView.image = gifImage
                    }
                    else{
                        self.gif?.image = nil
                        print("hi")
                    }
                }
            }
        }
    }
}
