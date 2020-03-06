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
    
    
    @IBAction func addGallery(_ sender: UIBarButtonItem) {
        let newTitle = "newGallery"
        galleryList += [newTitle]
        
        tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // custom cell
        if let titleCell = cell as? ImageGalleryTableViewCell {
            titleCell.title?.text = (indexPath.section == gallerySection) ? galleryList[indexPath.row] : unusedGalleryList[indexPath.row]
            
        }

        
        return cell
    }
    
    // swipe delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        if (indexPath.section == gallerySection) {
            
                let deletedItem = galleryList[indexPath.row] ?? nil
                galleryList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                // model 변경시에 항상 reloaddata 해줘야 한다. 아니면 오류남
                unusedGalleryList += [deletedItem]
                tableView.reloadData()
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
//            if let titleName = (sender as? ImageGalleryTableViewCell)?.title {
                if let cvc = segue.destination as? ImageGalleryViewController {
//                    
                }
//            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let beforeIdxPath = beforeIndexPath {
        tableView.deselectRow(at: beforeIdxPath, animated: true)
        }
//        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: "galleryAction", sender: self)
        
        beforeIndexPath = indexPath
    }
}
