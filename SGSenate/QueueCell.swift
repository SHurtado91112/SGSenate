//
//  QueueCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class QueueCell: UITableViewCell {

    @IBOutlet weak var queueLabel: UILabel!
    @IBOutlet weak var queueUserLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
