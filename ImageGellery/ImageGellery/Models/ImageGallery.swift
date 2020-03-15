//
//  ImageGallery.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/03/10.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import Foundation
import UIKit



struct Gallery<Element>: GenericGalleryProtocol {
    
    private var galleryModel: [Element?] = []
    private var title: String? = nil
    
    var count: Int  {
        return galleryModel.count
    }
    
    mutating func remove(at sourceIndexPathItem: Int) {
        galleryModel.remove(at: sourceIndexPathItem)
    }
    
    mutating func insert(_ item: Element, at destinationIndexPathItem: Int) {
        galleryModel.insert(item, at: destinationIndexPathItem)
    }
    
    func getTitle() -> String {
        guard let title = self.title else { return "" }
        return title
    }
    
    mutating func setTitle(title: String) {
        if (self.title == nil) {
            self.title = title
        }
    }
    
    subscript(i: Int) -> Element? {
        guard let item = galleryModel[i] else { return nil }
        return item
    }
    
    typealias Item = Element

}
//
//struct ImageGallery {
//    private var imageModel: [UIImage] = []
//    private var title: String? = nil
//
//    subscript(i: Int) -> UIImage {
//        return imageModel[i]
//
//    }
//
//    mutating func remove(at sourceIndexPathItem: Int) {
//        imageModel.remove(at: sourceIndexPathItem)
//    }
//
//    mutating func insert(_ image: UIImage, at destinationIndexPathItem: Int) {
//        imageModel.insert(image, at: destinationIndexPathItem)
//    }
//
//    var count: Int {
//        return imageModel.count
//    }
//
//    mutating func setTitle(title: String) {
//        self.title = title
//    }
//
//    mutating func getTitle() -> String? {
//        return self.title
//    }
//}

protocol GenericGalleryProtocol {
    associatedtype Item
    
    mutating func remove(at sourceIndexPathItem: Int)
    mutating func insert(_ image: Item, at destinationIndexPathItem: Int)
    
    func getTitle() -> String
    mutating func setTitle(title: String)
    
    subscript(i: Int) -> Item? { get }
}
