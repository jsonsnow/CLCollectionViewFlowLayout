#### 瀑布流布局工具

* item之间的宽固定
* line之间的高固定

#### 待解决问题
多次调用prepare方法，导致大量top的计算

#### 完成
待解决问题完成，可显示区域优化
___

数据量多的时候不流畅问题待解决
___
卡顿原因为多次调用prepare方法导致，调用prepare的原因为

```
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
```
这个实现，一滑动就把当前布局失效导致计算布局过多，解决方法是去除该实现,下面方法从

```
override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = self.itemAttributes.filter { (layout:UICollectionViewLayoutAttributes) -> Bool in
            return rect.intersects(layout.frame)
        }
        _ = self.sectionHeaderAttributes.filter { (layout:UICollectionViewLayoutAttributes) -> Bool in
            if rect.intersects(layout.frame) {
                result.append(layout)
            }
            return true
        }
        _ = self.sectionFooterAttributes.filter { (layout:UICollectionViewLayoutAttributes) -> Bool in
            if rect.intersects(layout.frame) {
                result.append(layout)
            }
            return true
        }
        return result
    }
```
改为

```
override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let result = self.itemAttributes + sectionHeaderAttributes + sectionFooterAttributes;
         return result
    }
```