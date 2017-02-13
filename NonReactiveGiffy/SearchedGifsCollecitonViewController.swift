//
//  SearchedGifsCollecitonViewController.swift
//  
//
//  Created by Mikhail Lyapich on 2/12/17.
//
//

import UIKit

class SearchedGifsCollecitonViewController: UICollectionViewController {

    let height: CGFloat = 44
    var boundsY: CGFloat?
    var switchControl: UISwitch!

    struct Constants {
        static let CellReuseID = "GifCell"
    }

    let gifsFetcher = GifsFetcher()
    var familyGifs = [Gif]()
    var query: String = ""
    var gifs = [Gif]() {
        didSet {
            collectionView!.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gifsFetcher.getGifs(with: query) { gifs in
            self.gifs = gifs
            self.familyGifs = gifs.filter { gif in return gif.isFamilyGif}
        }
        if let layout = collectionView?.collectionViewLayout as? GifLayout{
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
        self.addLabel()
        self.addSwitchControl()
        let collectionViewLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        collectionViewLayout?.invalidateLayout()
    }

    func addSwitchControl() {
        if self.switchControl == nil {
            let switchWidth: CGFloat = 30
            self.switchControl = UISwitch(frame: CGRect(x: UIScreen.main.bounds.width - switchWidth*2,
                                                        y: boundsY! + 5,
                                                        width: switchWidth,
                                                        height: height))
            switchControl?.addTarget(self, action: #selector(self.switchValueDidChanged(sender:)), for: .valueChanged)
            self.switchControl?.setOn(true, animated: true)
        }

        if !self.switchControl!.isDescendant(of: self.view) {
            self.view.addSubview(self.switchControl!)
        }
    }

    func addLabel() {
        let label = UILabel(frame: CGRect(x: 0,
                                          y: self.boundsY!,
                                          width: UIScreen.main.bounds.size.width,
                                          height: 44))
        label.text = "FAMILY MODE"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        if !label.isDescendant(of: self.view) {
            self.view.addSubview(label)
        }
    }

    func switchValueDidChanged(sender: UISwitch) {
        collectionView!.reloadData()
    }
}

extension SearchedGifsCollecitonViewController: GifLayoutDelegate{
    
    func collectionView(_ collectionView:UICollectionView,
                        heightForGifAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let height = switchControl.isOn ? familyGifs[indexPath.item].height : gifs[indexPath.item].height
        return CGFloat(height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat {
        let commentHeight = switchControl.isOn ? familyGifs[indexPath.item].heightOfComment : gifs[indexPath.item].heightOfComment
        return CGFloat(commentHeight)
    }
}
extension SearchedGifsCollecitonViewController {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = gifs.count
        if let swControl = switchControl, swControl.isOn {
            count = familyGifs.count
        }
        return count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID, for: indexPath)
        if let gifCell = cell as? GifCollectionViewCell {
            if let swControl = switchControl, swControl.isOn {
                gifCell.gif = familyGifs[indexPath.row]
            } else {
                gifCell.gif = gifs[indexPath.row]
            }
        }
        return cell
    }



}
