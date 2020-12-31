//
//  CustomFlowLayout.swift
//  RealmInAppBrowser
//
//  Created by Matt on 08.10.20.
//  Copyright © 2020 Matthias Brodalka. All rights reserved.
//
//copied solution
//https://stackoverflow.com/questions/21968511/preventing-wrapping-of-items-in-uicollectionview

import Foundation
import UIKit

class NoBreakSectionCollectionViewLayout: UICollectionViewLayout {

    var itemSize: CGSize
    var interItemSpacingY: CGFloat
    var interItemSpacingX: CGFloat
    var layoutInfo: [IndexPath: UICollectionViewLayoutAttributes]

    override init() {
      itemSize = CGSize(width: 250, height: 44)
      interItemSpacingY = 1
      interItemSpacingX = 1
      layoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()

      super.init()
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
      guard let collectionView = self.collectionView else {
        return
      }

      var cellLayoutInfo = [IndexPath: UICollectionViewLayoutAttributes]()
      var indexPath = IndexPath(item: 0, section: 0)

      let sectionCount = collectionView.numberOfSections
      for section in 0..<sectionCount {

        let itemCount = collectionView.numberOfItems(inSection: section)
        for item in 0..<itemCount {
          indexPath = IndexPath(item: item, section: section)
          let itemAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          itemAttributes.frame = frameForCell(at: indexPath)
          cellLayoutInfo[indexPath] = itemAttributes
        }

        self.layoutInfo = cellLayoutInfo
      }
    }

    func frameForCell(at indexPath: IndexPath) -> CGRect {
      let row = indexPath.section
      let column = indexPath.item

      let originX = (itemSize.width + interItemSpacingX) * CGFloat(column)
      let originY = (itemSize.height + interItemSpacingY) * CGFloat(row)

      return CGRect(x: originX, y: originY, width: itemSize.width, height: itemSize.height)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
      var allAttributes = Array<UICollectionViewLayoutAttributes>()

      for (_, attributes) in self.layoutInfo {
        if (rect.intersects(attributes.frame)) {
          allAttributes.append(attributes)
        }
      }
      return allAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return self.layoutInfo[indexPath]
    }

    override var collectionViewContentSize: CGSize {
      guard let collectionView = self.collectionView else {
        return .zero
      }

      let sectionCount = collectionView.numberOfSections
      let height = (itemSize.height + interItemSpacingY) * CGFloat(sectionCount)

      let itemCount = Array(0..<sectionCount)
        .map { collectionView.numberOfItems(inSection: $0) }
        .max() ?? 0

      let width  = (itemSize.width + interItemSpacingX) * CGFloat(itemCount)

      return CGSize(width: width, height: height)

    }
}
