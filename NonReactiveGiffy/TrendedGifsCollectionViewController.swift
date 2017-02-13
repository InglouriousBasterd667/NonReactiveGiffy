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
    var boundsY: CGFloat?
    var searchBar: UISearchBar!

    struct Constants {
        static let CellReuseID = "GifCell"
    }

    let gifsFetcher = GifsFetcher()
    var gifs = [Gif]() {
        didSet {
            collectionView!.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gifsFetcher.getGifs { gifs in
            self.gifs = gifs
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        if let layout = collectionView?.collectionViewLayout as? GifLayout {
            layout.delegate = self
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.boundsY = (self.navigationController?.navigationBar.frame.size.height)! +
                        UIApplication.shared.statusBarFrame.size.height
        prepareUI()
    }

    func prepareUI() {
        self.addSearchBar()
        let collectionViewLayout = collectionView?.collectionViewLayout as? GifLayout
        collectionViewLayout?.topInset = searchBar.frame.height
        collectionViewLayout?.invalidateLayout()
    }

    func addSearchBar() {
        if self.searchBar == nil {

            self.searchBar = UISearchBar(frame: CGRect(x: 0,
                                                       y: self.boundsY!,
                                                       width: UIScreen.main.bounds.size.width,
                                                       height: 44))

            self.searchBar.searchBarStyle = .default
            self.searchBar.tintColor = .black
            self.searchBar.barTintColor = .orange
            self.searchBar.placeholder = "Find GIFs"
            self.searchBar.delegate = self

        }
        if !self.searchBar.isDescendant(of: self.view) {
            self.view.addSubview(self.searchBar!)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "SearchedCollecitonViewController") as? SearchedGifsCollecitonViewController else {
            print("Could not instantiate view controller with identifier of type GifsCollecitonViewController")
            return
        }
        if let query = searchBar.text {
            vc.title = query.uppercased()
            vc.query = query
            searchBar.text = ""
            searchBar.resignFirstResponder()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func dismissKeyboard() {
        searchBar?.resignFirstResponder()
    }

}

extension TrendedGifsCollectionViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID, for: indexPath)
        if let gifCell = cell as? GifCollectionViewCell {
            gifCell.gif = gifs[indexPath.row]
        }

        return cell
    }

}

extension TrendedGifsCollectionViewController: GifLayoutDelegate{
    
    func collectionView(_ collectionView:UICollectionView,
                        heightForGifAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let height = gifs[indexPath.item].height
        return CGFloat(height)
    }
    
    // 2
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        return CGFloat(gifs[indexPath.item].heightOfComment)
    }
}

//extension TrendedGifsCollectionViewController: UICollectionViewDelegateFlowLayout{
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let height = self.gifs[indexPath.row].height
//        return CGSize(width: UIScreen.main.bounds.size.width / 2 - 3,
//                      height: CGFloat(height))
//    }
//}
