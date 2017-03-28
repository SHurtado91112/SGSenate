//
//  VoteHeader.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/27/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import LUExpandableTableView

class VoteHeader: UITableViewCell
{

    @IBOutlet weak var detailLabel: UILabel!
    var detailText : String? = nil
    
    override func awakeFromNib()
    {
        //detailLabel.text = detailText!
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) 
    {
        // Drawing code
    }
    */

}
