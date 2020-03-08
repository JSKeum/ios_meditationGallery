//
//  ImageGalleryCollectionViewCell.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/03/05.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cellImage: UIImageView! {
        didSet {
            cellImage.sizeToFit()
            
//            self.bounds = CGSize(0, 0)
        }
    }
}
