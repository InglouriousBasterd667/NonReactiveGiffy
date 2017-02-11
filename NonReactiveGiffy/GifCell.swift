//
//  GifCell.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/11/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import UIKit

class GifCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var gifImageView: UIImageView!
    
    var gif: Gif?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
       print("i wanna update!")
    }
}
