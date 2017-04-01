//
//  BillLinkCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/6/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class BillLinkCell: UITableViewCell, UITextFieldDelegate
{

    @IBOutlet weak var billLabel: UILabel!
    
    @IBOutlet weak var billTextField: UITextField!
    
    @IBOutlet weak var billNameTextField: UITextField!
    
    var originalText : String?
    var originalName : String?
    var key : String?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        originalText = billTextField.text!
        originalName = billNameTextField.text!
        
        billNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        billNameTextField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEnd)
        
        billTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        billTextField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEnd)
    }
    
    func textFieldDidEnd(_ textField: UITextField)
    {
        originalText = textField.text!
        textField.resignFirstResponder()
        self.endEditing(true)
    }
    
    
    func textFieldDidChange(_ textField: UITextField)
    {
        if(!billTextField.text!.isEmpty && billTextField.text! != originalText)
        {
            let data = ["billLink": billTextField.text! as String, "billName": billNameTextField.text!]
            sendMessage(data: data)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(textField == self.billNameTextField)
        {
            self.billTextField.becomeFirstResponder()
        }
        return true
    }
    
    func sendMessage(data: [String : String])
    {
        let mdata = data
        
        let ref: FIRDatabaseReference!
        
        ref = FIRDatabase.database().reference()
        
        let childUpdates = ["/bills/\(self.key!)": mdata]
        ref.updateChildValues(childUpdates)
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
