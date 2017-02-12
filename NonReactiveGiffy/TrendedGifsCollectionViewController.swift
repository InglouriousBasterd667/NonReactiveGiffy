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

    let height: CGFloat = 44
    var searchBarActive: Bool = false
    var boundsY: CGFloat?
    var searchBar: UISearchBar!
    var switchControl: UISwitch!
    
    struct Constants{
        static let CellReuseID = "GifCell"
    }
    
    let gifsFetcher = GifsFetcher()
    
    var gifs = [Gif](){
        didSet{
            collectionView!.reloadData()
        }
    }
    var query: String = ""
    
    override func viewDidLoad(){
        super.viewDidLoad()
        gifsFetcher.getGifs(with: query) { gifs in self.gifs = gifs }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.boundsY = (self.navigationController?.navigationBar.frame.size.height)! +
                        UIApplication.shared.statusBarFrame.size.height
        prepareUI()
    }
    
    
    func prepareUI(){
        if query == ""{
            self.addSearchBar()
        } else{
            self.addLabel()
            self.addSwitchControl()
        }
        let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsetsMake(height, 0, 0, 0)
        collectionViewLayout?.invalidateLayout()
    }
    

    func addSearchBar(){
        if self.searchBar == nil{
            
            self.searchBar = UISearchBar(frame: CGRect(x: 0,
                                                       y: self.boundsY!,
                                                       width: UIScreen.main.bounds.size.width,
                                                       height: 44))
        
            self.searchBar.searchBarStyle = .prominent
            self.searchBar.tintColor = .white
            self.searchBar.barTintColor = .orange
            self.searchBar.placeholder = "Find GIFs";
            self.searchBar.delegate = self
            
        }
        
        if !self.searchBar.isDescendant(of: self.view){
            self.view.addSubview(self.searchBar)
        }
    }
    
    func addSwitchControl(){
        if self.switchControl == nil{
            let switchWidth: CGFloat = 30
            self.switchControl = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - switchWidth*2,
                                                        y: boundsY! + 5,
                                                        width: switchWidth,
                                                        height: height))
            switchControl.addTarget(self, action: #selector(self.switchValueDidChanged(sender:)), for: .valueChanged);
            self.switchControl.setOn(true, animated: true)
        }
        
        if !self.switchControl.isDescendant(of: self.view){
            self.view.addSubview(self.switchControl!)
        }
    }
    
    func addLabel(){
        let label = UILabel(frame: CGRect(x: 0,
                                          y: self.boundsY!,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44))
        label.text = "FAMILY MODE"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if !label.isDescendant(of: self.view){
            self.view.addSubview(label)
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "GifsCollecitonViewController") as? TrendedGifsCollectionViewController else {
            print("Could not instantiate view controller with identifier of type GifsCollecitonViewController")
            return
        }
        if let query = searchBar.text{
            vc.title = query.uppercased()
            vc.query = query
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func switchValueDidChanged(sender: UISwitch){
        collectionView!.reloadData()
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
            let gif = gifs[indexPath.row]
            
            gifCell.gif = gifs[indexPath.row]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let height = self.gifs[indexPath.row].height
        return CGSize(width: UIScreen.main.bounds.size.width / 2 - 3,
                      height: CGFloat(height))
    }
    
}

