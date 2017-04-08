//
//  VoteCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/27/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import DLRadioButton
import Firebase

class VoteCell: UITableViewCell
{

    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var yesRadio: DLRadioButton!
    
    @IBOutlet weak var noRadio: DLRadioButton!
    
    @IBOutlet weak var writeInTextField: UITextField!
    
    var indexPath = IndexPath()
    
    var otherButtons : [DLRadioButton] = [DLRadioButton]()
    
    var ref : FIRDatabaseReference!
    var user: FIRUser?
    var cellSnap: FIRDataSnapshot!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.otherButtons.append(self.noRadio)
        
        self.yesRadio.otherButtons = self.otherButtons
    }
    
    @IBAction func yesChecked(_ sender: Any)
    {
        print("Yes selected")
        print(self.indexPath)
        
        ref = FIRDatabase.database().reference()
        
        //replace tempUserName w/ Util._currentUserName!
        
        let tempUserName = "[User PlaceHolder]"
        
        switch(self.indexPath.section)
        {
            case 0:
                let childUpdates = ["/result/bills/\(cellSnap.key)/votes/\(String(describing: (Util._currentUser?.uid)!))" :[ "user" : "\(tempUserName)", "vote" :"yes"]]
                self.ref.updateChildValues(childUpdates)
                break;
            case 1:
                let childUpdates = ["/result/misc/\(cellSnap.key)/votes/\(String(describing: (Util._currentUser?.uid)!))" :[ "user" : "\(tempUserName)", "vote" :"yes"]]
                self.ref.updateChildValues(childUpdates)
                break;
            default:
                break;
        }
        
        
    }
    
    @IBAction func noChecked(_ sender: Any)
    {
        print("No selected")
        print(self.indexPath)
        
        ref = FIRDatabase.database().reference()

        //replace tempUserName w/ Util._currentUserName!
        
        let tempUserName = "[User PlaceHolder]"
        
        switch(self.indexPath.section)
        {
        case 0:
            let childUpdates = ["/result/bills/\(cellSnap.key)/votes/\(String(describing: self.user?.uid))" :[ "user" : "\(tempUserName)", "vote" :"no"]]
            self.ref.updateChildValues(childUpdates)
            break;
        case 1:
            let childUpdates = ["/result/misc/\(cellSnap.key)/votes/\(String(describing: self.user?.uid))" :[ "user" : "\(tempUserName)", "vote" :"no"]]
            self.ref.updateChildValues(childUpdates)
            break;
        default:
            break;
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
