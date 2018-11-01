//
//  CLCollectionViewLayoutAttributes.swift
//  CLCollectionViewFlowLayout
//
//  Created by chen liang on 2018/9/21.
//  Copyright © 2018年 chen liang. All rights reserved.
//

import UIKit

public class CLCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    struct CLSite {
        var section = 0
        var row = 0
        var line = 0
    }
    //MARK:- props
    //上一个布局属性
    weak var pre:CLCollectionViewLayoutAttributes?
    //下一个布局属性
    weak var next:CLCollectionViewLayoutAttributes?
    //顶部布局属性
    weak var top:CLCollectionViewLayoutAttributes? {
        if self.site.row == 0 {
            return nil
        } else {
            if tempTop != nil {
                return tempTop
            }
            if self.pre == nil {
                return nil
            }
            var temp = self.pre
            while temp != nil {
                if (temp!.site.row == (self.site.row - 1)) && (temp!.site.line == self.site.line) {
                    tempTop = temp
                    return temp
                }
                temp = temp?.pre
            }
            return nil
        }
    }
    var tempTop:CLCollectionViewLayoutAttributes?
    
    //底部布局属性
    weak var bottom:CLCollectionViewLayoutAttributes?
    //所在的行数
    var site:CLSite!
    
    override var description: String {
        return "size(section:\(self.site.section),row:\(self.site.row),line:\(self.site.line))"
    }
}
