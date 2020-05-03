//
//  ImageGalleryTableViewController.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/02/12.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import UIKit

class ImageGalleryTableViewController: UITableViewController {
    
    // sample models
    private var galleryList: [String?] = []
    private var unusedGalleryList: [String?] = []
    
    private var sections = ["Gallery List", "Unused List"]
    //
    
    private var gallerySection: Int? {
        return sections.firstIndex(of: "Gallery List")
    }
    
    private var deletedSection: Int? {
        return sections.firstIndex(of: "Unused List")
    }
    
    private var tableTitle: String = "Table"
    
    private var isAdding: Bool = false
    
    @IBAction func changeToAddingMode(_ sender: UIBarButtonItem) {
        if (!isAdding) {
            isAdding = true
            galleryList = [""] + galleryList
            tableView.insertRows(at: [IndexPath(row: 0, section: gallerySection!)], with: .top)
        }
    }
    
    func addGallery() {
        tableView.performBatchUpdates({
            galleryList += [tableTitle]
            tableView.insertRows(at: [IndexPath(row: 0, section: gallerySection!)], with: .top)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return galleryList.count
        case 1: return unusedGalleryList.count
        default:
            return 0
        }
    }
    
    private let cellIdentifier = "galleryTitle"
    
    
    //    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        if let inputCell = cell as? TextFieldTableViewCell {
    //            inputCell.textField.becomeFirstResponder()
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (isAdding && (indexPath == IndexPath(row: 0, section: gallerySection!))) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextField", for: indexPath)
            if let inputCell = cell as? TextFieldTableViewCell {
                inputCell.textField.becomeFirstResponder()
                inputCell.resignationClousre = { [weak self, unowned inputCell] in
                    if let text = inputCell.textField.text {
                        
                        self?.galleryList[0] = text
                    }
                    self?.isAdding = false
                    // 지금은 batch 대신 reloadData를 써야겠다.
                    tableView.reloadData()
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            // custom cell
            if let titleCell = cell as? ImageGalleryTableViewCell {
                titleCell.title?.text = (indexPath.section == gallerySection) ? galleryList[indexPath.row] : unusedGalleryList[indexPath.row]
            }
            
            return cell
        }
    }
    
    // swipe delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if (indexPath.section == gallerySection) {
                let deletedItem = galleryList[indexPath.row] ?? nil
                
                // WWDC 2018 Collection View 예제에서는 먼저 reloadItems를 해줬지만, 왠지 안하고 performBatch 하나만 해도 된다. Collection View 에서도 그럴까?
                
                tableView.performBatchUpdates({
                    
                    galleryList.remove(at: indexPath.row)
                    unusedGalleryList.insert(deletedItem, at: 0)
                    
                    tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: deletedSection!))
                })
            }
                
            else if (indexPath.section == deletedSection) {
                
                unusedGalleryList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
    }
    
    // *** stored properties used in extensions
    private var beforeIndexPath: IndexPath? = nil
}

// swipe tableView
extension ImageGalleryTableViewController {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay {
            splitViewController?.preferredDisplayMode = .primaryOverlay
        }
    }
}

// segue
extension ImageGalleryTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "galleryAction" {
            
            guard let idx = tableView.indexPathForSelectedRow?.row else { return  }
            
            if let cvc = segue.destination as? ImageGalleryViewController, let title = galleryList[idx]{
                
                if (cvc.getGalleryTitle() == nil) { cvc.closureFromTableView = { [weak cvc] in
                    cvc?.setGalleryTitle(title)
                    }
                    
                }
            }                        
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if ( beforeIndexPath != indexPath ) {
            if let beforeIdxPath = beforeIndexPath {
                tableView.deselectRow(at: beforeIdxPath, animated: true)
            }
            
            if (indexPath.section == gallerySection) {
                performSegue(withIdentifier: "galleryAction", sender: self)
            }
        }
        beforeIndexPath = indexPath
    }
}
