//
//  CLCollectionConvenientFlowLayout.swift
//  CLCollectionViewFlowLayout
//
//  Created by chen liang on 2018/9/18.
//  Copyright © 2018年 chen liang. All rights reserved.
//

import UIKit

//不设置sectionView的时候，实现固定item宽，和line高的的快捷实现，设置对应的fixedItemSpace、和fixedLineSpace即可
public class CLCollectionConvenientFlowLayout: CLCollectionViewFlowLayout {

    //MARK: - props
    //默认itemSpace为10间距
    public var fixedItemSpace:CGFloat = 10
    override var minimumInteritemSpacing: CGFloat {
        set {
            super.minimumInteritemSpacing = newValue
            fixedItemSpace = newValue
        }
        get {
            return self.fixedItemSpace
        }
    }
    //默认LineSpace为10间距
    public var fixedLineSpace:CGFloat = 10
    override var minimumLineSpacing: CGFloat {
        set {
            super.minimumLineSpacing = newValue
            fixedLineSpace = newValue
        }
        get {
            return self.fixedLineSpace
        }
    }
    
    override func checkDelegate() {
        
    }
    
    override func itemSize(at indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
}
