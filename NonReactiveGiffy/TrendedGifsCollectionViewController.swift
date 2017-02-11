//
//  ViewController.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/9/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TrendedGifsCollectionViewController: UICollectionViewController, UISearchBarDelegate {

    var searchBarActive:Bool = false
    var searchBarBoundsY: CGFloat?
    var searchBar:UISearchBar!
    
    struct Constants{
        static let CellReuseID = "GifCell"
    }
    
    let gifsFetcher = GifsFetcher()
    var gifs = [Gif](){
        didSet{
            collectionView?.reloadData()
            print("i'm set")
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        gifsFetcher.getTrendedGifs { gifs in
            self.gifs = gifs
        }
        print("i'm loaded")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareUI()
    }
    
    
    func prepareUI(){
        self.addSearchBar()
//        self.addRefreshControl()
    }
    
    func addSearchBar(){
        if self.searchBar == nil{
            self.searchBarBoundsY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.size.height
            
            self.searchBar = UISearchBar(frame: CGRect(x: 0,
                                                       y: self.searchBarBoundsY!,
                                                       width: UIScreen.main.bounds.size.width,
                                                       height: 44))
            
            self.searchBar.searchBarStyle = .minimal
            self.searchBar.tintColor = .white
            self.searchBar.barTintColor = .white
            self.searchBar.placeholder = "search here";
            self.searchBar.delegate = self
            
        }
        
        if !self.searchBar.isDescendant(of: self.view){
            self.view.addSubview(self.searchBar)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        self.searchBar.setShowsCancelButton(false, animated: false)
    }
}



extension TrendedGifsCollectionViewController{
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID, for: indexPath)
        if let gifCell = cell as? GifCollectionViewCell{
            gifCell.gif = gifs[indexPath.row]
        }
        return cell
    }
    
}

