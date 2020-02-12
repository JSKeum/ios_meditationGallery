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
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryTitle", for: indexPath)
        
        if (indexPath.section == gallerySection) {
        cell.textLabel?.text = galleryList[indexPath.row]
        } else if (indexPath.section == deletedSection) {
            cell.textLabel?.text = unusedGalleryList[indexPath.row]
        }
        // Configure the cell...
        
        return cell
    }
    
    private func indexOfSection(indexPath: IndexPath) {
        
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
    
    //        let sectionTitle = sectionIndexTitles(for: tableView)
    //
    //        for title in sectionTitle ?? [] {
    //            if (title == "Gallery List") {
    //                if editingStyle == .delete {
    //                    galleryList.remove(at: indexPath.row)
    //                    tableView.deleteRows(at: [indexPath], with: .fade)
    //                }
    //            }
    //        }
    
    



/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


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
