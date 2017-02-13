//
//  GifLayout.swift
//  NonReactiveGiffy
//
//  Created by Mikhail Lyapich on 2/13/17.
//  Copyright © 2017 Mikhail Lyapich. All rights reserved.
//

import UIKit

protocol GifLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        heightForGifAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat
    
    func collectionView(_ collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth width: CGFloat) -> CGFloat
}
class GifLayout: UICollectionViewLayout {
    
    var delegate: GifLayoutDelegate!
    
    var numberOfColumns = 2
    var padding: CGFloat = 6.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache{
            if attributes.frame.intersects(rect){
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
        
    override func prepare(){
        if cache.isEmpty{
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            for i in 0 ..< numberOfColumns{
                xOffset.append(CGFloat(i) * columnWidth)
            }
            
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0){
                
                let indexPath = IndexPath(item: item, section: 0)
                
                let width = columnWidth - padding * 2
                let gifHeight = delegate.collectionView(collectionView!,
                                                        heightForGifAtIndexPath: indexPath,
                                                        withWidth: width)
                let annotationHeight = delegate.collectionView(collectionView!,
                                                               heightForGifAtIndexPath: indexPath,
                                                               withWidth: width)
                
                let height = 2 * padding + gifHeight + annotationHeight
                let frame = CGRect(x: xOffset[column],
                                   y: yOffset[column],
                                   width: width,
                                   height: height)
                let insetFrame = frame.insetBy(dx: padding, dy: padding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                if (column >= (numberOfColumns - 1)){
                    column = 0
                }
                else{
                    column += 1
                }
                
            }
        }
    }
    
    
    
    
}
