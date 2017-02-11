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
    
    var gif: Gif?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        self.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        if let url = gif?.url{
            DispatchQueue.global(qos: .userInitiated).async{
                let data = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let gifData = data, url == self.gif?.url {
                        let gif = UIImage.gif(data: gifData)
                        self.gifImageView.image = gif
                        self.sizeToFit()
                    }
                }
            }
        }
    }
}
