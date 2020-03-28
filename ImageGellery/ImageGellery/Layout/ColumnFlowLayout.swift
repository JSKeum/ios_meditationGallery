//
//  ColumnFlowLayout.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/03/07.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        guard let cv = collectionView else { return }
    
        let availableWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        
        let minColumnWidth = CGFloat(300.0)
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        self.minimumInteritemSpacing = 0.0
        self.minimumLineSpacing = 0.0
        self.itemSize = CGSize(width: cellWidth, height: cellWidth*1.161)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0 )
        self.sectionInsetReference = .fromSafeArea
        
        
        self.headerReferenceSize = CGSize(width: cv.frame.width, height: 50)

    }
}
