//
//  ViewController.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/02/12.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //    private var detailVC: ImageDetailViewController? = ImageDetailViewController()
    
    //    var imageModel: [UIImage] = []
    private var imageGallery = Gallery<UIImage>()
    
    private var galleryTitle: String?
    
    // *** collectionVeiw stuffs
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            galleryCollectionView.delegate = self
            galleryCollectionView.dataSource = self
            
            //    galleryCollectionView.addInteraction(UIDropInteraction(delegate: self))
            galleryCollectionView.dragDelegate = self
            galleryCollectionView.dropDelegate = self
            
            galleryCollectionView.collectionViewLayout = ColumnFlowLayout()
            //            galleryCollectionView.collectionViewLayout = MosaicLayout()
            
            
            // 셀 간 간격 조정
            galleryCollectionView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageGallery.count
    }
    
    private let cellIdentifier = "imageCell"
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        if let customCell = cell as? GalleryCell {
            customCell.cellImage.image = imageGallery[indexPath.row]
            
            //            customCell.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("CollectionView Controller 생성")
    }
    
    var closureFromTableView: (() -> Void)?
    override func viewDidAppear(_ animated: Bool) {
        
        closureFromTableView?()
        
        galleryCollectionView.backgroundColor = (getGalleryTitle() == nil) ? .gray : .clear
    }
}

// implement drag & drop in collectionView
extension ImageGalleryViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    // drag
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragCells(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragCells(at: indexPath)
    }
    
    func dragCells(at indexPath: IndexPath) -> [UIDragItem] {
        if let image = (galleryCollectionView.cellForItem(at: indexPath) as? GalleryCell)?.cellImage.image {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: image))
            dragItem.localObject = image
            return [dragItem]
        } else {
            return []
        }
    }
    
    // drop
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        // 위에 drag canhandle 에서 session localConext 코드 추가한 것 유의
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // batch 핵심.. a bit complex code. collecionView에서 여러 작업을 수행할 때, 즉 동기화가 필요할 때는 아래처럼 batch closure로 감싸야 한다
        // 밑에 ?? indexpath가 언제 적용되는지 모르겠다..
        
        guard getGalleryTitle() != nil else { return }
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: imageGallery.count, section: 0)
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let image = item.dragItem.localObject as? UIImage {
                    collectionView.performBatchUpdates({
                        // update model and collectionView synchronistically
                        imageGallery.remove(at: sourceIndexPath.item)
                        imageGallery.insert(image, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    // 이거 밑에꺼 없어도 드랍 되는데..?? 업데이트 된건가?
                    //                                                            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                    //
                }
            } else {
                // in case dropping from outside
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "DropCell") // identifier in storyboard
                    // you can add a closure here
                )
                
                item.dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (provider, error) in
                    // model 업데이트 될 때만 ui 업데이트 .. ui 업데이트니까 main queue 사용
                    DispatchQueue.main.async {
                        if let image = provider as? UIImage {
                            placeholderContext.commitInsertion { insertionIndexPath in
                                self.imageGallery.insert(image, at: insertionIndexPath.item)
                            }
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
}

// delegate - handle Selection
extension ImageGalleryViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let navController = self.navigationController else { return }
        
        let detailVC = ImageDetailViewController()
        
        if let detailImg = imageGallery[indexPath.item] {
            detailVC.setImage(detailImg)
        }
        
        navController.pushViewController(detailVC, animated: true)
    }
}

// typealiases
extension ImageGalleryViewController {
    typealias GalleryCell = ImageGalleryCollectionViewCell
}

extension ImageGalleryViewController {
    
    /// Get the title of imageGallery
    func getGalleryTitle() -> String? {
        return imageGallery.getTitle()
    }
    
    /// Set gallery title of ColletionView
    func setGalleryTitle(_ title: String) {
        self.imageGallery.setTitle(title: title)
        
    }
}

// CollectionView Header
extension ImageGalleryViewController {
    
    // Supplementary View - CollectionView Title
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reuseIdentifier = "CollectionViewTitle"
        
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let titleView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            
            if let customTitleView = titleView as? ImageGalleryCollectionReusableView {
                customTitleView.backgroundColor = .clear
                customTitleView.title.text = getGalleryTitle() ?? ""
                
            }
            
            return titleView
        default:
            assert(false, "invalid type")
        }
        
    }
}
