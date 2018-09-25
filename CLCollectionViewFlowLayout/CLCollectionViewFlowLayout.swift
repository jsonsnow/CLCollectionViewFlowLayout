//
//  CLCollectionViewFlowLayout.swift
//  CLCollectionViewFlowLayout
//
//  Created by chen liang on 2018/9/18.
//  Copyright © 2018年 chen liang. All rights reserved.
//

import UIKit

class CLCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    //MARK: - props
    //item动态宽高则必须实现该协议
    weak var delegate:UICollectionViewDelegateFlowLayout?
   
    private var itemAttributes = [UICollectionViewLayoutAttributes]()
    private var sectionHeaderAttributes = [UICollectionViewLayoutAttributes]()
    private var sectionFooterAttributes = [UICollectionViewLayoutAttributes]()
    
    
    //MARK: - private method
    func layoutHeaderSectionAttris(at section:Int,x:CGFloat, y:CGFloat) -> UICollectionViewLayoutAttributes? {
        if let delegate = self.delegate {
            if delegate.responds(to: #selector(delegate.collectionView(_:layout:minimumLineSpacingForSectionAt:))) {
                let sectionSize = self.delegate!.collectionView!(collectionView!, layout: self, referenceSizeForHeaderInSection: section)
                var sectionHeight:CGFloat = 0
                if sectionSize != CGSize.zero {
                    sectionHeight = sectionSize.height
                    let layoutAttris = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath.init(row: 0, section: section))
                    layoutAttris.frame = CGRect.init(x: x, y: y, width: sectionSize.width, height: sectionHeight)
                    return layoutAttris
                }
            }
        }
        return nil
    }
    
    func layoutFooterSectionAttris(at section:Int, x:CGFloat, y:CGFloat) -> UICollectionViewLayoutAttributes? {
        if let delegate = self.delegate {
            if delegate.responds(to: #selector(delegate.collectionView(_:layout:referenceSizeForFooterInSection:))) {
                let sectionSize = self.delegate!.collectionView!(collectionView!, layout: self, referenceSizeForFooterInSection: section)
                var sectionHeight:CGFloat = 0
                if sectionSize != CGSize.zero {
                    sectionHeight = sectionSize.height
                    let layoutAttris = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath.init(row: 0, section: section))
                    layoutAttris.frame = CGRect.init(x: x, y: y, width: sectionSize.width, height: sectionHeight)
                    return layoutAttris
                }
            }
        }
        return nil
    }
    
    //MARK: - public method
    public func checkDelegate() {
        assert(delegate != nil, "该协议必须实现")
    }
    
    public func itemSize(at indexPath:IndexPath) -> CGSize {
        let size = self.delegate!.collectionView!(self.collectionView!, layout: self, sizeForItemAt: indexPath)
        return size
    }
    
    //MARK: - method to override
    override func prepare() {
        super.prepare()
        checkDelegate()
        guard let collectionView = self.collectionView else { return  }
        let sectionCount = collectionView.numberOfSections
        var xOffset = self.sectionInset.left
        var yOffset = self.sectionInset.top
        var xNextOffset = self.sectionInset.left
        var yNextOffset = self.sectionInset.top
        
        for section in 0..<sectionCount {
            let headerAttris = self.layoutHeaderSectionAttris(at: section, x: xOffset, y: yOffset)
            if headerAttris != nil {
                yOffset = headerAttris!.frame.maxY
                self.sectionHeaderAttributes.append(headerAttris!)
            }
            var pre:CLCollectionViewLayoutAttributes?
            var row = 0
            var line = 0
            for index in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath.init(row: index, section: section)
                let itemSize = self.itemSize(at: indexPath)
                let layoutAttributes = CLCollectionViewLayoutAttributes.init(forCellWith: indexPath)
                if pre == nil {
                    pre = layoutAttributes
                    pre?.pre = nil
                } else {
                    layoutAttributes.pre = pre
                    pre?.next = layoutAttributes
                    pre = layoutAttributes
                }
                xNextOffset += self.minimumInteritemSpacing + itemSize.width
                yNextOffset += self.minimumLineSpacing + itemSize.height
                if xNextOffset > collectionView.bounds.size.width - self.sectionInset.right {
                    xOffset = self.sectionInset.left
                    xNextOffset = self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width
                    row += 1
                    line = 0
                } else {
                    xOffset = xNextOffset - self.minimumInteritemSpacing - itemSize.width
                }
                layoutAttributes.site = CLCollectionViewLayoutAttributes.CLSite(section: section, row: row, line: line)
                line += 1
                if let top = layoutAttributes.top {
                    layoutAttributes.frame = CGRect.init(x: xOffset, y:top.frame.maxY + self.minimumLineSpacing, width: itemSize.width, height: itemSize.height)
                } else {
                    layoutAttributes.frame = CGRect.init(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                }
                self.itemAttributes.append(layoutAttributes)
                if yOffset < layoutAttributes.frame.minY {
                    yOffset = layoutAttributes.frame.minY
                }
            }
            let itemSize = self.itemSize(at: IndexPath.init(row: collectionView.numberOfItems(inSection: section), section: section))
            if let footerAttris = self.layoutFooterSectionAttris(at: section, x: self.sectionInset.left, y: yOffset + itemSize.height) {
                yOffset = footerAttris.frame.maxY
                self.sectionFooterAttributes.append(footerAttris)
            } else {
                yOffset += itemSize.height 
            }
            xOffset = self.sectionInset.left
            xNextOffset = self.sectionInset.left
        }
        for attris in self.itemAttributes {
            print("\(attris)")
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.itemAttributes[indexPath.row]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = self.itemAttributes.filter { (layout:UICollectionViewLayoutAttributes) -> Bool in
            return rect.contains(layout.frame)
        }
        _ = self.sectionHeaderAttributes.filter { (layout:UICollectionViewLayoutAttributes) -> Bool in
            if rect.contains(layout.frame) {
                result.append(layout)
            }
            return true
        }
        _ = self.sectionFooterAttributes.filter { (layout:UICollectionViewLayoutAttributes) -> Bool in
            if rect.contains(layout.frame) {
                result.append(layout)
            }
            return true
        }
        return result
    }
    
    override var collectionViewContentSize: CGSize {
        var  max:CGFloat = 0
        for attri in self.itemAttributes {
            if max < attri.frame.maxY {
                max = attri.frame.maxY
            }
        }
        
        for attri in self.sectionFooterAttributes {
            if max < attri.frame.maxY {
                max = attri.frame.maxY
            }
        }
        return CGSize.init(width: collectionView!.frame.size.width, height: max)
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if elementKind == UICollectionElementKindSectionHeader {
            return self.sectionHeaderAttributes[indexPath.row]
        }
        if elementKind == UICollectionElementKindSectionFooter {
            return self.sectionFooterAttributes[indexPath.row]
        }
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
    

}
