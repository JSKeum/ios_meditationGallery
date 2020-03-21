//
//  TextFieldTableViewCell.swift
//  ImageGellery
//
//  Created by JSKeum on 2020/03/21.
//  Copyright © 2020 JSKeum. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // This method is called after the text field resigns its first responder status
    
    // 클로저 활용의 좋은 예
    var resignationClousre: (() -> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        resignationClousre?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }

}
