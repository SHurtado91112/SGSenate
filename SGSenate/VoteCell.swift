//
//  VoteCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/27/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import DLRadioButton

class VoteCell: UITableViewCell
{

    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var yesRadio: DLRadioButton!
    
    @IBOutlet weak var noRadio: DLRadioButton!
    
    @IBOutlet weak var writeInTextField: UITextField!
    
    var otherButtons : [DLRadioButton] = [DLRadioButton]()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.otherButtons.append(self.noRadio)
        
        self.yesRadio.otherButtons = self.otherButtons
    }

    
    @IBAction func yesChecked(_ sender: Any)
    {
        //self.yesRadio.selected()
        //self.yesRadio.deselectOtherButtons()
    }
    
    @IBAction func noChecked(_ sender: Any)
    {
        //self.noRadio.selected()
        //self.noRadio.deselectOtherButtons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
