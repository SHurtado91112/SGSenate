//
//  ExpandResultsCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 4/1/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class ExpandResultsCell: UITableViewCell
{
    var canExpand : Bool = false
    
    @IBOutlet weak var leftHandLabel: UILabel!
    
    @IBOutlet weak var rightHandLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
