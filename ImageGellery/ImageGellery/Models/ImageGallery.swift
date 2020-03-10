//
//  ImageGallery.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/03/10.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import Foundation
import UIKit

struct ImageGallery {
    private var imageModel: [UIImage] = []
    private var title: String? = nil
    
    subscript(i: Int) -> UIImage {
        return imageModel[i]
        
    }
    
    mutating func remove(at sourceIndexPathItem: Int) {
        imageModel.remove(at: sourceIndexPathItem)
    }
    
    mutating func insert(_ image: UIImage, at destinationIndexPathItem: Int) {
        imageModel.insert(image, at: destinationIndexPathItem)
    }
    
    var count: Int {
        return imageModel.count
    }

    mutating func addImage(image: UIImage) {
        imageModel.append(image)
        
    }
    
    mutating func deleteImage(image: UIImage) {
    }
    
    mutating func setTitle(title: String) {
        self.title = title
    }
    
    mutating func getTitle() -> String? {
        return self.title
    }
}
