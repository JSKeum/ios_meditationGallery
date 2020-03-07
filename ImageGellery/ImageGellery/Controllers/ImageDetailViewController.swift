//
//  ImageDetailViewController.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/03/07.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    private var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.sizeToFit()
        
        view.addSubview(imageView)
        
        // Do any additional setup after loading the view.
    }
    
    func setImage(_ image :UIImage) {
        self.image = image
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
