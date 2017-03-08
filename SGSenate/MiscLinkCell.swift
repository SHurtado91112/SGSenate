//
//  MiscLinkCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/6/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class MiscLinkCell: UITableViewCell
{
    @IBOutlet weak var miscLabel: UILabel!
    @IBOutlet weak var miscTextField: UITextField!
    
    var originalText : String?
    var key : String?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        originalText = miscTextField.text!
        
        miscTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        miscTextField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEnd)
    }
    
    func textFieldDidEnd(_ textField: UITextField)
    {
        originalText = textField.text!
        textField.resignFirstResponder()
        self.endEditing(true)
    }
    
    func textFieldDidChange(_ textField: UITextField)
    {
        if(!miscTextField.text!.isEmpty && miscTextField.text! != originalText)
        {
            let data = ["miscLink": textField.text! as String]
            sendMessage(data: data)
        }
    }
    
    func sendMessage(data: [String:String])
    {
        let mdata = data
        
        let ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        let childUpdates = ["/misc/\(self.key!)": mdata]
        ref.updateChildValues(childUpdates)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
