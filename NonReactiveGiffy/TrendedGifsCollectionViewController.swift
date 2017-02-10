//
//  ViewController.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/9/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import UIKit

class TrendedGifsCollectionViewController: UIViewController {

    let gifsFetcher = GifsFetcher()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        gifsFetcher.getTrendedGifs()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func getData(_ sender: Any) {
//        getTrendedGifs()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

